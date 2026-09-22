# Quality report contract

Use a concise prose comparison for ordinary changes. For substantial work or requested automation, produce `quality-report.json` using [quality-report.schema.json](../assets/quality-report.schema.json). The [example report](../assets/quality-report.example.json) is synthetic and demonstrates a refactor with incomplete evidence; its values are not measured repository results.

The schema validates structure, types, known signal names, and basic decision completeness. It does **not** execute checks, verify evidence, compare source states, or prove that a quality decision is sound. The workflow's acceptance rules remain mandatory.

## Report contents

- `version`, `mode`, `scope`, and `policy`: identify the contract, task, coverage of the requested scope, and applied policy. Track uninspected and deferred areas explicitly.
- `before` and `after`: snapshots containing source-state identity, entities, checks, and architecture evidence. Use `after: null` for an assessment. For a new standalone implementation with no prior source, `before` may be null; changes integrated into an existing repository still need its baseline.
- `entities`: stable logical IDs, repository-relative paths, kind, and optional symbol. `predecessors` maps renamed/extracted entities to before IDs. Match by identity and source inspection, not line number alone.
- `signals`: metric-name map. Each signal identifies status, value, unit, method, and evidence. Missing signal keys mean **not collected**, never zero or passing. Report unavailable target/guard measurements explicitly, with a reason. An unavailable numeric cohesion metric may coexist with a qualitative cohesion observation.
- `checks`: separate required tests, architecture, and compatibility checks from optional checks. Each check records its scope, command or review method, status, and evidence. Populate applicable required checks before editing; omitting a check does not waive the requirement.
- `architecture`: collector method, graph scope, completeness, evidence, and violation records. `complete` means complete within that stated scope, not the entire repository. Empty violations with `partial` or `unavailable` status cannot establish a clean graph. Cycle records retain directed edges for identity comparisons.
- `findings`: diagnosis, location, evidence, impact, and proposed action; optional priority labels are scheduling judgments.
- `comparison`: each targeted improvement and regression guard, before/after entity mappings, result, and rationale. State method changes or missing evidence as `unknown`. Record new-code targets with result `new`; do not invent a numeric delta from zero.
- `decision`: outcome, rationale, unresolved gaps, and six acceptance criteria. Use `pass`, `fail`, `unknown`, or justified `not_applicable` for each criterion. Report qualitative evidence explicitly.

Use evidence strings for commands with outcomes, precise code locations and observations, or persistent artifact paths. Reference artifacts that actually exist. Do not copy credentials, full environment dumps, or irrelevant logs into the report.

## Decision procedure

1. Confirm the report covers the requested scope and uses comparable evidence. A partially completed scope cannot support a whole-scope acceptance claim.
2. Verify required checks and compatibility evidence. A blocked, failed, or unrun required check prevents acceptance. Reject demonstrated failures introduced by the change; use inconclusive for missing verification or unresolved baseline failures that prevent a decision. Preserve pre-existing failures and their relevance.
3. Compare architecture violation identities and directed edges, applying the recorded baseline. A count improvement cannot offset a new violation.
4. Evaluate the targeted improvement, surrounding quality guards, and purposes of added abstractions. For new implementation, assess its targets and integration effects; justify why a before/after improvement criterion is not applicable if necessary.
5. Set `accepted` only when every applicable criterion passes with evidence. Set `rejected` for a demonstrated violation/regression or absence of a meaningful improvement in a completed refactor. Set `inconclusive` when missing evidence prevents a decision. Use `assessment` when no change was requested or made.

The six criteria are `required_checks`, `behavior_compatibility`, `architecture_ratchet`, `targeted_improvement`, `regression_guards`, and `abstraction_justification`. Mark `not_applicable` only with a concrete rationale (for example, no abstraction was added). It is not a replacement for unknown evidence.

Before accepting, independently inspect the diff: a valid JSON document with self-reported `pass` values is not sufficient. Revise a rejected transformation or undo only its agent-owned changes. Keep an inconclusive result visible instead of silently advancing the baseline.
