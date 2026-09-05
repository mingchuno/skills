# Boundaries and Modularity

Use this reference when designing packages, modules, components, libraries, services, or internal APIs.

## The purpose of a boundary

A useful boundary does at least one of the following:

- hides implementation detail;
- protects an invariant or policy;
- localizes a likely source of change;
- prevents unwanted dependency direction;
- separates ownership or trust domains;
- isolates failure or resource consumption;
- exposes a stable capability to several callers;
- provides a meaningful substitution/test seam.

A boundary that merely creates another file or forwarding object has negative value.

## Prefer high cohesion

Keep logic together when it changes for the same reason and operates on the same concepts/invariants.

Do not split a cohesive behavior across controller/service/manager/helper/repository layers solely because an architecture template says every application needs them.

A module should be describable by a concrete responsibility, not by a vague technical suffix.

## Reduce coupling deliberately

Coupling is not merely importing another module. Ask what kind of knowledge crosses the boundary:

- data representation;
- control-flow expectations;
- lifecycle/order assumptions;
- failure semantics;
- transaction semantics;
- implementation details;
- deployment/version assumptions.

A small API can still be tightly coupled if callers must know hidden sequencing or implementation details.

## Dependency direction

Stable policy should avoid depending directly on volatile implementation detail when that dependency creates meaningful change amplification.

Useful dependency inversions often occur at:

- external services;
- persistence technology;
- runtime/platform APIs;
- time/randomness/environment boundaries where determinism matters;
- independently owned subsystems.

Do not create an interface for every concrete type. Direct dependencies are appropriate when the dependency is stable, local, and substitutability adds no value.

## Deep modules

Prefer modules with:

- a small, understandable interface;
- substantial functionality behind that interface;
- hidden internal policy/mechanism;
- defaults that make the common case easy;
- few ordering requirements;
- errors expressed at the right abstraction level.

Avoid shallow modules where the interface complexity is comparable to the implementation complexity.

### Example smell

`OrderController -> OrderService -> OrderManager -> OrderProcessor -> OrderRepository` is suspicious if each layer only forwards arguments.

A simpler `Orders` capability with a stable API and substantial private implementation may be easier to understand and change.

## Minimize conceptual surface area

Count concepts a maintainer must understand, not files. New concepts include:

- architectural layers;
- framework abstractions;
- custom DSLs;
- messaging patterns;
- caches;
- background processors;
- synchronization primitives;
- custom error hierarchies;
- generic extension points;
- special deployment units.

Add a concept only when the problem it solves is more expensive than the concept itself.

## Abstraction rule

Create an abstraction when at least one is true:

1. Multiple concrete behaviors genuinely share a stable semantic contract.
2. A volatile implementation must be hidden from stable policy.
3. A security/trust/ownership boundary needs explicit control.
4. Testing requires control of a non-deterministic or external effect and simpler alternatives are inadequate.
5. Repetition reveals a stable domain concept rather than coincidental syntax.

Avoid abstractions justified only by hypothetical future reuse.

## Rule of three is evidence, not law

Repeated code may indicate missing abstraction, but duplication is sometimes cheaper than coupling unrelated behaviors.

Before unifying code, ask whether the duplicates are expected to change together. If not, premature deduplication can create a false dependency.

## Domain boundaries

Use domain-oriented boundaries when business concepts, rules, ownership, lifecycle, or language differ materially.

A bounded context or domain module is useful when it protects a coherent model. Do not create DDD artifacts merely to rename ordinary application code.

### Aggregates and consistency

If using aggregate-style modeling, choose boundaries from invariants and transaction requirements. Avoid large object graphs simply because entities are related in the business domain.

## Service boundaries

A service boundary adds network, deployment, failure, versioning, observability, and operational complexity. Split services when independent deployment/scale/ownership/failure isolation or sharply distinct domain boundaries justify that cost.

Do not use microservices to solve ordinary code modularity problems.

A well-structured modular monolith is often the safer default for a system without strong distribution requirements.

## Shared libraries

A shared library creates version and coordination coupling. Keep shared libraries focused on stable, genuinely shared capabilities.

Avoid dumping cross-domain business logic into `common`, `shared`, or `utils` packages. Prefer domain ownership and explicit reuse where necessary.

## Framework isolation

Do not isolate frameworks ritualistically. Isolate framework concepts when doing so protects important policy, enables evolution, or reduces testing/operational coupling.

Framework types at outer application edges are often fine. Framework types spreading through core business logic can be costly when they dictate lifecycle, persistence, serialization, or failure semantics.

## Naming

Prefer domain/capability names:

- `Pricing`, `Billing`, `InventoryReservation`, `TokenValidation`

over pattern/technical names that reveal little:

- `Manager`, `Processor`, `Helper`, `BaseService`, `CommonUtils`.

Use technical names when the responsibility is genuinely technical, such as `HttpClient`, `MigrationRunner`, or `TraceExporter`.

## Architecture evaluation

A good module boundary should make at least one likely future change cheaper while keeping current behavior understandable.

Ask:

- Can this module be changed without understanding most of the system?
- Does its API expose what callers need rather than how it works?
- Are errors and side effects visible enough for callers to reason about?
- Does it own its invariants and state transitions?
- Would deleting or replacing it require touching many unrelated consumers?
