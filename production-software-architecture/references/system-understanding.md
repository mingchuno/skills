# Understanding an Existing System

Use this reference before significant work in an unfamiliar, mature, or poorly documented codebase. The goal is to build the smallest accurate mental model needed to change the system safely.

## Start from behavior, not folders

Do not assume a directory named `domain`, `service`, `core`, or `infrastructure` has the semantics its name suggests. Trace representative behavior end to end.

For a feature or subsystem, identify:

1. Entry points: HTTP/RPC handlers, event consumers, CLI commands, scheduled jobs, UI actions, libraries, or public functions.
2. Boundary validation and authentication/authorization.
3. Business decisions and invariant enforcement.
4. Data access and external integrations.
5. Async hand-offs and event publication.
6. Output/response construction.
7. Error paths and retry behavior.
8. Tests exercising the flow.

Follow both control flow and data flow.

## Build a change map

Before editing, summarize:

- **Behavior:** what users or callers observe.
- **Owners:** modules/services/components responsible for it.
- **State:** where durable and transient state lives.
- **Contracts:** public APIs, events, schemas, database structures, configuration, and files.
- **Dependencies:** internal modules and external systems.
- **Verification:** tests, static analysis, CI, smoke checks.
- **Operations:** deployment unit, scaling model, observability, common failure modes.

This map can be informal for small work. Do not create documentation solely to satisfy a process.

## Inspect architecture evidence

Prefer evidence in roughly this order:

1. Executable code and configuration.
2. Tests and contract fixtures.
3. Deployment/infrastructure configuration.
4. Current architecture/design documentation.
5. ADRs and historical change records.
6. Comments and naming.

Documentation can be stale. When documentation and behavior conflict, flag the discrepancy instead of silently choosing one.

## Identify architectural pressure points

Look for areas where change cost is amplified:

- the same concept translated repeatedly across layers;
- one change requiring edits across many unrelated packages;
- package cycles;
- broad utility/common modules depended on by everything;
- infrastructure types leaking into business logic;
- global mutable state;
- duplicated business rules;
- implicit ordering or initialization assumptions;
- transactional boundaries spanning unrelated responsibilities;
- remote calls hidden behind apparently local APIs;
- tests requiring excessive setup for simple behavior;
- modules whose public APIs expose implementation details;
- ownership boundaries that differ from code boundaries.

Treat these as evidence, not automatic refactoring targets.

## Measure change amplification

A maintainability smell is often easier to see as a change pattern:

> If requirement X changes, how many concepts, modules, deployments, schemas, or teams must change together?

High change amplification may justify a better boundary. However, a change touching several files is not inherently bad if those files form one cohesive unit.

## Distinguish essential and accidental complexity

**Essential complexity** comes from the problem: regulations, concurrency, money movement, real-time constraints, distributed ownership, complicated rules.

**Accidental complexity** comes from the implementation: needless layers, duplicated models, framework ceremony, implicit control flow, unnecessary distribution.

Do not promise to remove essential complexity. Concentrate it behind good abstractions and make it explicit.

## Respect local consistency

A mature system has a vocabulary and established mechanisms. Before introducing a new pattern, ask:

- Does an existing mechanism already solve this problem adequately?
- Would a new pattern force maintainers to learn a second way of doing the same thing?
- Is the existing approach unsafe, or merely not what I would choose in a greenfield system?

Prefer consistency unless there is evidence that the current approach causes recurring defects, unsafe change, or unacceptable cost.

## When documentation is missing

Do not compensate by inventing architecture. Derive a model from code and label uncertain conclusions as hypotheses.

For consequential uncertainty, gather evidence through tests, history, runtime configuration, production telemetry, or subject-matter input when available.

## Useful deliverable for exploration

When asked to explain a subsystem, produce a concise architecture map containing:

- purpose;
- major components and responsibilities;
- important request/event/data flows;
- state ownership;
- external dependencies;
- failure boundaries;
- testing/verification mechanisms;
- known risks or unclear areas.

Avoid narrating every class or file.
