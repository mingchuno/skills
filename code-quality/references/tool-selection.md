# Selecting evidence tools

Choose a collector only when its output can change the diagnosis or acceptance decision. Inspect existing scripts, analyzer configuration, lockfiles, and CI checks first. Reuse their versions, exclusions, and repository-specific rules. Tool setup and persistent CI changes are separate from an assessment unless included in the requested scope.

## Match the tool to the question

| Question | Evidence to seek | Limit to state |
| --- | --- | --- |
| Which control flow is difficult? | An existing language analyzer's cognitive/cyclomatic complexity, nesting, and function-size output | Language constructs and counting conventions vary; compare both states with the same setup. |
| Which dependencies violate boundaries? | Resolved import or build graph plus executable repository rules | Textual imports alone can miss aliases, indirect paths, generated edges, and runtime dependencies. |
| Which behavior is protected? | Relevant assertions, failure-path tests, branch coverage, and targeted mutation results when useful | Execution coverage is not assertion quality; line coverage is not interchangeable with branch coverage. |
| Which areas change frequently? | Repository history for a stated window and revision | Bulk formatting, generated changes, renames, merge policy, and shallow history can distort ranking. |
| Where is responsibility fragmented? | State/call relationships, consumer contracts, delegation paths, and source inspection | Class cohesion formulas do not apply uniformly to functional or stateless modules. |

If no configured tool answers the question, use bounded manual evidence or a proportionate collector supported by the language and repository. Verify current official documentation before selecting unfamiliar options. A cross-language collector may cover control flow and size while providing no meaningful architecture or cognitive-complexity analysis; report only capabilities actually used.

## Collector contract

Keep acquisition separate from acceptance. Normalize collector output into the [report contract](reporting.md), retaining tool/version or manual method, configuration, source state, scope, exclusions, raw evidence, and unavailable-value reasons. Record fan-in or affected consumers as blast-radius observations, not automatic quality defects. Represent unsupported optional metrics as observations rather than silently extending the schema.

When a collector or configuration changes, recollect both states or mark that comparison unavailable. A tool that emits only violation counts cannot establish the identity-based [architecture ratchet](policy.md); supplement it with exact edges or leave that criterion unknown.
