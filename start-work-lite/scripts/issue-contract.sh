#!/usr/bin/env bash
# Read or write the work contract held in a marked section of an issue body.
#
#   issue-contract.sh preflight              check host, CLI and access; print host=
#   issue-contract.sh inspect ISSUE          print resume facts as key=value lines
#   issue-contract.sh read ISSUE             print the contract; exit 3 if none
#   issue-contract.sh write ISSUE FILE       replace or append the contract
#   issue-contract.sh create TITLE FILE      create an issue holding the contract
#   issue-contract.sh extract < BODY         offline: print the contract in BODY
#   issue-contract.sh splice FILE < BODY     offline: print BODY with FILE spliced in
#
# Uses gh or glab, chosen from the origin remote or START_WORK_HOST=github|gitlab.
# Remotes on other hosts (self-hosted GitLab, GitHub Enterprise) are detected by
# asking glab, then gh, whether they can reach the repository.
set -euo pipefail

BEGIN='<!-- start-work-lite:contract -->'
END='<!-- /start-work-lite:contract -->'

die() { echo "issue-contract: $*" >&2; exit "${2:-1}"; }

need() { command -v "$1" >/dev/null 2>&1 || die "$1 is not installed" 2; }

host() {
  if [[ -n "${START_WORK_HOST:-}" ]]; then echo "$START_WORK_HOST"; return; fi
  local url
  url=$(git remote get-url origin 2>/dev/null) || die "no origin remote; set START_WORK_HOST" 2
  case "$url" in
    *github*) echo github; return ;;
    *gitlab*) echo gitlab; return ;;
  esac
  if command -v glab >/dev/null 2>&1 && glab repo view </dev/null >/dev/null 2>&1; then
    echo gitlab
  elif command -v gh >/dev/null 2>&1 && gh repo view --json name </dev/null >/dev/null 2>&1; then
    echo github
  else
    die "cannot tell host from $url; authenticate gh or glab for it, or set START_WORK_HOST=github|gitlab" 2
  fi
}

fetch_body() {
  case "$HOST" in
    github) gh issue view "$1" --json body -q .body ;;
    # Older glab releases lack --jq, so filter with jq.
    gitlab) glab issue view "$1" -F json | jq -r '.description // ""' ;;
  esac
}

# Print none, one or malformed for the contract markers in the body on stdin.
markers() {
  awk -v b="$BEGIN" -v e="$END" '
    $0 == b { nb++; if (open) bad = 1; open = 1 }
    $0 == e { if (!open) bad = 1; open = 0 }
    END {
      if (bad || open || nb > 1) print "malformed"
      else if (nb) print "one"
      else print "none"
    }
  '
}

# Print the contract in the body on stdin; exit 3 if none, 4 if malformed.
extract() {
  local body
  body=$(tr -d '\r')
  case $(markers <<<"$body") in
    none) return 3 ;;
    malformed) echo "issue-contract: contract markers are unpaired or duplicated" >&2; return 4 ;;
  esac
  awk -v b="$BEGIN" -v e="$END" '
    $0 == e { inside = 0 }
    inside { print }
    $0 == b { inside = 1 }
  ' <<<"$body"
}

splice() {
  local file=$1 body
  body=$(tr -d '\r')
  case $(markers <<<"$body") in
    malformed) die "contract markers are unpaired or duplicated; fix the issue body by hand" ;;
    one)
      awk -v b="$BEGIN" -v e="$END" -v f="$file" '
        $0 == b { print; while ((getline line < f) > 0) print line; skip = 1; next }
        $0 == e { skip = 0 }
        !skip { print }
      ' <<<"$body"
      ;;
    none)
      [[ -n "$body" ]] && printf '%s\n\n' "$body"
      printf '%s\n' "$BEGIN"
      cat "$file"
      printf '%s\n' "$END"
      ;;
  esac
}

push_body() {
  local issue=$1 file=$2
  case "$HOST" in
    github) gh issue edit "$issue" --body-file "$file" >/dev/null ;;
    gitlab) glab issue update "$issue" --description "$(cat "$file")" >/dev/null ;;
  esac
}

preflight() {
  case "$HOST" in
    github)
      need gh
      gh repo view --json name </dev/null >/dev/null 2>&1 ||
        die "gh cannot reach this repository; run gh auth login" 2
      ;;
    gitlab)
      need glab
      need jq
      glab repo view </dev/null >/dev/null 2>&1 ||
        die "glab cannot reach this repository; run glab auth login --hostname <host>" 2
      ;;
  esac
  echo "host=$HOST"
}

