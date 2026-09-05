# Testing and Verification

Use this reference to design a confidence strategy for production changes.

## Test behavior and invariants

Prefer tests that remain valid across internal refactoring. Assert:

- externally meaningful outcomes;
- domain invariants;
- public contracts;
- important state transitions;
- boundary behavior;
- failure semantics.

Avoid testing private call sequences unless the sequence itself is a required contract.

## Choose the cheapest effective level

### Unit tests

Best for:

- deterministic calculations;
- domain rules;
- state transitions;
- validation logic;
- error mapping.

Keep them fast and focused.

### Integration tests

Best for verifying assumptions about real boundaries:

- database constraints and queries;
- serialization;
- framework configuration;
- message brokers;
- filesystem/storage;
- authentication/authorization integration;
- external-service adapters using realistic fakes, sandboxes, or local equivalents.

### Contract tests

Use when producer/consumer compatibility matters, especially across independently deployed systems. Verify schemas and semantic assumptions, not only field presence.

### End-to-end tests

Use sparingly for critical user/business journeys and deployment confidence. They are valuable but expensive and often slow/flaky if used as the primary test layer.

## Characterization tests

Before refactoring poorly understood legacy behavior, capture observable behavior. These tests can initially preserve undesirable behavior deliberately; fix behavior in a separate, explicit change.

Good characterization boundaries include public APIs, database outputs, generated documents, message payloads, or representative business scenarios.

## Test failure paths

For production code, happy-path coverage is insufficient. Consider:

- timeout;
- dependency unavailable;
- partial response;
- duplicate request/event;
- retry after uncertain outcome;
- stale/version-skewed data;
- invalid input;
- concurrency conflict;
- resource exhaustion;
- permission failure.

Do not mechanically test every theoretical failure. Focus on realistic and high-impact failure modes.

## Idempotency verification

For retryable operations, test repeated execution. Verify whether duplicates are safely ignored, collapsed, or produce an explicitly acceptable result.

When idempotency depends on a key or persisted record, test races and expiration rules where relevant.

## Migration verification

For schema/data migrations test:

- old application + old schema where applicable;
- new application against transitional schema;
- old and new versions coexisting during rolling deployment;
- backfill correctness;
- large-volume behavior where risk exists;
- retry/restart of migration jobs;
- roll-forward or rollback constraints.

Avoid assuming database rollback is always safe after new code has written data in a new format.

## Property-based and fuzz testing

Consider when a small set of invariants covers a huge input space, such as parsers, serializers, numerical transformations, state machines, or security-sensitive input handling.

Use it when it finds classes of defects that example-based tests would struggle to cover.

## Static verification

Use language/tooling capabilities where available:

- compiler/type checker;
- lint/static analysis;
- nullability checks;
- race/concurrency analyzers;
- API compatibility tools;
- schema validators;
- dependency cycle/import rules;
- security analyzers.

Prefer preventing invalid states mechanically to documenting that engineers should avoid them.

## Architecture tests

Architecture constraints worth testing may include:

- allowed dependency direction between modules;
- no cycles;
- only designated adapters access infrastructure packages;
- domain modules do not import delivery/framework layers;
- public APIs do not expose internal persistence types;
- service/domain ownership boundaries.

Use architecture tests for stable invariants, not subjective style preferences.

## Test doubles

Choose based on what the test needs:

- **Stub:** returns controlled data.
- **Fake:** lightweight working implementation, often useful for repositories or services.
- **Mock:** verifies interaction when the interaction itself matters.
- **Spy:** records interaction for later assertion.

Excessive mocking often indicates tests are coupled to implementation structure or production code is overly fragmented.

## Verification pyramid is contextual

Do not optimize for a fixed numerical distribution of unit/integration/E2E tests. Optimize for fast feedback plus realistic verification of the riskiest boundaries.

For data-heavy applications, integration tests may be more valuable than elaborate repository mocks. For pure domain engines, unit/property tests may dominate.

## Flaky tests

Treat persistent flakiness as a defect in the verification system. Common causes:

- uncontrolled time/randomness;
- shared mutable state;
- order dependence;
- real network dependency;
- weak async synchronization;
- resource exhaustion;
- environment drift.

Do not normalize repeated reruns as the standard solution.

## Required confidence statement

For a substantial change, be able to answer:

- What behavior is protected?
- What important failures are exercised?
- Which real integration assumptions are verified?
- Which architectural invariants are enforced mechanically?
- What remains unverified and why is that acceptable?
