# Safe Change and Refactoring

Use this reference when modifying mature, legacy, risky, poorly tested, or highly coupled code.

## Primary rule

Refactoring changes structure without intentionally changing externally meaningful behavior. Keep functional changes and structural changes separable whenever practical.

## Do not rewrite by default

A rewrite discards years of encoded edge cases, operational knowledge, bug fixes, and compatibility behavior. Consider a rewrite only when incremental evolution is demonstrably more expensive or unsafe and a realistic migration path exists.

Prefer strangler-style or component-by-component replacement over flag-day rewrites.

## Establish a safety net

Before changing poorly understood behavior:

1. Identify the externally meaningful behavior that must remain.
2. Add characterization tests around that behavior where feasible.
3. Capture important production examples or fixtures when appropriate.
4. Verify the test fails when the behavior is deliberately perturbed, so it is not a false safety net.

Characterization tests document what the system does, not necessarily what it ought to do.

## Triage structural entropy

Treat "spaghetti code" as a starting description, not a diagnosis. Before editing, build a short, evidence-based inventory of the places where structure increases change cost or defect risk. For each candidate, record:

- the observable symptom and concrete files or execution flow;
- the behavior and compatibility contracts at risk;
- the responsibilities, state, and side effects currently mixed together;
- evidence that the area changes often, causes defects, duplicates knowledge, or blocks requested work;
- the smallest refactoring move that could improve it;
- how the move will be verified.

Prioritize code on active or critical paths, duplicated business decisions, unsafe side effects, high change amplification, and areas blocking current work. File length, function length, complexity scores, and duplication detectors are useful search signals, but they do not prove that a refactor is valuable.

### Long functions, classes, or UI components

Do not split code merely to make it shorter. First identify its phases, decisions, invariants, state ownership, and side effects.

Then improve cohesion one step at a time:

1. Characterize the behavior through the most stable observable boundary available.
2. Name and extract a cohesive phase, rule, or pure calculation.
3. Isolate external effects from decisions where that creates a useful test seam.
4. Move behavior toward the state or domain concept it governs.
5. Leave orchestration readable at one level of abstraction.

The result should reduce what a maintainer must understand at once. A large function replaced by many one-line forwarding functions is not an improvement.

### Duplicated code and implementations

Classify duplication before removing it:

- **Duplicated knowledge:** copies encode the same business rule or policy and should change together. Give that knowledge one canonical owner and migrate callers incrementally.
- **Duplicated mechanism:** copies perform the same technical operation. Consolidate when a stable capability and ownership boundary are clear.
- **Coincidental similarity:** code looks alike today but represents different concepts or change pressures. Keep it separate until shared semantics are demonstrated.

Use defect history, co-change history, domain language, and caller expectations as evidence. Preserve differences in validation, errors, ordering, transactions, performance, and side effects; superficial deduplication can silently erase real contracts.

### Unclear boundaries and mixed responsibilities

Trace representative behavior end to end, then identify who should own each invariant, state transition, and side effect. Cluster code that changes for the same reason and separate code with independent change pressures.

Prefer a boundary when it:

- gives one concept or capability a clear owner;
- hides implementation detail behind a smaller stable interface;
- stops unrelated modules from reaching through each other;
- isolates an external effect or volatile dependency;
- reduces the number of places a likely change must touch.

Test a proposed boundary against real changes: describe how a recent bug or plausible requirement would flow through it. If the change still requires navigating many wrappers or editing unrelated modules, the boundary has not improved locality.

### Make one vertical improvement at a time

Choose one coherent behavior slice rather than reorganizing the repository horizontally by file type. For each slice:

1. Establish passing verification or characterize current behavior.
2. Make one structural move.
3. Re-run the narrowest relevant feedback immediately.
4. Run broader verification before committing or handing off.
5. Remove transitional code once all callers have migrated.

After repeated problems reveal a stable rule, add a focused guardrail such as cycle detection, forbidden imports, ownership checks, complexity signals, or duplicate-code reporting. Use thresholds to direct review, not as automatic proof that code is poorly designed.

## Find seams

A seam is a place where behavior can be changed or observed without rewriting the whole system. Useful seams include:

- function/module boundaries;
- interfaces already present for real reasons;
- HTTP/event/database boundaries;
- configuration/provider injection;
- wrappers around time, randomness, filesystem, or network effects;
- extraction of a pure calculation from effectful code.

Create the smallest seam needed for safe change.

## Preparatory refactoring

Sometimes the cleanest way to add behavior is to first reshape the code while preserving behavior. Examples:

- rename ambiguous concepts;
- extract a cohesive function;
- move a responsibility to its natural owner;
- isolate an external side effect;
- remove a cycle;
- introduce a narrow boundary around volatile infrastructure.

Keep preparatory steps independently verifiable. Small commits are useful when the workflow permits them.

## Sprout and wrap techniques

When changing fragile code:

- **Sprout method/function:** add new behavior in a new tested unit, then call it from old code.
- **Sprout class/module:** introduce a cohesive new responsibility rather than expanding an untestable god object.
- **Wrap method/function:** preserve the old behavior but wrap it with new behavior before/after.
- **Wrap class/module:** place a boundary around legacy behavior to control access and migration.

These are transition techniques. Avoid leaving unnecessary wrappers forever.

## Branch by abstraction

For large replacements that must be deployed incrementally:

1. Establish a stable boundary around old behavior.
2. Route current callers through it.
3. Implement the new behavior behind the same semantic boundary.
4. Migrate traffic/callers gradually.
5. Compare behavior or outcomes where possible.
6. Remove the old implementation and transition abstraction when no longer useful.

## Refactor toward locality

A strong refactor often makes a future change require understanding fewer concepts and editing fewer unrelated locations.

Prefer:

- one concept with one canonical representation inside a boundary;
- rules near the data/state transitions they govern;
- explicit state transitions;
- narrower public APIs;
- clear ownership of side effects.

## Avoid speculative cleanup

Do not mix unrelated cleanup with a feature or bug fix merely because the files are nearby. It increases review surface and makes regressions harder to locate.

If cleanup is valuable but not required for the requested change, separate it or record it as follow-up.

## Preserve compatibility during structural change

Watch for accidental changes to:

- serialization formats;
- public exceptions/error codes;
- event payloads;
- database query semantics;
- ordering;
- timing and retry behavior;
- concurrency guarantees;
- configuration names/defaults;
- logging/metrics relied upon operationally.

Implementation details may be observable contracts in production.

## Refactoring red flags

Stop and reassess when:

- the diff grows far beyond the behavior being changed;
- tests require large-scale rewriting because they assert internals;
- public APIs are being altered to make an internal design prettier;
- multiple new patterns/frameworks are introduced at once;
- a migration has no coexistence strategy;
- rollback depends on restoring incompatible old data;
- the refactor cannot be explained in terms of reduced change cost, risk, or cognitive load.

## Completion criteria

A successful refactor should provide evidence of improvement, such as:

- a dependency cycle removed;
- fewer concepts involved in a common change;
- a stable boundary around volatile code;
- business rules consolidated;
- tests focused on behavior rather than implementation;
- reduced initialization/order coupling;
- a formerly implicit invariant made explicit;
- an enforceable architecture rule added.

Do not claim maintainability improvement solely because the code uses more patterns or smaller functions.
