---
name: production-software-architecture
disable-model-invocation: true
description: Design, review, evolve, and refactor production software for long-term maintainability, including boundaries, compatibility, operability, and architecture guardrails. Invoke explicitly for system-level architecture work.
metadata:
  version: "1.1.0"
  scope: language-agnostic
---

# Production Software Architecture

Apply only when the user explicitly invokes this skill.

Use this skill to make software easier to change safely over years of production use. Optimize for comprehensibility, explicit boundaries, controlled coupling, operational safety, and reversible evolution—not maximum abstraction or architectural fashion.

## Core stance

- Preserve working behavior unless change is explicitly required.
- Understand the existing system before prescribing a new structure.
- Prefer local consistency over theoretical purity unless the current convention is actively harmful.
- Prefer the smallest design that clearly satisfies present requirements and known near-term pressures.
- Introduce abstractions when there is evidence of variation, policy, boundary protection, or repeated change—not merely because a pattern exists.
- Prefer deep modules: small, stable interfaces hiding substantial implementation detail.
- Minimize conceptual surface area. Every new layer, interface, framework, dependency, service, queue, cache, or data store creates maintenance cost.
- Treat operability, failure modes, migrations, security, and compatibility as architecture—not afterthoughts.
- Convert recurring architectural rules into machine-checkable constraints whenever practical.
- Leave the codebase easier to understand and safer to change than before.

## First: classify the task

Before changing code, decide which mode applies:

1. **Explore** — understand an unfamiliar codebase or subsystem.
2. **Design** — plan a new capability or substantial structural change.
3. **Implement** — add behavior within an established architecture.
4. **Refactor** — improve structure without intentionally changing behavior.
5. **Migrate** — evolve data, APIs, infrastructure, dependencies, or runtime behavior safely.
6. **Review** — assess a proposal, PR, subsystem, or architecture for production fitness.
7. **Harden** — add mechanical guardrails, observability, failure handling, security, or operational controls.

Use only the parts of this skill relevant to the current mode.

## Workflow

### 1. Establish context before design

Inspect the repository and relevant surrounding code before proposing architecture. Identify:

- user/business behavior being protected or added;
- current module/package/service boundaries;
- dependency direction and integration points;
- public APIs, events, schemas, storage, and compatibility contracts;
- tests and verification commands;
- runtime topology and major operational dependencies;
- existing architectural conventions and documented decisions;
- likely blast radius of the change.

Do not infer architecture from directory names alone. Trace representative execution and data flows.

For detailed exploration guidance, read `references/system-understanding.md`.

### 2. State invariants and constraints

Before choosing a design, make important constraints explicit. Examples:

- behavior and compatibility that must not break;
- transactional or consistency requirements;
- latency, throughput, availability, and durability needs;
- security/privacy boundaries;
- deployment and rollback constraints;
- team ownership or organizational boundaries;
- expected change patterns;
- language/framework/runtime limitations.

Separate **hard constraints** from preferences and assumptions. Challenge assumptions that create complexity.

### 3. Choose boundaries from change and responsibility

Group code around coherent responsibilities and information hiding. A boundary is justified when it reduces coupling, protects an invariant, isolates volatility, supports independent ownership/deployment, or creates a useful test seam.

Avoid boundaries that exist only to mirror technical layers or design-pattern terminology. A one-line interface around a one-line implementation is usually not architectural value.

For module design, dependencies, and abstraction heuristics, read `references/boundaries-and-modularity.md`.

### 4. Design for failure and evolution

For every non-trivial production change, ask:

- What can fail?
- What happens on timeout, partial success, retry, duplication, reordering, or stale data?
- Which operation must be atomic, and which can be eventually consistent?
- How is failure observed and diagnosed?
- Can the change be deployed incrementally?
- Can old and new versions coexist during rollout?
- What is the rollback or roll-forward strategy?

Read `references/failure-data-and-evolution.md` when the change touches remote calls, async workflows, databases, schemas, migrations, distributed state, or public contracts.

### 5. Implement the smallest coherent change

During implementation:

- follow established naming and structure unless there is a concrete reason not to;
- keep business rules near the concepts they govern;
- parse/validate untrusted input at system boundaries;
- keep side effects explicit;
- avoid hidden global state and temporal coupling;
- prefer composition and ordinary language features over framework magic;
- remove accidental complexity introduced by the change;
- avoid opportunistic repo-wide rewrites in feature work.

If existing design makes the change unsafe, perform the minimum preparatory refactor first.

For legacy, high-risk, AI-generated, duplicated, overly long, or poorly separated code, read `references/safe-change-and-refactoring.md` before editing. Use its structural-triage workflow to distinguish local code smells from boundary problems and select the smallest safe improvement.

### 6. Verify behavior and architecture

Verification should cover more than unit tests. Use the cheapest combination that provides confidence:

- characterization tests for poorly understood existing behavior;
- focused unit tests for logic and invariants;
- integration/contract tests at important boundaries;
- migration verification and rollback/roll-forward testing;
- static analysis and type checks;
- architecture/dependency checks;
- security and dependency scanning where appropriate;
- smoke or end-to-end tests for critical flows.

Do not write tests that merely reproduce the implementation. Test externally meaningful behavior and important invariants.

Read `references/testing-and-verification.md`.

### 7. Make the system operable

Production readiness includes the ability to detect, understand, and mitigate failures. Ensure new behavior has appropriate:

