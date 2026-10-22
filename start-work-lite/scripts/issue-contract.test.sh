#!/usr/bin/env bash
# Tests for issue-contract.sh against fake gh and glab CLIs.
#
#   bash issue-contract.test.sh
set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")" && pwd)/issue-contract.sh"
BEGIN='<!-- start-work-lite:contract -->'
END='<!-- /start-work-lite:contract -->'
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
FAILED=0

mkdir "$WORK/bin"
export FAKE_LOG="$WORK/calls.log" FAKE_BODY="$WORK/body.md"

# Fake gh: FAKE_GH_REPO=1 makes `repo view` succeed; FAKE_CR is the open PR URL.
cat >"$WORK/bin/gh" <<'EOF'
#!/usr/bin/env bash
echo "gh $*" >>"$FAKE_LOG"
case "$1 $2" in
  "repo view") [[ ${FAKE_GH_REPO:-0} == 1 ]] ;;
  "issue view") cat "$FAKE_BODY" ;;
  "issue edit") cp "$5" "$FAKE_BODY" ;;
  "issue create") echo "https://github.com/o/r/issues/99" ;;
  "pr list") [[ -n ${FAKE_CR:-} ]] && echo "$FAKE_CR"; true ;;
  *) exit 1 ;;
esac
EOF

# Fake glab, like releases without --jq: FAKE_GLAB_REPO=1 makes `repo view` succeed.
cat >"$WORK/bin/glab" <<'EOF'
#!/usr/bin/env bash
echo "glab $*" >>"$FAKE_LOG"
for arg in "$@"; do [[ $arg == --jq ]] && { echo "unknown flag: --jq" >&2; exit 1; }; done
case "$1 $2" in
  "repo view") [[ ${FAKE_GLAB_REPO:-0} == 1 ]] ;;
  "issue view") jq -n --rawfile d "$FAKE_BODY" '{description: $d}' ;;
  "issue update") printf '%s\n' "$5" >"$FAKE_BODY" ;;
  "issue create") echo "https://gitlab.example.com/g/p/-/issues/99" ;;
  "mr list")
    if [[ -n ${FAKE_CR:-} ]]; then jq -n --arg u "$FAKE_CR" '[{web_url: $u}]'; else echo '[]'; fi ;;
  *) exit 1 ;;
esac
EOF
chmod +x "$WORK/bin/gh" "$WORK/bin/glab"
export PATH="$WORK/bin:$PATH"

check() {
  local name=$1 expected=$2 actual=$3
  if [[ "$actual" == "$expected" ]]; then
    echo "ok   $name"
  else
    echo "FAIL $name"
    printf '  expected: %s\n  actual:   %s\n' "$expected" "$actual"
    FAILED=1
  fi
}

# A fresh repository whose origin points at $1, with main pushed to a bare origin.
repo() {
  local dir="$WORK/repo-$RANDOM$RANDOM"
  git init -q -b main "$dir"
  git -C "$dir" -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
  git init -q --bare "$dir.git"
  git -C "$dir" remote add origin "$dir.git"
  git -C "$dir" push -q origin main
  git -C "$dir" remote set-url origin "$1"
  git -C "$dir" remote set-head origin main 2>/dev/null ||
    git -C "$dir" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
  echo "$dir"
}

sw() { local dir=$1; shift; (cd "$dir" && "$SCRIPT" "$@" 2>&1); }

printf 'intro\n\n%s\nold\n%s\n\noutro\n' "$BEGIN" "$END" >"$WORK/with-contract.md"
printf '**Track:** B: x · **Revision:** 2\nnew\n' >"$WORK/contract.md"

# Offline: extract and splice.
check "extract existing contract" "old" "$("$SCRIPT" extract <"$WORK/with-contract.md")"
"$SCRIPT" extract </dev/null >/dev/null 2>&1
check "extract empty body exits 3" "3" "$?"
printf 'text\n' | "$SCRIPT" extract >/dev/null 2>&1
check "extract body without markers exits 3" "3" "$?"
printf '%s\nx\n' "$BEGIN" | "$SCRIPT" extract >/dev/null 2>&1
check "extract start without end exits 4" "4" "$?"
printf '%s\nx\n%s\n' "$END" "$BEGIN" | "$SCRIPT" extract >/dev/null 2>&1
check "extract end before start exits 4" "4" "$?"
printf '%s\na\n%s\n%s\nb\n%s\n' "$BEGIN" "$END" "$BEGIN" "$END" | "$SCRIPT" extract >/dev/null 2>&1
check "extract duplicated contract exits 4" "4" "$?"
check "extract tolerates CRLF" "old" "$(sed 's/$/\r/' "$WORK/with-contract.md" | "$SCRIPT" extract)"

check "splice into empty body" "$(printf '%s\n**Track:** B: x · **Revision:** 2\nnew\n%s' "$BEGIN" "$END")" \
  "$("$SCRIPT" splice "$WORK/contract.md" </dev/null)"
