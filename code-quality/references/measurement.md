# Measurement and interpretation

Keep health, change risk, and priority separate. A scalar may rank attention; it cannot decide design quality or override the user's selected scope.

## Twelve core signals

| Signal | Evidence and interpretation |
| --- | --- |
| Required checks | Record command, scope, result, and pre-existing failures. A passing test suite supports but does not prove compatibility. |
| Architecture constraints | Compare cycle identities and forbidden edges, plus established boundary rules. Counts alone hide replacement violations. |
| Behavior/API compatibility | Inspect signatures, consumers, observable outputs, error semantics, ordering, side effects, persistence, and protocol contracts relevant to the task. Record authorized changes separately. |
| Cognitive complexity | Prefer an analyzer's named algorithm; use it to locate comprehension difficulty. A manual impression is an observation, not an exact analyzer score. |
| Cyclomatic complexity | Record analyzer conventions for decisions and language constructs. Fewer branches are useful only if the decision logic becomes clearer. |
| Maximum nesting | Record which constructs count and the depth convention. Flattening must preserve evaluation order and cleanup behavior. |
| Function NLOC | Nonblank, noncomment source lines according to the collector. Keep scope and generated-code exclusions stable. Size supports a diagnosis; it does not establish one. |
| Parameter count | Record treatment of receivers, destructuring, variadics, and defaults. Hiding parameters in an unstructured options object is not a responsibility improvement. |
| Fan-out | Count distinct outgoing dependencies at a stated function, class, file, or module boundary. Record runtime/type-only/external dependency treatment. Judge coupling where ownership lives. |
| Cohesion | Use a named LCOM variant only where it fits the programming model. Otherwise describe state/behavior clusters and reasons to change. Do not invent a universal normalized cohesion score. |
| Test confidence | Inspect assertion quality and behavior coverage. Record branch coverage and mutation score separately when available, with their denominators and exclusions. |
| Change frequency with complexity | Record the history window, revision, counting/rename/merge policy, and file/module scope. Use to rank maintenance hotspots; shallow or absent history is unknown. |

Duplication and abstraction overhead are additional qualitative diagnostics, not mandatory scalar metrics. Review delegation chains of three or more hops, inheritance depth of four or more, and single-implementation interfaces for a real purpose; each may be justified at a boundary. Trace actual behavior before recommending removal.

## Soft defaults

These are v1 review heuristics, overridden by repository context. They are neither tool defaults nor universal limits.

| Function signal | Target | Warning | Severe |
| --- | --- | --- | --- |
| Cognitive complexity | ≤ 10 | > 15 | > 25 |
| Cyclomatic complexity | ≤ 10 | > 15 | > 25 |
| NLOC | ≤ 40 | > 60 | > 100 |
| Maximum nesting | ≤ 3 | > 4 | — |
| Parameters | ≤ 4 | > 6 | — |

A parser, generated mapping, or long linear procedure can exceed these values appropriately. Explain exceptions by responsibility and change cost. Prefer a meaningful improvement from 37 to 24 over extra abstraction introduced solely to reach 10.

## Acquisition contract

Use repository-native tools first. A collector must identify its tool/version or manual method, command/configuration, analyzed source state, included scope, exclusions, and raw output. Choose collectors by actual language support; verify their current documentation before configuring or invoking unfamiliar options. Acquisition stays separate from reasoning: v1 ships a report contract, not executable language adapters or a CI gate.

Compare the same entity, metric definition, tool version, configuration, and scope. If any changes, recollect both sides consistently or mark the comparison unavailable. Record renames and one-to-many extraction mappings. Keep caller and module observations alongside function deltas; sums of function complexity can change simply because each extracted function introduces a base path.

When tooling is unavailable, inspect the code and record findings with locations. Label estimated numeric values explicitly and never report them as measured. Use `unavailable` with a reason for missing data and `not_applicable` for a metric that does not fit the entity. Unknown coverage is not zero coverage; missing history is not zero churn.

## Test confidence and priority

Distinguish no relevant tests, behavioral tests with unmeasured coverage, tests with branch coverage, and additional mutation evidence. These are evidence levels, not an automatic score. High coverage with weak assertions still requires attention. Mutation results need context for equivalent, ignored, invalid, or timed-out mutants. Neither metric warrants tests that mirror implementation details.

For ordinary refactors, run relevant existing checks. For frequently changed, complex behavior with weak protection, consider targeted characterization and mutation testing before broad structural changes. A test-only safety step may improve confidence without reducing complexity; state that outcome accurately.

Prioritize by task relevance, maintenance impact, complexity, change frequency, and test risk. A numeric scheduling heuristic is optional: document its formula, normalization population, available inputs, and window. Do not substitute invented values for missing inputs or compare scores across different populations. Zero churn does not cancel an explicit request or a serious correctness problem.

If useful and supported by compatible function-level data, report CRAP as `CC² × (1 − coverage)³ + CC`, with coverage in `[0,1]` and its exact kind identified. Replacing coverage with mutation score creates a custom heuristic, not standard CRAP. Neither is required for v1 acceptance.

Leave Halstead, Maintainability Index, RFC, NOC, package abstractness/distance, comment ratios, and technical-debt minutes outside the v1 core. More metrics require demonstrated diagnostic value.