- structured logs at useful boundaries;
- metrics for demand, errors, latency, saturation, and domain outcomes;
- traces/correlation where distributed execution matters;
- health/readiness semantics that reflect real dependencies;
- actionable alerts tied to user or system impact;
- safe configuration, timeouts, retries, rate limits, and resource bounds;
- deployment, rollback, and incident diagnostics.

Read `references/operability-and-production-readiness.md`.

### 8. Capture consequential decisions

Write or update an ADR/design note when a decision is expensive to reverse, changes an architectural boundary or public contract, introduces significant operational complexity, adopts a new persistence/integration model, or is likely to be questioned later.

Record context, decision, alternatives, consequences, assumptions, and follow-up—not a retrospective essay.

Read `references/architecture-decisions.md`.

### 9. Turn recurring rules into guardrails

If a convention matters repeatedly, prefer executable enforcement over prose alone. Examples:

- allowed package/module dependency directions;
- forbidden imports;
- API/schema compatibility checks;
- database migration linting;
- cycle detection;
- public dependency policies;
- complexity or size thresholds used as signals, not dogma;
- secret, vulnerability, and static-analysis gates;
- required ownership or architecture metadata.

Keep guardrails focused on invariants. Do not micromanage implementation style through brittle rules.

Read `references/fitness-functions-and-governance.md`.

## Architecture review questions

Use these questions when reviewing a design or implementation:

1. What problem and invariant does this design address?
2. Is the proposed complexity proportional to the problem?
3. Which concepts must a maintainer understand to change it safely?
4. Are responsibilities cohesive and boundaries meaningful?
5. Does dependency direction reflect policy and volatility?
6. Are abstractions backed by real variation or boundary needs?
7. Where can partial failure occur, and is behavior explicit?
8. Are consistency and transaction boundaries deliberate?
9. Can the system evolve without a flag day?
10. Are public contracts backward compatible or intentionally versioned?
11. Can operators tell whether it works in production?
12. Can important architecture rules be checked automatically?
13. What would make this design difficult to remove or replace later?
14. Is there a simpler design with comparable safety?

## Red flags

Challenge designs exhibiting several of these:

- controllers/services/managers/processors that only forward calls;
- interfaces created for every class without an actual seam or variation;
- generic repositories hiding important data semantics;
- domain concepts scattered across unrelated modules;
- circular dependencies or widespread cross-module reach-through;
- shared mutable state with unclear ownership;
- distributed transactions introduced casually;
- synchronous remote calls in long dependency chains;
- retries without idempotency or retry budgets;
- caches without ownership, invalidation, or correctness rules;
- schema changes requiring simultaneous deployment of every consumer;
- “temporary” compatibility paths with no removal plan;
- tests tightly coupled to private implementation structure;
- logs as the only observability mechanism;
- abstractions named after patterns rather than the domain;
- new infrastructure introduced before simpler options are disproved;
- large cleanup mixed into a functional change with no safety net.

## Do not apply architecture dogmatically

Do not require Clean Architecture, Hexagonal Architecture, DDD, CQRS, event sourcing, microservices, repositories, dependency injection containers, or GoF patterns by default. Use them only when their trade-offs solve concrete problems in the current system.

`SOLID` and similar principles are heuristics, not acceptance criteria. Prefer direct evidence: coupling, change amplification, cognitive load, testability, failure isolation, and operational behavior.

## Output expectations

When asked for an architecture proposal or review, communicate:

1. **Context and constraints** — what matters and what is assumed.
2. **Current-state observations** — only what was actually inspected or provided.
3. **Proposed design** — boundaries, responsibilities, and key flows.
4. **Trade-offs** — benefits, costs, rejected alternatives, and reversibility.
5. **Failure/evolution plan** — rollout, compatibility, migration, rollback/roll-forward.
6. **Verification** — tests and mechanical constraints.
7. **Operational impact** — observability, capacity, security, and run-time concerns.
8. **Open risks** — unresolved uncertainties requiring evidence.

For small implementation tasks, do not force this full document format. Apply the principles silently and keep the response proportional.

## Reference map

Load only the references needed for the task:

- `references/system-understanding.md` — exploring unfamiliar or legacy systems.
- `references/boundaries-and-modularity.md` — modules, coupling, cohesion, dependencies, abstractions, deep modules.
- `references/safe-change-and-refactoring.md` — incremental refactoring and legacy-code modification.
- `references/testing-and-verification.md` — test strategy, characterization, contracts, architecture checks.
- `references/failure-data-and-evolution.md` — failures, distributed behavior, data consistency, schemas, migrations, compatibility.
- `references/operability-and-production-readiness.md` — observability, reliability, deployment, capacity, security basics.
- `references/architecture-decisions.md` — ADRs and design records.
- `references/fitness-functions-and-governance.md` — CI guardrails, dependency rules, architecture governance.
- `references/review-checklists.md` — concise review checklists for design, implementation, migrations, and production readiness.

## Final quality bar

Before completing a substantial architecture or code change, confirm that:

- the existing system was inspected enough to avoid speculative redesign;
- added concepts have clear responsibilities and names;
- complexity is justified by a concrete constraint or change pressure;
- failure and migration paths are explicit where relevant;
- important behavior is verified independently of implementation details;
- production behavior will be observable;
- backward compatibility is preserved or intentionally managed;
- recurring architecture invariants are mechanically enforceable where practical;
- unrelated cleanup was avoided or separated;
- the resulting system is easier—not merely more fashionable—to maintain.
