# ADR format

ADRs live in `docs/adr/` as `0001-slug.md`, `0002-slug.md`, and so on. Take the
highest existing number and add one.

```md
# {Short title of the decision}

{One to three sentences: the context, the decision, and why.}
```

An ADR can be one paragraph. Its value is recording that a decision was made and
why. Add sections only when they carry information:

- **Status** (`proposed`, `accepted`, `deprecated`, `superseded by ADR-NNNN`)
  when decisions are revisited.
- **Considered options** when a rejected alternative would otherwise be
  proposed again.
- **Consequences** when downstream effects are not obvious.

Follow the repository's existing ADR template when it has one.

## What qualifies

- Architectural shape: "The write model is event-sourced; reads are projected
  into PostgreSQL."
- Integration between contexts: "Ordering and Billing communicate through
  events, not synchronous HTTP."
- Technology with lock-in: database, message bus, auth provider, deployment
  target.
- Boundaries and ownership, including explicit refusals.
- Deliberate deviations from the obvious path, so nobody "fixes" them.
- Constraints not visible in code: compliance, partner latency contracts.
