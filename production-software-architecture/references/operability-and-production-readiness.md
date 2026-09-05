# Operability and Production Readiness

Use this reference for any feature whose failure, load, or behavior matters in production.

## Operability is an architecture property

A system is not production-ready merely because it returns the correct result in a test. Operators and developers must be able to answer:

- Is it working?
- Is it meeting user-facing objectives?
- If not, where is it failing?
- Is the failure local or systemic?
- Is capacity sufficient?
- Can we mitigate or roll back safely?

## Observability

### Logs

Use structured logs for discrete events that aid diagnosis. Include useful context such as operation, correlation/request identifiers, relevant entity identifiers, result, and error category.

Avoid:

- logging secrets or unnecessary personal data;
- using logs as a high-cardinality metrics system;
- logging the same error at every stack layer;
- swallowing exceptions after logging without explicit recovery.

### Metrics

Useful categories include:

- demand/traffic;
- success/error outcomes;
- latency distributions;
- resource saturation;
- queue depth/age;
- retry/drop/dead-letter counts;
- domain outcomes that reflect actual user/business success.

Prefer metrics tied to decisions and alerts, not dashboards full of unused counters.

### Tracing

Distributed traces are valuable when work crosses process/service/queue boundaries. Propagate correlation context and create spans around meaningful operations, not every small function.

## Health and readiness

Separate concepts where the platform supports them:

- **Liveness:** should the process be restarted?
- **Readiness:** should it receive new work?
- **Dependency health:** is an external dependency healthy?

Do not make liveness depend on a transient external dependency and trigger restart storms.

## Time budgets and resource bounds

Set deliberate bounds for:

- remote-call timeouts;
- queue/job execution;
- concurrency;
- connection pools;
- memory buffers;
- request/body size;
- batch size;
- retry attempts;
- caches;
- thread/goroutine/task creation.

Unbounded resources become incidents under load.

## Backpressure and overload

Plan what happens when demand exceeds capacity. Options include:

- queues with bounded depth;
- concurrency limits;
- rate limiting;
- load shedding;
- degraded modes;
- admission control;
- autoscaling where effective.

Do not simply accept unlimited work and hope horizontal scaling catches up.

## Dependency resilience

For each important dependency decide:

- timeout;
- retry policy;
- concurrency limit;
- fallback/degraded behavior;
- circuit/open-loop behavior where useful;
- caching implications;
- observability;
- impact if unavailable.

Circuit breakers are not universally required. Use them when they prevent repeated expensive calls and have well-defined recovery behavior.

## Deployment safety

Prefer changes that support:

- rolling or incremental deployment;
- version skew between instances;
- feature flags for high-risk behavior where operationally justified;
- canary/progressive rollout when impact is difficult to predict;
- quick roll-forward or rollback;
- migration compatibility.

Feature flags require ownership, observability, and removal plans. Excessive permanent flags create combinatorial complexity.

## Rollback vs roll-forward

Rollback is only safe if old binaries remain compatible with data and contracts modified by the new version. For irreversible data changes, roll-forward may be the only safe recovery path.

State this explicitly in migration plans.

## Capacity

For potentially high-volume changes consider:

- expected and peak throughput;
- concurrency;
- storage growth;
- database query/index cost;
- network payload size;
- queue lag;
- downstream rate limits;
- cost impact.

Use measurement or realistic load tests when architecture depends on capacity assumptions.

## Alerting

Alert on actionable symptoms tied to user/system impact. Good alerts have:

- a clear owner;
- a meaningful threshold/SLO relationship;
- enough context to begin diagnosis;
- an expected response.

Avoid paging on every internal anomaly.

## Security baseline

Treat security boundaries as architectural constraints. At minimum consider:

- authentication and authorization at appropriate boundaries;
- least privilege for identities and credentials;
- validation of untrusted input;
- safe serialization/parsing;
- secret storage and rotation;
- dependency/supply-chain risk;
- encryption requirements;
- auditability for sensitive actions;
- abuse/rate controls on exposed endpoints;
- data retention and sensitive logging.

Use specialist security review for high-risk systems rather than relying on this checklist alone.

## Configuration

Configuration is part of the operational API. Prefer:

- explicit defaults;
- validation at startup or boundary;
- clear units and ranges;
- safe secret handling;
- documented runtime mutability;
- observable effective configuration where safe.

Avoid scattered environment-variable reads throughout business logic.

## Production-ready question set

Before release ask:

1. How will we know the feature is being used?
2. How will we know it is succeeding?
3. How will we know it is harming latency/error rates/capacity?
4. What is the most likely failure mode?
5. What happens when each external dependency is slow or unavailable?
6. Can we disable, degrade, roll back, or roll forward safely?
7. Will old/new versions coexist safely?
8. Are resource usage and queues bounded?
9. Are security-sensitive behaviors auditable and least-privileged?
10. Is there enough diagnostic context to investigate an incident without adding emergency logging first?
