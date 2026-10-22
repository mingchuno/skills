# Deliver

This session implements, validates, reviews once and opens the change request.
Publishing is the expected end state; stop before pushing only when the human
asked for local work.

## 1. Branch

Record the base with `git rev-parse HEAD`. On the default branch, create a
branch following the repository's convention, otherwise `<type>/<short-slug>`.
A dirty checkout you did not create belongs to the human; ask before touching
it.

## 2. Implement

Work inside the contract's scope, in the approved stages for Track C.

- Behavior: test first with `tdd`. For a defect, the regression test fails
  before the fix.
- Existing structure in the way: make the change easy first with
  `refactoring`, as separate behavior-preserving commits.
- Boundaries, contracts or data: follow the approved design, and
  `production-software-architecture` where the design left room.
- Use the vocabulary of `CONTEXT.md` in names and tests.

## 3. Validate

Run the project's own checks: those named in `AGENTS.md` or `CONTRIBUTING.md`,
otherwise the package scripts, `Makefile` or CI configuration. Read the full
output. A check you could not run is a limitation, never a pass.

## 4. Check scope

Compare `git diff --stat BASE` and untracked files with the contract's scope
and the routing rules. When the diff left the scope or now meets a higher
track, stop and tell the human what grew. Continue after they agree; on
Tracks B and C, that means a new revision and approval.

## 5. Self-review once

Review the whole diff against the contract, with `code-review` when available.
Otherwise read the diff once for each lens:

| Lens | Question |
| --- | --- |
| Correctness | What input, state or sequence makes this fail, lose data or leak access? |
| Contract | Does every acceptance criterion have evidence? Is anything built that was not asked? |
| Standards | Where does it break a documented standard, or add deeper nesting, longer functions, duplicated logic or pass-through layers? |

Fix the blocking findings that stay inside the scope, in one round, then repeat
step 3. A finding whose fix changes scope, a public interface, a dependency or
business behavior goes to the human instead. Everything left unfixed goes into
the change request as a limitation. Then decide the knowledge outcome in
[design.md](design.md#knowledge).

## 6. Publish

Commit with a conventional message, push the branch, and open the change
request with `gh pr create` or `glab mr create`. The description, written with
`concise-docs` when available, holds:

- the intent and acceptance criteria, each with its evidence;
- the checks run and their results;
- limitations and unfixed review findings;
- `Closes #N` for issue work. For Track A without an issue, the contract lines
  themselves.

## 7. Report

Reply with the change request URL, the checks and their results, and any
limitations. Leave merging to the human.
