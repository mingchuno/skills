---
name: code-quality
description: Assess maintenance hotspots, reduce complexity, or review architecture fitness using quality signals, test confidence, and before/after evidence. Use for scoped code-quality assessment and improvement.
---

# Code quality

Reduce the cost and risk of understanding and changing software. Preserve required behavior and useful boundaries. Treat metrics as diagnostic evidence, never as a single clean-code score.

## Scope

Distinguish assessment, new implementation, modification, refactoring, and architectural restructuring from the request. Assessment produces findings without editing production code. A refactoring request preserves observable behavior; an implementation request permits only its specified behavior changes. Inspect callers and dependencies as needed, without expanding the edit scope.

For a whole-codebase task, inventory the major areas and record inspected, completed, deferred, and uninspected scope. Prioritize maintenance hotspots within that scope; the largest metric alone does not determine priority. If no target can be inferred, ask for it.

For architectural restructuring, include dependency and public-contract differences in the comparison. For new implementation, evaluate the requested behavior, design, and integration effects without inventing a prior implementation. Routine changes need only relevant evidence; a full metric inventory or JSON report is not mandatory.

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
3. **Diagnose.** Examine architecture violations and behavior/test risk before local complexity, then nesting/size, cohesion, coupling, duplication, and abstraction overhead. Classify the dominant problem using [playbook.md](references/playbook.md). Link each finding to code and describe a concrete difficulty it causes. Size alone is insufficient justification for extraction. An assessment ends with prioritized findings and verification gaps.
4. **Protect behavior.** Before risky edits, add focused characterization or regression coverage for relevant contracts, failure paths, state transitions, and side effects. Tests that merely execute code do not establish behavioral confidence. Use mutation testing selectively when its likely value warrants the cost. Record unresolved verification gaps before proceeding with any bounded change.
5. **Make one coherent change.** Select the smallest transformation justified by the diagnosis. State the target signal and relevant regression guards first. Added abstractions need an actual responsibility, variation point, boundary, or shared reason to change. For new code, apply these constraints to the requested design and compare integration effects against the existing repository.
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
