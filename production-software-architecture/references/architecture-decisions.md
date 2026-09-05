# Architecture Decisions and ADRs

Use this reference for decisions that future maintainers will need to understand.

## When to record a decision

Create or update an ADR/design record when a change:

- establishes or changes a major module/service boundary;
- adopts a new database, queue, framework, protocol, or runtime dependency;
- changes consistency or transaction semantics;
- introduces an externally consumed API/event contract;
- introduces substantial operational complexity;
- makes a hard-to-reverse security or data decision;
- chooses between credible alternatives with lasting consequences;
- intentionally violates an established architecture rule;
- creates a migration/transition likely to outlive the current change.

Do not create ADRs for routine implementation choices that are obvious from code.

## ADR template

```markdown
# ADR-NNN: Decision title

## Status
Proposed | Accepted | Superseded | Deprecated

## Context
What problem, constraints, and forces require a decision?

## Decision
What are we choosing? State the boundary and important semantics precisely.

## Alternatives considered
What realistic alternatives were considered, and why were they not chosen?

## Consequences
What becomes easier, harder, more expensive, or constrained?

## Operational and migration impact
How is this deployed, observed, migrated, and recovered?

## Assumptions and validation
Which assumptions matter, and how will we know if they are wrong?

## Follow-up
Guardrails, cleanup, removal dates, or future review triggers.
```

Use the repository's established ADR format if one exists.

## Good decisions explain forces

Avoid ADRs that say only:

> We chose PostgreSQL because it is reliable.

Capture the constraints that differentiate alternatives, such as transactional requirements, existing expertise, operational platform, expected query patterns, recovery needs, or ecosystem compatibility.

## Record consequences honestly

Every architecture choice has costs. A useful ADR should state them explicitly.

Examples:

- stronger consistency but lower write availability;
- independent deployability but additional network and operational failure modes;
- simpler runtime but tighter release coordination;
- flexible schema but weaker database-level guarantees;
- reduced coupling but duplicated transitional data.

Avoid decision records written as advocacy documents after the choice is already made.

## Reversibility

Classify decisions informally:

- **Easy to reverse:** ordinary code organization or library detail.
- **Moderately expensive:** public APIs, framework adoption, shared libraries.
- **Very expensive:** externally persisted data models, service boundaries, event history, external contracts, cross-org ownership.

Spend design effort proportional to reversal cost and uncertainty.

## Assumptions should be testable

If a decision depends on an assumption such as “traffic will remain below X” or “consumers can tolerate five minutes of staleness,” state it.

Where possible, attach a validation mechanism: load test, metric, SLO, contract test, or future review condition.

## Decision lifecycle

ADRs are not immutable truth. Mark them superseded when architecture changes, and link to the new decision.

Do not silently rewrite historical context so that an old decision appears to have anticipated later information.

## Architecture documentation hierarchy

Prefer a small navigable set of living documents:

- top-level architecture map: domains/components and dependency direction;
- ADRs: consequential decisions and trade-offs;
- runbooks/reliability docs: operational behavior;
- API/schema documentation: machine-facing contracts;
- execution/migration plans: temporary change process.

Avoid one giant architecture document that becomes stale because every detail is duplicated there.
