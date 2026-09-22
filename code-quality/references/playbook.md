# Diagnosis to transformation

Choose a dominant diagnosis supported by code and observed change difficulty. Secondary diagnoses may supply regression guards. A threshold crossing invites inspection, not an automatic rewrite.

| Diagnosis | Establish first | Smallest useful moves | Verification focus |
| --- | --- | --- | --- |
| `CONTROL_FLOW_COMPLEXITY` | Which decisions or nesting obscure the behavior? | Flatten guards, simplify predicates, separate decisions from execution, extract coherent policies, consolidate repeated decisions. Introduce tables or polymorphism only for real variation. | Predicate evaluation order, short-circuit side effects, default cases, exceptions, cleanup, and decision completeness. |
| `RESPONSIBILITY_OVERLOAD` | Which state/behavior clusters have independent reasons to change? | Separate orchestration from computation or I/O; move behavior toward its owned data; extract a demonstrated domain concept. | State ownership, transaction boundaries, synchronization, and call order. |
| `POOR_COHESION` | Do disconnected clusters reflect distinct responsibilities or an appropriate stateless utility? | Move misplaced behavior; split along actual ownership or independent change boundaries. | Consumers, shared state, lifecycle, and whether the split adds cross-module coordination. |
| `COUPLING` | Which unnecessary knowledge crosses a boundary? | Narrow dependencies, move orchestration, localize infrastructure knowledge, or create a boundary that reflects existing ownership. | Dependency graph, caller effects, public surface, and integration behavior. An interface that merely renames imports is insufficient. |
| `ARCHITECTURE_VIOLATION` | Which established rule and exact edge/path are violated? | Move misplaced responsibility, correct dependency direction, or introduce a port at an actual boundary. | Rule identity, affected graph, new cyclic edges, public contracts, and integration checks. Local cleanup alone cannot repair a boundary violation. |
| `DUPLICATION` | Is this the same knowledge with the same reason to change? | Consolidate that policy near its owner. Keep coincidentally similar code independent. | Divergent edge cases and consumers; avoid flag-driven helpers that couple unrelated policies. |
| `TESTABILITY` | Which observable behavior lacks meaningful protection, and why? | Add characterization at the existing boundary; separate pure decisions from I/O; introduce a narrow seam around an actual hard dependency. | Assertions that detect behavior changes, representative failures, deterministic setup, and tests that survive internal rearrangement. |
| `ABSTRACTION_OVERHEAD` | What purpose does each wrapper, interface, factory, or inheritance step serve? | Inline redundant delegation or remove unnecessary layers while preserving useful policy and isolation. | Public consumers, extension points, lifecycle, instrumentation, security checks, and test seams hidden in apparently thin wrappers. |
| `SIZE_ONLY` | Is there demonstrable difficulty beyond length? | Leave a cohesive linear procedure intact; improve local naming or grouping where useful. Extract only when an independent concept emerges. | Reader navigation and concept locality; a shorter entrypoint is not sufficient evidence. |

## Decision examples

- **Nested checkout hotspot, weak tests:** protect pricing and side-effect order, then flatten guards. Compare the full checkout path and module coupling. A remaining warning is acceptable when the dominant difficulty is removed.
- **Large stable parser:** defer during broad prioritization when more consequential hotspots exist. If the user selected it, assess its actual decision structure; history does not override scope.
- **Lower complexity, many new types:** reject or revise if the new types only relay calls. Retain abstraction only when it owns meaningful policy, variation, or isolation.
- **Two similar discount functions:** share a rule only if their business reasons to change coincide. Similar syntax across independent product policies is not sufficient.
- **A new cycle replaces an old one:** reject under a no-new-cycle ratchet, even when total cycle count decreases.
