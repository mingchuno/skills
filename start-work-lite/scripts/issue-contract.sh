#!/usr/bin/env bash
# Read or write the work contract held in a marked section of an issue body.
#
#   issue-contract.sh read ISSUE             print the contract; exit 3 if none
#   issue-contract.sh write ISSUE FILE       replace or append the contract
#   issue-contract.sh create TITLE FILE      create an issue holding the contract
#   issue-contract.sh extract < BODY         offline: print the contract in BODY
#   issue-contract.sh splice FILE < BODY     offline: print BODY with FILE spliced in
#
# Uses gh or glab, chosen from the origin remote or START_WORK_HOST=github|gitlab.
set -euo pipefail

BEGIN='<!-- start-work-lite:contract -->'
END='<!-- /start-work-lite:contract -->'

die() { echo "issue-contract: $*" >&2; exit "${2:-1}"; }

host() {
  if [[ -n "${START_WORK_HOST:-}" ]]; then echo "$START_WORK_HOST"; return; fi
  local url
  url=$(git remote get-url origin 2>/dev/null) || die "no origin remote; set START_WORK_HOST" 2
  case "$url" in
    *github*) echo github ;;
    *gitlab*) echo gitlab ;;
    *) die "cannot tell host from $url; set START_WORK_HOST=github|gitlab" 2 ;;
  esac
}

fetch_body() {
  case "$HOST" in
    github) gh issue view "$1" --json body -q .body ;;
    gitlab) glab issue view "$1" -F json --jq .description ;;
  esac
}

extract() {
  tr -d '\r' | awk -v b="$BEGIN" -v e="$END" '
    $0 == e { inside = 0; done = 1 }
    inside { print }
    $0 == b { inside = 1; found = 1 }
    END { exit(found && done ? 0 : 3) }
  '
}

splice() {
  local file=$1 body
  body=$(tr -d '\r')
  if grep -qxF "$BEGIN" <<<"$body"; then
    grep -qxF "$END" <<<"$body" || die "contract start marker without end marker"
    awk -v b="$BEGIN" -v e="$END" -v f="$file" '
      $0 == b { print; while ((getline line < f) > 0) print line; skip = 1; next }
      $0 == e { skip = 0 }
      !skip { print }
    ' <<<"$body"
  else
    [[ -n "$body" ]] && printf '%s\n\n' "$body"
    printf '%s\n' "$BEGIN"
    cat "$file"
    printf '%s\n' "$END"
  fi
}

push_body() {
  local issue=$1 file=$2
  case "$HOST" in
    github) gh issue edit "$issue" --body-file "$file" >/dev/null ;;
    gitlab) glab issue update "$issue" --description "$(cat "$file")" >/dev/null ;;
  esac
}

cmd=${1:-}
case "$cmd" in
  read | write | create)
    HOST=$(host)
    [[ $HOST == github || $HOST == gitlab ]] || die "unknown host $HOST" 2
    ;;
esac

case "$cmd" in
  read)
    [[ $# -eq 2 ]] || die "usage: read ISSUE"
    body=$(fetch_body "$2")
    extract <<<"$body" || die "issue $2 holds no contract" 3
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
  extract) extract || exit 3 ;;
  splice)
    [[ $# -eq 2 && -f $2 ]] || die "usage: splice FILE < BODY"
    splice "$2"
    ;;
  *) sed -n '2,9s/^# \{0,1\}//p' "$0" >&2; exit 64 ;;
esac
