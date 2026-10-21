---
name: domain-docs
description: Maintain a project's domain vocabulary in CONTEXT.md and record durable decisions as ADRs in docs/adr/. Use when writing or editing CONTEXT.md or an ADR, or when a term or architecture decision is being settled.
license: MIT
metadata:
  version: "1.0.0"
  sources: "mattpocock/skills domain-modeling (MIT, see THIRD_PARTY_NOTICES.md)"
---

# Domain docs

Keep the project's language precise and its durable decisions findable. Reading
`CONTEXT.md` for vocabulary is a habit for every task; this skill is for
changing it.

## Files

| File | Holds |
| --- | --- |
| `CONTEXT.md` | Domain terms for one bounded context. No implementation details. |
| `CONTEXT-MAP.md` | Present only in multi-context repositories: where each context's `CONTEXT.md` lives and how contexts relate. |
| `docs/adr/NNNN-slug.md` | One durable decision each, numbered sequentially. Context-specific ADRs may live beside that context. |

If the repository already uses `GLOSSARY.md` or another ADR location, follow
it. Create files only when there is something to write.

## Vocabulary

- When the user or the code uses a term that conflicts with `CONTEXT.md`, say
  so and ask which meaning is right.
- Replace vague or overloaded words with one canonical term.
- Probe boundaries between concepts with concrete edge-case scenarios.
- When the user describes behavior, check whether the code agrees and surface
  contradictions.
- Update `CONTEXT.md` as soon as a term is settled, using
  [references/context-format.md](references/context-format.md).

## Decisions

Propose an ADR only when all three hold:

1. **Hard to reverse**: changing course later is costly.
2. **Surprising without context**: a future reader would ask why.
3. **A real trade-off**: there were genuine alternatives.

Otherwise skip it. Use [references/adr-format.md](references/adr-format.md).
Supersede an ADR with a new one rather than rewriting its decision.

Record only knowledge supported by the code or an agreed decision. Temporary
plans and task acceptance criteria belong in the issue or change request.
