---
name: clarify
disable-model-invocation: true
description: Interview the user in rounds until a plan, design, or task is unambiguous, asking only questions whose answers change the outcome. Invoke explicitly to stress-test or "grill" a plan before work starts.
license: MIT
metadata:
  version: "1.0.0"
  sources: "mattpocock/skills grilling, grill-me, grill-with-docs (MIT, see THIRD_PARTY_NOTICES.md)"
---

# Clarify

Reach a shared understanding before anyone builds. Ask about desired behavior
before implementation.

## Facts are yours, decisions are theirs

Before asking anything, read the request, the relevant code and tests,
`CONTEXT.md` (or `GLOSSARY.md`), and ADRs. Never ask the user for a fact you can
look up. When the host supports subagents, send lookups to them and keep asking
the questions that do not depend on the result.

Ask only questions whose answers change acceptance, scope, safety, or
feasibility. When a choice is reversible and any reasonable answer works, record
it as an assumption with your default instead of asking.

## Work the decision tree in rounds

Each decision opens the decisions that depend on it. The frontier is every open
decision whose prerequisites are settled. Ask the whole frontier in one round,
numbered, each with your recommended answer, worded so "yes" accepts it:

```text
Q1 - <title>: <question, with options where useful>
Recommended: <answer>

Q2 - ...
```

A question that depends on another open question waits for a later round. After
each round, recompute the frontier. Do not invent questions to fill a round.

When the user uses a term that conflicts with `CONTEXT.md` or the code, or an
overloaded word ("account" for customer or user), call it out and propose the
precise term. Test fuzzy boundaries with a concrete scenario.

## Finish

Stop when the frontier is empty. Summarize:

| Section | Content |
| --- | --- |
| Decisions | Each settled question and its answer. |
| Assumptions | Reversible defaults you chose, and their consequences. |
| Acceptance criteria | Observable outcomes, including failure behavior. |
| Open items | Anything the user deferred. |

Do not start implementation until the user confirms the summary. If terms or
durable decisions were settled, offer the `domain-docs` skill to record them.
