# Failure, Data, and Evolution

Use this reference when a change touches remote calls, asynchronous work, databases, schemas, migrations, distributed state, or versioned contracts.

## Treat failure semantics as part of the API

Every boundary should make important failure behavior understandable:

- timeout behavior;
- retryability;
- partial success;
- duplicate handling;
- cancellation;
- concurrency conflicts;
- unavailable dependencies;
- invalid or incompatible data.

Do not collapse every failure into a generic internal error if callers need different recovery behavior.

## Timeouts

Every remote or potentially unbounded operation needs a deliberate time budget. Avoid relying solely on framework defaults.

Timeouts should compose with an overall request/job deadline. A chain of three independent 30-second timeouts does not create a reliable 30-second operation.

## Retries

Retry only when:

- the failure is plausibly transient;
- the operation is idempotent or duplicate-safe;
- retry load will not amplify an outage;
- backoff/jitter and a retry limit exist;
- the overall time budget permits it.

Avoid retrying validation, authorization, deterministic business failures, or overload signals indiscriminately.

## Idempotency

For operations that may be delivered or executed more than once, define an idempotency strategy explicitly. Possible mechanisms include:

- natural idempotency;
- idempotency keys;
- uniqueness constraints;
- inbox/deduplication records;
- compare-and-set/version checks.

Exactly-once delivery is rarely an end-to-end property. Design for duplicates where the transport can redeliver.

## Asynchronous workflows

For queues/events/jobs define:

- ownership of the message contract;
- delivery semantics;
- ordering assumptions;
- retry/dead-letter policy;
- idempotency;
- poison-message handling;
- schema/version evolution;
- observability and correlation;
- backpressure and capacity.

An event-driven design can reduce temporal coupling while increasing consistency and operational complexity. Use it intentionally.

## Transactions and consistency

Start from business invariants rather than technology.

Ask:

- Which state changes must be atomic?
- What inconsistency window is acceptable?
- Who owns each invariant?
- What happens when steps partially succeed?
- Can compensation repair the outcome?

Keep ACID transactions local when practical. Avoid distributed transactions unless their guarantees are genuinely required and the operational costs are accepted.

## Optimistic concurrency

For concurrent edits, version/compare-and-set checks are often preferable to broad locking. Make conflicts visible and define retry or user-facing behavior.

Do not use last-write-wins accidentally for data where lost updates matter.

## Data ownership

Give durable data a clear owner. Cross-domain direct table access creates strong hidden coupling and makes schema evolution difficult.

Within a single deployment/module, direct relational access across tables may be perfectly reasonable. Do not create artificial service boundaries merely to claim data ownership.

## Schema evolution

Prefer additive and backward-compatible changes when old and new application versions can coexist.

A common expand/migrate/contract sequence:

1. **Expand:** add new schema/fields/indexes without breaking old code.
2. **Deploy compatible code:** read/write in a transitional manner where required.
3. **Migrate/backfill:** move existing data safely and observably.
4. **Switch:** make new representation authoritative.
5. **Contract:** remove obsolete schema/code only after all users are migrated.

Avoid renaming/dropping columns or changing meaning in one deployment when rolling upgrades are used.

## Large migrations

For large data changes consider:

- batching/chunking;
- rate limiting;
- resumability/checkpoints;
- idempotent processing;
- online index creation where supported;
- locking impact;
- replication/log growth;
- production capacity;
- verification counts/checksums/samples;
- pause/abort controls.

A migration is production software. Give it metrics, logs, retry behavior, and operational instructions proportional to risk.

## Public API compatibility

A contract includes more than function signatures:

- field names/types and nullability;
- error/status semantics;
- ordering/pagination;
- default behavior;
- authentication scopes;
- timing/rate expectations where relied upon;
- events and webhook semantics.

Prefer additive changes. When breaking changes are required, provide explicit versioning or a migration path.

## Event compatibility

Events are durable contracts when consumers may store or replay them. Prefer schemas that allow additive evolution and consumers tolerant of unknown fields.

Do not silently change the semantic meaning of an existing field/event type.

## Caches

Before adding a cache specify:

- what correctness property allows staleness;
- source of truth;
- key and ownership;
- invalidation/expiry strategy;
- stampede behavior;
- failure behavior when cache is unavailable;
- observability;
- memory/storage bounds.

A cache without an explicit correctness and invalidation model is architectural debt.

## Compatibility before elegance

During evolution, temporary duplication or compatibility adapters can be safer than an elegant flag-day transition. Make transition states explicit and include removal criteria so they do not become permanent by accident.
