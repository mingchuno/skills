---
name: start-work-lite
disable-model-invocation: true
description: Start engineering work from an issue or a task description. Grooms vague requirements, routes the work to Track A, B or C, publishes the work contract, then implements, self-reviews and opens the change request.
license: MIT
metadata:
  version: "0.1.0"
---

# Start work (lite)

One entry point from a task to a change request. Investigate, groom only what
matters, route to a track, then follow that track to the end. Keep replies
short: the track, the next action, and only the decisions that need the human.
Facts are yours to look up; decisions are theirs. Merging and deployment stay
with the human.

## 1. Resolve the task

The input is an issue (`#123`, `PROJ-123`, a URL), a task description, or
nothing. With nothing, ask for a task. For an issue, read it with its comments
(`gh issue view N --comments` or `glab issue view N --comments`).

Resume instead of restarting when the issue already holds a contract
(`scripts/issue-contract.sh read N` in this skill's folder exits 0) or a branch for the task exists:
read the contract, the branch's commits and any open change request, then
continue from the first unfinished step below.

## 2. Investigate

Read the relevant code and tests, `AGENTS.md`, `CONTEXT.md`, and ADRs under
`docs/adr/`. For a defect, find the root cause with `debugging`. Separate what
was asked from what the code does today.

Done when you can state the intent, an observable expected outcome, and the
area the change touches, or can name exactly which of those is missing.

## 3. Groom when the picture is incomplete

Groom when the intent, the expected outcome, the scope boundary, or the design
direction is still open after investigating, or when the evidence conflicts.
Follow [references/groom.md](references/groom.md). Otherwise skip to routing
and record your defaults as assumptions.

## 4. Route

| Track | When | Path |
| --- | --- | --- |
| A | Small change, clear expected outcome, no risk flag, no open question, about ten files or fewer. | Contract in chat → deliver. |
| B | Everything else. | Contract → publish → scope approval → deliver. |
| C | Any risk flag: migration, security, public API, production, infrastructure, cross-service, irreversible. | Contract → publish → scope approval → design → design approval → deliver. |

When unsure, choose the higher track. Paths that `AGENTS.md` marks as Track C
are Track C. The human may raise a track; lowering one from C needs their
explicit reason, recorded in the contract.

## 5. Write the contract

Write it with [references/contract.md](references/contract.md). For Track A,
show the three required lines in chat and continue. For Tracks B and C,
publish it with [references/publish.md](references/publish.md), then ask for
scope approval.

## 6. Gate

Approval is the human's explicit yes to a named contract revision, given in
chat or as an issue comment. Present the gate in one block: track and reason,
intent, acceptance criteria, scope, risks, revision. Any change to intent,
acceptance, scope or design raises the revision and needs a fresh approval.

For Track C, after scope approval, follow
[references/design.md](references/design.md), publish the revision with the
design, and ask for design approval.

## 7. Deliver

Follow [references/deliver.md](references/deliver.md): implement, validate,
check scope, self-review and fix once, commit, push, open the change request.

## Companion skills

These skills are optional. Load one by name when the host allows it; otherwise
read `../<skill>/SKILL.md` beside this skill's folder when it is installed
there. When neither exists, apply the fallback.

| Skill | Reach for it when | Fallback |
| --- | --- | --- |
| `debugging` | A defect needs a root cause. | Reproduce, trace the failing path, fix the cause. |
| `clarify` | The human wants a full interview instead of grooming. | [groom.md](references/groom.md). |
| `production-software-architecture` | Track C design, or Track B touching boundaries, contracts or data. | [design.md](references/design.md). |
| `domain-docs` | A domain term or a durable decision is settled. | [design.md](references/design.md#knowledge). |
| `tdd` | Implementing behavior, or a regression test for a defect. | Test fails before the change, passes after. |
| `refactoring` | Existing structure must change first to make the change easy. | Behavior-preserving steps, tests green after each. |
| `code-quality` | The change lands in a hotspot, or self-review finds complexity grew. | Smaller functions, clearer names, no duplication. |
| `code-review` | Self-review. | [deliver.md](references/deliver.md#5-self-review-once). |
| `concise-docs` | Change request description, commit message, ADR prose. | Short, factual, commands preserved. |
