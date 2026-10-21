---
name: code-review
description: Review a diff against its spec, the repository's standards, and correctness, reporting prioritized P0–P3 findings with concrete failure scenarios. Use to review a branch, change request, or local changes, or to respond to review feedback.
license: MIT
metadata:
  version: "1.0.0"
  sources: "mattpocock/skills code-review; obra/superpowers requesting-code-review and receiving-code-review; pstack interrogate lead judgment (all MIT, see THIRD_PARTY_NOTICES.md)"
---

# Code review

Review what changed, against what was asked, and report only findings a
maintainer would act on. To respond to review feedback you received, follow
[references/receiving.md](references/receiving.md) instead.

## 1. Pin the change

Resolve the base the user gives (commit, branch, tag, or merge-base) with
`git rev-parse`. Review `git diff <base>...HEAD`, plus staged changes and
untracked files for local work. A bad ref or empty diff stops the review here.
If no base is given and none can be inferred, ask.

## 2. Gather the yardsticks

- **Spec**: the issue or change request referenced in commits or the branch,
  a path the user gave, or a spec under `docs/`. If there is none, ask once;
  if there is still none, skip the Spec lens and say so.
- **Standards**: every file documenting how code is written here (`AGENTS.md`,
  `CONTRIBUTING.md`, `CODING_STANDARDS.md`, ADRs, linter config), plus the
  smell baseline in [references/findings.md](references/findings.md). Skip
  anything tooling already enforces.
- **Validation**: the checks that ran and their results. Run the project's
  checks if none were reported and you are allowed to.

## 3. Review three lenses

Review each lens with fresh context. When the host supports subagents, run
them in parallel and give each only the diff command, the intent, and its
yardstick, never your session history. Subagents are read-only and do not
spawn further reviewers. Otherwise, read the whole diff once per lens.

| Lens | Question |
| --- | --- |
| Correctness | What input, state, or sequence makes this code fail, lose data, or leak access? |
| Spec | What was asked but is missing or partial, what was built but not asked for, and what looks implemented but wrong? Quote the spec line. |
| Standards | Where does the diff break a documented standard (cite file and rule) or show a baseline smell (always a judgement call)? |

Where the spec is silent, a reasonable user's expectation is still a
requirement.

## 4. Judge before reporting

You are the lead reviewer, not an aggregator. For each candidate finding,
trace the call site: drop hypotheticals the types or callers rule out,
preferences without a concrete problem, abstractions the change does not need,
and comments on code the diff did not touch. Keep the dropped list; it goes in
the report. Do not inflate nits to fill space.

## 5. Report

Follow [references/findings.md](references/findings.md): a summary, whether the
inspection was complete with any limitations, then findings ordered by priority
and grouped by lens. Every finding has a priority, a path and line where one
exists, and a concrete failure scenario. Never report an incomplete review as
clean.
