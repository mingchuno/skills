# Architecture Fitness Functions and Governance

Use this reference to turn architectural intent into executable, maintainable guardrails.

## Principle

If an architectural rule is important, objective, and repeatedly relevant, prefer a machine-checkable rule over relying only on documentation and code review.

Enforce **invariants**, not aesthetic preference.

## Good candidates for automation

### Dependency rules

- allowed module/package directions;
- forbidden imports;
- no circular dependencies;
- infrastructure/framework packages unavailable to core policy modules;
- designated ownership boundaries;
- restrictions on direct cross-domain data access.

### Contract compatibility

- OpenAPI/protobuf/schema breaking-change detection;
- public library API compatibility;
- event schema compatibility;
- database migration safety checks.

### Repository health

- compiler/type-check success;
- static analysis;
- duplicate/cycle detection where useful;
- dependency vulnerability policy;
- secret scanning;
- license policy;
- generated-code/schema drift checks.

### Operational constraints

- required instrumentation for public endpoints/jobs where tooling supports it;
- resource limits/config validation;
- deployment-policy validation;
- infrastructure policy-as-code.

## Fitness functions

A fitness function is an objective check indicating whether an architectural property remains acceptable as the system evolves.

Examples:

- no dependency cycles between domain modules;
- core module has zero imports from persistence framework;
- public API contains no breaking schema changes without explicit version bump;
- p95 latency remains below an agreed budget under representative load;
- service starts and becomes ready within a defined time;
- migration can be restarted safely;
- dependency critical vulnerabilities fail CI.

Fitness functions can be tests, static checks, benchmarks, policy checks, or production SLOs.

## Do not weaponize metrics

Metrics such as cyclomatic complexity, file size, coverage percentage, or dependency count are indicators, not architecture truth.

Avoid rules like “every function must be under 20 lines” or “coverage must always exceed 95%” unless a specific context justifies them.

Prefer constraints directly tied to failure risk or change cost.

## Architecture rule lifecycle

For each guardrail define:

- **Purpose:** what failure/change risk it prevents.
- **Scope:** where it applies.
- **Mechanism:** test/linter/policy/tool.
- **Exception process:** how legitimate exceptions are documented.
- **Owner:** who maintains it.
- **Removal/review condition:** when it may no longer be useful.

A stale or noisy rule teaches developers and agents to ignore the architecture system.

## Exceptions

Avoid silent bypasses. When a necessary exception occurs:

1. document why the rule does not fit;
2. keep the exception narrow;
3. add an owner or follow-up if temporary;
4. reconsider the rule if exceptions become common.

Frequent exceptions may indicate the architecture model is wrong.

## CI layering

Aim for fast feedback:

1. local formatter/compiler/lint/unit checks;
2. dependency/architecture checks;
3. integration/contract tests;
4. migration/security checks;
5. slower E2E/load/environment tests where needed.

Do not place every expensive check in the innermost loop.

## Architecture maps as executable knowledge

Where practical, generate parts of architecture documentation from source/configuration rather than manually duplicating facts. Examples:

- dependency graphs;
- database schemas;
- API specifications;
- service inventories;
- ownership metadata.

Generated artifacts reduce documentation drift, but explanatory design rationale still requires human/agent-authored prose.

## Governance without central bottlenecks

Architecture governance should make safe choices easy, not require approval for every code change.

Prefer:

- clear default patterns;
- examples/reference implementations;
- automated boundary enforcement;
- ADRs for consequential deviations;
- periodic architecture/technical-debt review;
- ownership close to the code.

Reserve heavyweight review for high-reversal-cost or cross-boundary decisions.

## Agent-oriented repositories

Coding agents benefit from explicit, discoverable structure. Keep top-level instructions concise and point to deeper sources of truth.

Useful repository knowledge may include:

- architecture map;
- verification commands;
- conventions and boundary rules;
- active migration plans;
- reliability/security docs;
- generated schema/API references;
- ADR index.

Do not stuff all detail into one always-loaded instruction file. Progressive disclosure improves both human navigation and agent context efficiency.

## Escalation trigger

Add a new guardrail when the same class of defect or architectural drift appears repeatedly. The durable fix is often:

> document once -> automate next -> remove recurring review burden.

But do not automate subjective judgement that requires context; preserve design review for trade-offs that cannot be reduced to an invariant.