default_ref() {
  local ref
  ref=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null) && { echo "$ref"; return; }
  for ref in origin/main origin/master main master; do
    git rev-parse -q --verify "$ref" >/dev/null && { echo "$ref"; return; }
  done
}

# Branch names, local or on origin, that carry the issue number as a token.
task_branches() {
  local default=${1#origin/}
  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin |
    sed 's#^origin/##' | grep -vxE "HEAD|origin|$default" | sort -u |
    grep -E "(^|[/_-])$2([/_-]|$)" || true
}

open_change_request() {
  case "$HOST" in
    github) gh pr list --head "$1" --state open --json url -q '.[0].url // empty' ;;
    gitlab) glab mr list --source-branch "$1" -F json | jq -r '.[0].web_url // empty' ;;
  esac
}

inspect() {
  local issue=$1 body contract revision=absent base branches branch=absent
  local ahead=0 cr=absent next ref status=0
  body=$(fetch_body "$issue") || die "cannot read issue $issue" 2
  contract=$(extract <<<"$body" 2>/dev/null) || status=$?
  case $status in
    0)
      revision=$(sed -n 's/.*\*\*Revision:\*\* *\([0-9][0-9]*\).*/\1/p' <<<"$contract" | head -n 1)
      contract=present
      ;;
    3) contract=absent ;;
    *) contract=malformed ;;
  esac
  base=$(default_ref)
  branches=$(task_branches "${base:-main}" "$issue")
  case $(grep -c . <<<"$branches") in
    0) ;;
    1) branch=$branches ;;
    *) branch="ambiguous:$(paste -sd, - <<<"$branches")" ;;
  esac
  if [[ $branch != absent && $branch != ambiguous:* ]]; then
    ref=$branch
    git rev-parse -q --verify "refs/heads/$branch" >/dev/null || ref="origin/$branch"
    [[ -n $base ]] && ahead=$(git rev-list --count "$base..$ref")
    cr=$(open_change_request "$branch") || die "cannot list change requests for $branch" 2
    [[ -n $cr ]] || cr=absent
  fi
  if [[ $contract == malformed || $branch == ambiguous:* ]]; then next=ask
  elif [[ $cr != absent ]]; then next=review
  elif [[ $ahead -gt 0 ]]; then next=deliver
  elif [[ $contract == present ]]; then next=gate
  else next=investigate
  fi
  printf '%s\n' "issue=$issue" "host=$HOST" "contract=$contract" "revision=${revision:-absent}" \
    "branch=$branch" "base=${base:-absent}" "commits_ahead=$ahead" "change_request=$cr" "next=$next"
}

cmd=${1:-}
case "$cmd" in
  preflight | inspect | read | write | create)
    HOST=$(host)
    [[ $HOST == github || $HOST == gitlab ]] || die "unknown host $HOST" 2
    ;;
esac

case "$cmd" in
  preflight)
    [[ $# -eq 1 ]] || die "usage: preflight"
    preflight
    ;;
  inspect)
    [[ $# -eq 2 ]] || die "usage: inspect ISSUE"
    inspect "$2"
    ;;
  read)
    [[ $# -eq 2 ]] || die "usage: read ISSUE"
    body=$(fetch_body "$2")
    status=0
    extract <<<"$body" || status=$?
    [[ $status -eq 3 ]] && die "issue $2 holds no contract" 3
    exit "$status"
    ;;
  write)
    [[ $# -eq 3 && -f $3 ]] || die "usage: write ISSUE FILE"
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' EXIT
    body=$(fetch_body "$2")
    splice "$3" <<<"$body" >"$tmp"
    push_body "$2" "$tmp"
    echo "issue $2 updated"
    ;;
  create)
    [[ $# -eq 3 && -f $3 ]] || die "usage: create TITLE FILE"
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' EXIT
    splice "$3" </dev/null >"$tmp"
    case "$HOST" in
      github) gh issue create --title "$2" --body-file "$tmp" ;;
      gitlab) glab issue create --title "$2" --description "$(cat "$tmp")" --yes ;;
    esac
    ;;
  extract) extract ;;
  splice)
    [[ $# -eq 2 && -f $2 ]] || die "usage: splice FILE < BODY"
    splice "$2"
    ;;
  *) sed -n '2,14s/^# \{0,1\}//p' "$0" >&2; exit 64 ;;
esac
