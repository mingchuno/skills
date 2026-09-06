# Architecture and Production Review Checklists

Use these as compact prompts during design or review. Apply only sections relevant to the change.

## Design review

- Is the user/business problem and required behavior clear?
- Are hard constraints separated from assumptions/preferences?
- Does the proposal follow existing architecture where sensible?
- Is each new component/boundary justified by responsibility, volatility, invariant, ownership, or failure isolation?
- Is there a simpler design with comparable correctness and operability?
- Are abstractions based on actual variation rather than speculative reuse?
- Is state ownership clear?
- Are transaction/consistency boundaries explicit?
- Are remote calls and async boundaries visible in the design?
- Are deployment, compatibility, and migration paths plausible?
- Is the design reversible enough for its uncertainty?

## Implementation review

- Does code use domain/capability language instead of vague pattern names?
- Are responsibilities cohesive?
- Are side effects and external boundaries explicit?
- Are untrusted inputs validated at boundaries?
- Is failure behavior explicit rather than swallowed/generalized?
- Is new shared/global mutable state avoided or tightly owned?
- Did the change introduce forwarding layers or unnecessary interfaces?
- Did it add unrelated cleanup that should be separated?
- Are important tests about behavior/invariants rather than private structure?
- Are architecture dependency rules still satisfied?

## API/event review

- Is the change additive/backward-compatible where possible?
- Are old/new versions expected to coexist?
- Are error semantics and defaults compatible?
- Are consumers tolerant of additive fields/version skew?
- Is semantic meaning of existing fields unchanged?
- Is there a deprecation/migration path for breaking changes?
- Are compatibility checks automated?

## Database/schema migration review

- Does the migration use expand/migrate/contract where rolling compatibility matters?
- Can it run online without unacceptable locks/load?
- Is a large backfill batched, resumable, bounded, and observable?
- Is it safe to retry?
- Can old application versions run during the transition?
- Is rollback actually safe after new-format data is written?
- If rollback is unsafe, is roll-forward documented/tested?
- Is completion/correctness verifiable?
- Are obsolete fields/code removed only after migration is complete?

## Distributed/async review

- Are timeouts explicit?
- Are retries limited, backed off, and duplicate-safe?
- Is idempotency defined?
- Are ordering assumptions explicit?
- Is partial success handled?
- Is there poison/dead-letter behavior where needed?
- Is queue/backlog capacity bounded and observable?
- Can downstream outage create retry storms or cascading failure?
- Are correlation/tracing identifiers propagated?

## Production readiness review

- Are success, failure, latency, saturation, and domain outcomes observable?
- Are logs structured and safe for sensitive data?
- Are alerts actionable and tied to impact?
- Are health/readiness checks semantically correct?
- Are time, concurrency, buffers, queues, and resource usage bounded?
- Is dependency failure behavior defined?
- Can the feature be disabled, degraded, rolled back, or rolled forward?
- Are version-skew and migration states safe?
- Are capacity assumptions measured or testable?
- Are authentication, authorization, secrets, and least privilege addressed?

## Refactoring review

- Is externally meaningful behavior intentionally unchanged?
- Is there a safety net for poorly understood behavior?
- Can structural and functional changes be reviewed separately?
- Does the refactor reduce change amplification, coupling, or conceptual load?
- Were long functions, classes, or components split along cohesive responsibilities rather than arbitrary size limits?
- Was duplicated knowledge given one canonical owner while coincidental similarity remained separate?
- Does each new boundary clarify ownership or hide meaningful complexity rather than add a forwarding layer?
- Can a representative future change be made in fewer unrelated places or with less system knowledge?
- Are public contracts preserved?
- Is the diff proportionate to the objective?
- Is a transition wrapper/abstraction scheduled for removal if temporary?
- Was a broad rewrite avoided unless strongly justified?

## Dependency review

For each new third-party dependency:

- What capability does it provide that is expensive to implement/maintain ourselves?
- Is the dependency actively maintained and compatible with the runtime/platform?
- What transitive dependencies or security/supply-chain risk does it add?
- Does it become part of a public API or persisted format, increasing lock-in?
- Can it be isolated behind a meaningful boundary if replacement cost is high?
- What is the upgrade and support burden?

Do not wrap every library automatically. Wrap when doing so protects semantics or volatile integration detail.

## ADR trigger checklist

Record a decision if several are true:

- hard/expensive to reverse;
- crosses team/service/domain ownership;
- creates a new public contract;
- changes data ownership or consistency;
- introduces substantial operational infrastructure;
- adopts a new major framework/platform;
- credible alternatives exist;
- future maintainers are likely to ask “why did we do this?”

## Final maintainability test

Imagine an experienced engineer joins the team three years from now. Can they:

- locate where a behavior belongs;
- understand important dependencies without reading the whole repository;
- change one capability without surprising unrelated areas;
- discover relevant architectural decisions;
- reproduce verification locally;
- observe and diagnose the behavior in production;
- understand compatibility and data-migration constraints;
- see architecture violations fail automatically rather than learning them from tribal knowledge?

If not, identify the smallest improvement that materially changes that answer.
