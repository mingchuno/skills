# Refactoring reference

Refactoring in Martin Fowler's sense: change internal structure while keeping observable behavior. Consult the section the current step needs.

## Behavior contracts

Implementation details are often production contracts. Before a structural change, list the ones the target touches:

- return values, outputs and rendered results;
- side effects and their order;
- error types, error codes, messages relied on by callers;
- serialization formats, event payloads and public signatures;
- database query semantics and transaction boundaries;
- ordering, timing, retry and concurrency guarantees;
- configuration names and defaults;
- logs and metrics that operators or alerts rely on.

A behavior change, when the task asks for one, is its own step and its own commit, after the structure is ready for it.

## Safety net

- Cover each listed contract with a test that asserts externally visible behavior, through the most stable boundary available.
- Where behavior is unclear, write characterization tests: they record what the code does, which may differ from what it should do. Fix undesirable behavior later, as a separate behavior change.
- Prove each new test can fail: perturb the behavior and watch it go red, then restore.
- With no tests and no cheap way to add them, make the smallest structural move that creates a test seam (see [Seams](#seams)) and widen the net from there.
- Keep test edits aligned with preserved behavior. A failing test is a signal to investigate; it stays until the behavior question is answered.
- Refactor noisy or duplicated tests too, keeping test data expressive and minimal.

## Triage

Treat "messy code" as a symptom to locate. For each candidate area, record:

- the symptom, with files or the execution flow;
- the contracts at risk;
- the responsibilities, state and side effects mixed together;
- evidence that it changes often, causes defects, duplicates knowledge, or blocks the current work;
- the smallest move that could improve it, and how that move will be verified.

Rank by active or critical paths, duplicated business decisions, unsafe side effects, change amplification, and what blocks current work. Length, complexity scores and duplication detectors direct attention; the evidence above decides.

### Long functions, classes and components

Identify phases, decisions, invariants, state ownership and side effects first. Then, one step at a time: extract a cohesive phase, rule or pure calculation with an intent-revealing name; separate effects from decisions where that creates a test seam; move behavior toward the state it governs; leave the orchestration readable at one level of abstraction. The goal is less to understand at once, so a cohesive linear procedure can stay long.

### Duplication

Classify before consolidating:

- **Duplicated knowledge:** the same business rule that must change together. Give it one owner and migrate callers incrementally.
- **Duplicated mechanism:** the same technical operation. Consolidate once a stable capability and owner are clear.
- **Coincidental similarity:** alike today, different concepts or change pressures. Keep separate until shared meaning is demonstrated.

Preserve the differences copies may hide: validation, errors, ordering, transactions, performance and side effects. Consolidate into the owning concept, keeping `utils`-style catch-all modules for genuinely generic code. Rule of three: the third copy is the usual trigger.

### Mixed responsibilities

Trace representative behavior end to end and name who should own each invariant, state transition and side effect. Group code that changes for the same reason. Test a candidate boundary against a recent bug or a plausible requirement: a good boundary lets that change touch fewer places.

## Smells and moves

| Smell | Target structure |
| --- | --- |
| Duplicated code | One owner per piece of knowledge. |
| Long function | Coherent named steps at one abstraction level; parsing, validation, computation and I/O as separate phases. |
| Long parameter list | Parameter objects or domain types for recurring clumps; separate explicit functions in place of behavior-switching boolean flags. |
| Global data, hidden dependencies | Dependencies passed in or owned explicitly. |
| Divergent change (one unit, many reasons to change) | One unit per reason: policy apart from formatting, transport, persistence and framework code. |
| Shotgun surgery (one change, many files) | The knowledge centralized behind a clearer boundary. |
| Feature envy | Behavior moved to the data or concept it uses. |
| Data clumps, primitive obsession | Named value types with validation. |
| Repeated switches on type or mode | Polymorphism, a table or a strategy, once the variation is real and recurring; a single honest conditional stays. |
| Temporary fields, half-initialized objects | Explicit states or a separate object per phase. |
| Middle man, speculative generality | Inlined forwarding layers; abstractions kept only while they earn their keep. |

Target structure, by level:

- **Functions:** one coherent task, consistent abstraction level, tight variable scope, side effects only where they are the purpose, guard clauses for the normal path, dead code deleted.
- **Classes and modules:** a narrow reason to change, organized around domain concepts, composed from focused units.
- **Conditionals:** extracted predicates, guard clauses, lookup tables for stable mappings, polymorphism for repeated type-based behavior. Simple explicit conditionals stay as they are.
- **Data and mutation:** mutation encapsulated behind intention-revealing operations, the smallest write surface, one place per state transition, immutable intermediates where they simplify reasoning.
- **Errors:** the main path visible, cleanup and recovery consolidated, similar error paths standardized, existing error semantics kept.

## Catalog

Choose the simplest named move that helps. Rename first when bad names block understanding.

### Composing methods

- **Extract Function** when a fragment has a coherent purpose and a useful name; **Inline Function** when the body is clearer than the indirection.
- **Extract Variable** to name parts of a complex expression; **Inline Variable** when a temporary obscures a direct expression.
- **Replace Temp with Query** when a calculated value deserves a name and can be reused safely.
- **Split Variable** when one variable carries several meanings; **Remove Assignments to Parameters** when mutation obscures the input.
- **Replace Function with Command** when local state blocks clean extraction.
- **Substitute Algorithm** when a clearer algorithm has identical behavior.
- **Slide Statements** to group related operations.

### Moving features

- **Move Function / Move Field** when behavior or state belongs to another concept.
- **Extract Class** for a second reason to change; **Inline Class** when a class no longer earns its existence.
- **Hide Delegate** when clients know too much about a collaborator; **Remove Middle Man** when the forwarder hides nothing useful.

### Organizing data

- **Encapsulate Variable / Encapsulate Collection** when outside mutation can bypass invariants.
- **Replace Primitive with Object** when a value carries behavior, validation or meaning.
- **Introduce Parameter Object / Preserve Whole Object** for values that travel together.
- **Change Reference to Value** when value semantics simplify ownership; **Change Value to Reference** when identity and shared updates matter.
- **Replace Type Code with Subclasses or State/Strategy** when behavior varies by type; **Replace Subclass with Field** when only data varies.
- **Replace Magic Literal** with a named constant or domain type.

### Simplifying conditionals and calls

- **Decompose Conditional, Consolidate Conditional Expression** to make branching intent visible.
- **Replace Nested Conditional with Guard Clauses** to expose the normal path; **Replace Control Flag with Break/Return**.
- **Replace Conditional with Polymorphism** for repeated type-based behavior; **Introduce Special Case** for repeated null handling with a stable meaning.
- **Introduce Assertion** to make an assumption explicit.
- **Change Function Declaration, Parameterize Function, Remove Flag Argument** to make caller intent clear.
- **Remove Setting Method** when post-construction mutation should end; **Hide Method** to shrink public surface.
- **Replace Constructor with Factory Function** when creation needs a name or picks a subtype.
- **Replace Error Code with Exception** or **Replace Exception with Precheck**, matching the expected failure model.

### Generalization

- **Pull Up / Push Down Method or Field** to put shared behavior where it is genuinely shared.
- **Extract Superclass / Extract Interface** when callers or real variation points need them; **Collapse Hierarchy** when inheritance adds nothing.
- **Form Template Method** when algorithms differ in controlled steps.
- **Replace Superclass or Subclass with Delegate** when inheritance couples unrelated responsibilities.
- **Separate Domain from Presentation** when UI and policy are tangled.

## Legacy code

For fragile, untested or highly coupled code. A rewrite discards encoded edge cases, fixes and compatibility; prefer incremental replacement, and consider a rewrite only when incremental evolution is demonstrably costlier and a migration path exists.

### Seams

A seam is a place to change or observe behavior without rewriting the surrounding code: a function or module boundary, an existing interface with a real purpose, an HTTP, event or database boundary, configuration or provider injection, a wrapper around time, randomness, filesystem or network, or a pure calculation extracted from effectful code. Create the smallest seam the change needs.

### Sprout and wrap

- **Sprout function or class:** write new behavior in a new tested unit and call it from the old code.
- **Wrap function or class:** keep old behavior and add new behavior before or after it, or put a boundary around legacy behavior to control access during migration.

These are transition techniques: remove a wrapper once its job is done.

### Branch by abstraction

For a large replacement shipped incrementally:

1. Put a stable boundary around the old behavior and route callers through it.
2. Build the new implementation behind the same semantic boundary.
3. Migrate callers or traffic gradually, comparing outcomes where possible.
4. Remove the old implementation, then the transitional abstraction if it no longer earns its place.

For one coherent slice at a time: green checks, one structural move, the narrowest relevant checks, broader checks before commit, transitional code removed once callers migrate.

## Feature work

When adding behavior to existing code:

1. Understand current behavior and name what makes the change awkward.
2. Strengthen the safety net where the change lands.
3. Reshape that local structure (rename, extract, move, split, inline) until the change is easy.
4. Make the behavior change.
5. Clean up debt the change introduced, then stop.

When fixing a bug in unclear code, characterize the current failure and refactor only enough to make the fix visible. Cleanup that is valuable but not needed for the change goes into a separate change or a follow-up note.

## Patch discipline

- Structural edits, behavior changes and test updates in separate commits where practical.
- Related refactorings grouped; each commit understandable on its own.
- A patch too large to reason about locally is split.
- Renames, moves and redesigns land as separate reviewable steps.

## Reassess

Return to triage and choose a smaller move when:

- the diff grows far beyond the behavior being changed;
- tests need large rewrites because they assert internals;
- a public API is changing only to make internals prettier;
- several new patterns, layers or frameworks arrive at once;
- the change adds files, wrappers or renames while the friction it targeted remains;
- the improvement cannot be stated as reduced change cost, risk or cognitive load.

## Stopping point

Stop when the requested change is easy, the blocking smell is gone, readability and local changeability are clearly better, and the next move would be speculative. Report deferred cleanup as follow-up.

Evidence of a real improvement: fewer concepts involved in a common change, business rules consolidated, a dependency cycle removed, an implicit invariant made explicit, reduced initialization or order coupling, tests that assert behavior rather than structure.

## Final checklist

- Observable behavior preserved, every listed contract checked?
- Structural change, behavior change and test updates separated where practical?
- Safety net in place, or verification gaps recorded?
- At least one real source of friction removed?
- Names, responsibilities, control flow, data ownership and interfaces clearer?
- Every added abstraction backed by a present need?
- Patch reviewable, and the code buildable and runnable?

Revise any step that answers no before reporting.
