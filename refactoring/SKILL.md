---
name: refactoring
description: Restructure existing code in small steps that preserve observable behavior. Use when asked to refactor or clean up code, or when existing structure makes the current change awkward and a preparatory refactor would make it easy.
---

# Refactoring

Refactoring is behavior-preserving design work in small, reversible steps. Every step leaves the code buildable, tested and reviewable; the next step is chosen only after the last one is green.

## Scope

- **Requested refactor:** the module, file, class, functions or codebase the user selected. If no target can be inferred, ask for it before editing.
- **Preparatory refactor**, reached on your own during other work: only the structure that blocks the current change. Record further cleanup as a follow-up in your report.

Inspect callers and dependencies as needed to preserve contracts, without widening the edit scope. Feature or bug-fix behavior belongs to its own step, made only when the task asked for it.

## Workflow

1. **Pin the contracts.** Read the target, repository instructions, callers, tests and verification commands. List the observable behavior the target touches, using the [contract checklist](refactoring.md#behavior-contracts). Run the baseline checks. Done when every contract is listed and pre-existing failures are recorded.
2. **Build the safety net.** Where a listed contract has no test that would fail if it broke, add a characterization test and watch it go red under a deliberate perturbation. See [Safety net](refactoring.md#safety-net). Done when each contract is covered or recorded as a verification gap.
3. **Diagnose.** Name the structural friction and the smallest move that removes it: [Triage](refactoring.md#triage) and [Smells and moves](refactoring.md#smells-and-moves). For a whole codebase, inventory the major areas and rank them by impact and risk; track completed, deferred and uninspected areas so one improved file is never reported as a refactored codebase.
4. **Transform.** Apply one named move, run the affected checks, repeat. Pick moves from the [catalog](refactoring.md#catalog); for fragile or untested code use [Legacy code](refactoring.md#legacy-code). Commit structural changes apart from behavior changes and test updates.
5. **Stop and report.** Stop at the [stopping point](refactoring.md#stopping-point). Review the diff against the [final checklist](refactoring.md#final-checklist), then report what improved, the checks run with their results, and remaining work or gaps.

When the diff starts to outgrow the behavior being changed, or the next move is a rewrite, return to step 3 and pick the next small move that recovers control. See [Reassess](refactoring.md#reassess).

## Related skills

- The red-green loop's own refactor step belongs to `tdd`; larger restructuring belongs here.
- A move that crosses a module or service boundary, or changes a public API, schema or data layout, is architecture work: use `production-software-architecture`.
- To measure whether complexity actually dropped, the user can invoke `code-quality`.