check "splice appends after existing text" "$(printf 'text\n\n%s\n**Track:** B: x · **Revision:** 2\nnew\n%s' "$BEGIN" "$END")" \
  "$(printf 'text\n' | "$SCRIPT" splice "$WORK/contract.md")"
check "splice replaces existing contract" \
  "$(printf 'intro\n\n%s\n**Track:** B: x · **Revision:** 2\nnew\n%s\n\noutro' "$BEGIN" "$END")" \
  "$("$SCRIPT" splice "$WORK/contract.md" <"$WORK/with-contract.md")"
printf '%s\na\n%s\n%s\nb\n%s\n' "$BEGIN" "$END" "$BEGIN" "$END" | "$SCRIPT" splice "$WORK/contract.md" >/dev/null 2>&1
check "splice refuses duplicated contract" "1" "$?"

# Host detection.
unset START_WORK_HOST
gh_repo=$(repo "git@github.com:o/r.git")
gitlab_repo=$(repo "https://gitlab.com/g/p.git")
selfhosted_repo=$(repo "git@git.example.internal:g/p.git")

check "github.com remote" "host=github" "$(FAKE_GH_REPO=1 sw "$gh_repo" preflight)"
check "gitlab.com remote" "host=gitlab" "$(FAKE_GLAB_REPO=1 sw "$gitlab_repo" preflight)"
check "self-hosted GitLab detected through glab" "host=gitlab" "$(FAKE_GLAB_REPO=1 sw "$selfhosted_repo" preflight)"
check "GitHub Enterprise detected through gh" "host=github" "$(FAKE_GH_REPO=1 sw "$selfhosted_repo" preflight)"
sw "$selfhosted_repo" preflight >/dev/null
check "unknown host exits 2" "2" "$?"
check "START_WORK_HOST overrides detection" "host=gitlab" \
  "$(START_WORK_HOST=gitlab FAKE_GLAB_REPO=1 sw "$selfhosted_repo" preflight)"
sw "$gitlab_repo" preflight >/dev/null
check "preflight fails when glab cannot reach the repository" "2" "$?"

# GitLab round trip without glab --jq.
cp "$WORK/with-contract.md" "$FAKE_BODY"
check "gitlab read" "old" "$(FAKE_GLAB_REPO=1 sw "$selfhosted_repo" read 7)"
FAKE_GLAB_REPO=1 sw "$selfhosted_repo" write 7 "$WORK/contract.md" >/dev/null
check "gitlab write keeps surrounding text" \
  "$(printf 'intro\n\n%s\n**Track:** B: x · **Revision:** 2\nnew\n%s\n\noutro' "$BEGIN" "$END")" "$(cat "$FAKE_BODY")"
: >"$FAKE_BODY"
FAKE_GLAB_REPO=1 sw "$selfhosted_repo" read 7 >/dev/null
check "gitlab read of empty body exits 3" "3" "$?"

# GitHub round trip.
cp "$WORK/with-contract.md" "$FAKE_BODY"
sw "$gh_repo" write 7 "$WORK/contract.md" >/dev/null
check "github write" "new" "$(sw "$gh_repo" read 7 | tail -n 1)"

# Inspect.
cp "$WORK/with-contract.md" "$FAKE_BODY"
check "inspect with nothing started" \
  "$(printf '%s\n' issue=10 host=gitlab contract=present revision=absent branch=absent base=origin/main \
    commits_ahead=0 change_request=absent next=gate)" \
  "$(sw "$gitlab_repo" inspect 10)"

git -C "$gitlab_repo" checkout -q -b feat/10-retry-notify
git -C "$gitlab_repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m work
cp "$WORK/contract.md" "$WORK/plain.md"
printf 'body\n' >"$FAKE_BODY"
"$SCRIPT" splice "$WORK/plain.md" <"$FAKE_BODY" >"$WORK/next.md" && mv "$WORK/next.md" "$FAKE_BODY"
check "inspect finds branch and commits" \
  "$(printf '%s\n' issue=10 host=gitlab contract=present revision=2 branch=feat/10-retry-notify base=origin/main \
    commits_ahead=1 change_request=absent next=deliver)" \
  "$(sw "$gitlab_repo" inspect 10)"
check "inspect finds open change request" "next=review change_request=https://x/mr/1" \
  "$(FAKE_CR=https://x/mr/1 sw "$gitlab_repo" inspect 10 | grep -E '^(next|change_request)=' | sort -r | paste -sd' ' -)"
check "inspect ignores other issue numbers" "branch=absent" "$(sw "$gitlab_repo" inspect 1 | grep '^branch=')"

git -C "$gitlab_repo" branch -q fix/10-other
check "inspect asks on ambiguous branches" "branch=ambiguous:feat/10-retry-notify,fix/10-other next=ask" \
  "$(sw "$gitlab_repo" inspect 10 | grep -E '^(branch|next)=' | paste -sd' ' -)"

printf 'none\n' >"$FAKE_BODY"
check "inspect without contract or branch" "contract=absent next=investigate" \
  "$(sw "$gh_repo" inspect 10 | grep -E '^(contract|next)=' | paste -sd' ' -)"

exit "$FAILED"
