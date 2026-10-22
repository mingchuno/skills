---
name: code-quality
disable-model-invocation: true
description: Find maintenance hotspots and judge, with quality signals and before/after evidence, whether a change actually reduced complexity and risk.
---

# Code quality

The auditor: measure where understanding and changing the code is costly, diagnose why, and decide whether a change paid off. Metrics are diagnostic evidence, never a single clean-code score. Edits themselves are made with the `refactoring` skill; designing boundaries or architecture rules belongs to `production-software-architecture`.

## Scope

Classify the request:

- **Assessment:** prioritized findings, no edits to production code.
- **Improvement:** a diagnosed hotspot reduced through behavior-preserving changes, with before/after evidence.
- **Judgment:** an existing or new change (refactor, modification, new implementation, architectural restructuring) evaluated against the acceptance rules.

Inspect callers and dependencies as needed, without expanding the edit scope. If no target can be inferred, ask for it. For a whole-codebase task, inventory the major areas and record inspected, completed, deferred, and uninspected scope; prioritize hotspots within it, since the largest metric alone does not set priority.

For architectural restructuring, include dependency and public-contract differences in the comparison. For new implementation, evaluate the requested behavior, design, and integration effects without inventing a prior implementation. Routine changes need only relevant evidence; a full metric inventory or JSON report is optional.

## Quality model

| Role | Signals | Decision |
| --- | --- | --- |
| Hard constraints | Required checks, behavior/API compatibility, dependency cycles and forbidden dependencies | Can this change be accepted? |
| Optimization | Cognitive complexity, cyclomatic complexity, nesting, function NLOC | Did the targeted difficulty improve? |
| Diagnosis | Parameters, fan-out, cohesion; duplication and abstraction overhead observations | What causes the difficulty? |
| Risk | Behavioral assertions, branch coverage, optional mutation results | What protection does a change need? |
| Priority | Change frequency together with complexity and test confidence | Where is improvement valuable now? |

## Workflow

1. **Establish constraints.** Read repository instructions, the selected code, callers, tests, and architecture rules. Record the starting revision and working-tree state, allowed behavior changes, verification commands, and existing failures. For ratchet and policy semantics, read [policy.md](references/policy.md). Infer candidate boundaries from code only as hypotheses; distinguish them from documented or executable requirements.
2. **Acquire evidence.** Read [measurement.md](references/measurement.md). Use existing analyzers and checks where available; retain their versions, configuration, scope, and raw evidence locations. Read [tool-selection.md](references/tool-selection.md) when existing evidence is insufficient or collectors need choosing. Missing measurements remain unknown, never zero. Use explicit qualitative observations when tooling is unavailable. Do not install a quality platform or modify CI merely to assess a scope.
3. **Diagnose.** Examine architecture violations and behavior/test risk before local complexity, then nesting/size, cohesion, coupling, duplication, and abstraction overhead. Classify the dominant problem using [playbook.md](references/playbook.md). Link each finding to code and describe a concrete difficulty it causes; size alone never justifies extraction. An assessment ends here, with prioritized findings and verification gaps.
4. **Set the target.** For an improvement, state the dominant diagnosis, the target signal, and the regression guards before editing. Where test confidence is weak, name the contracts that need characterization; use mutation testing selectively when its likely value warrants the cost.
5. **Change through `refactoring`.** Load the `refactoring` skill and apply its workflow to the diagnosed target, with step 4's guards as its regression checks. Added abstractions need an actual responsibility, variation point, boundary, or shared reason to change. Without the skill, make one small behavior-preserving transformation at a time and run the affected checks after each.
6. **Verify and compare.** Run affected checks, inspect behavior and dependency changes, and repeat relevant measurements with comparable methods. Include extracted helpers, callers, and the enclosing module so moving complexity cannot masquerade as removing it. Read [reporting.md](references/reporting.md) for the comparison contract and machine-readable report assets.
7. **Decide and stop.** Apply the acceptance rules below. Revise a rejected transformation or undo only agent-owned changes from that transformation, preserving other work. Continue across the requested scope while justified problems remain. Stop when the dominant difficulty is resolved and constraints hold; crossing every soft threshold is not a completion condition.

## Acceptance

Accept a non-trivial improvement only when all of these hold:

- Required checks pass and evidence supports preserved behavior, except for explicitly requested changes.
- No new architecture violation is introduced; existing violations obey the applicable baseline policy.
- At least one targeted quality signal improves meaningfully, or an established architecture violation is removed, with comparable evidence. A qualitative improvement is valid when tied to a concrete reduction in maintenance difficulty and labeled as such.
- No unrelated quality dimension materially regresses. Explain small trade-offs in context; a lower local score cannot compensate for a new cycle, broken contract, or unjustified indirection.
- Every added abstraction has a demonstrated purpose.

For new implementation, evaluate its requested behavior and soft targets; integration quality must obey the ratchet. A demonstrated contract violation, introduced check failure, or material regression is **rejected**. Missing or blocked required verification, including unresolved baseline failures that prevent verification, makes the result **inconclusive**. Missing optional metrics alone need not block acceptance when sufficient relevant evidence exists. Baseline failures remain visible and never become passing checks through reclassification.

Report the outcome, scope covered, dominant diagnosis, before/after evidence, checks and results, trade-offs, remaining work, and uncertainty. Keep routine results concise; use the structured report for substantial or explicitly machine-consumable work.
