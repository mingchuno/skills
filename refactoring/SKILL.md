---
name: refactoring
disable-model-invocation: true
description: Refactor a selected module, file, class, functions, or whole codebase in small steps that preserve observable behavior. Invoke explicitly to improve structure and changeability.
---

# Refactoring

## Scope and workflow

Apply only when the user explicitly invokes this skill. Work on the module, file, class, functions, or whole codebase they select; inspect callers and dependencies as needed to preserve contracts. If no target can be inferred, ask for it before editing.

1. Inspect the target, repository instructions, callers, tests, and verification commands. Identify observable behavior, side effects, error semantics, and compatibility constraints.
2. Identify concrete structural friction and select the smallest useful transformations. For a whole-codebase request, inventory the major areas, prioritize by impact and risk, and work through coherent slices. Track completed, deferred, and uninspected areas so one improved file is not reported as a completed codebase refactor.
3. Establish a baseline with relevant checks. Add characterization coverage before risky changes when behavior is unclear; record pre-existing failures and verification gaps.
4. Apply one coherent transformation at a time and verify affected behavior after each meaningful step. Continue through the requested scope while improvements remain justified. Implement feature or bug-fix behavior only when separately requested.
5. Review the diff for unintended behavior changes and unrelated churn. Report what improved, checks run and their results, and any remaining work or uncertainty.

## Detailed reference

Read only the relevant sections of [refactoring.md](refactoring.md) when the current transformation needs more detail:

- [Safety Rules](refactoring.md#safety-rules) and [Testing Rules](refactoring.md#testing-rules): weak tests, unclear behavior, or risky changes.
- [Code Smell Policy](refactoring.md#code-smell-policy): diagnosing structural friction and choosing a target.
- [Preferred Refactoring Moves](refactoring.md#preferred-refactoring-moves) and [Refactoring Catalog Index](refactoring.md#refactoring-catalog-index): selecting and sequencing a concrete transformation.
- [Function-Level Rules](refactoring.md#function-level-rules), [Class and Module Rules](refactoring.md#class-and-module-rules), [Data and Mutation Rules](refactoring.md#data-and-mutation-rules), and [Error Handling Rules](refactoring.md#error-handling-rules): changes to those responsibilities or contracts.

The reference applies within the user's requested scope. Its feature-work sequences apply only when a behavior change was requested; a pure refactor preserves behavior throughout.

## Primary bias to correct

Refactoring is behavior-preserving design work in small steps. Do not turn cleanup into a rewrite, a hidden feature change, or speculative architecture.

## Decision rules

- Preserve observable behavior during refactoring. Isolate behavior changes from structural changes and never disguise a feature, migration, or redesign as cleanup.
- Work in small, reversible, buildable, testable, reviewable steps. Split a patch when it is too large to reason about locally.
- Establish or identify a safety net before risky refactoring. Use characterization tests for unclear behavior, keep test updates aligned with intended behavior, and never delete a failing test to finish cleanup.
- Use preparatory and follow-up refactoring around feature work: identify what makes the requested change awkward, reshape that local structure first when useful, make the behavior change, then clean debt introduced by the change.
- Refactor the current blocking smell, not every smell in sight: duplication, long functions, long parameter lists, globals, divergent change, shotgun surgery, feature envy, primitive obsession, repeated conditionals, temporary fields, middle men, or speculative generality.
- Prefer the simplest named move that helps: rename, extract, inline, move, split meanings, introduce a parameter or value object, encapsulate a field or collection, decompose conditionals, use guard clauses, or substitute a clearer algorithm.
- Make names and functions reveal intent. Rename before deeper work when bad names block understanding; keep functions coherent, at one abstraction level, with tight variable scope and separated phases.
- Put behavior and state with the concept that owns them. Split classes or modules with multiple reasons to change; separate business policy from formatting, transport, persistence, I/O, frameworks, and integration details.
- Keep data, mutation, and call contracts explicit. Avoid behavior-switching boolean flags, confusing argument order, parameter reassignment, exposed mutable collections, unnecessary setters, public fields, and duplicated state-transition logic.
- Simplify conditionals honestly. Use guard clauses, extracted predicates, lookup tables, consolidated duplicate fragments, state, strategy, polymorphism, or null objects only when they reduce repeated branching or clarify variation.
- Use abstraction and generalization only when current evidence justifies them. Remove pass-through layers, vague utilities, middle men, unused hierarchy, and just-in-case interfaces that do not improve changeability.
- Preserve error semantics unless intentionally changing behavior. Refactor error handling to reveal the main path and consolidate duplicate validation, cleanup, recovery, or error structures.
- Keep patch intent reviewable. Group related refactorings, separate structural edits from behavior where practical, and avoid giant patches that rename, move, redesign, and change logic together.
- Stop when the requested change is easy, the blocking smell is gone, readability and local changeability are clearly better, and the next cleanup would be speculative.

## Situational rules

- When adding behavior, first ask what structural friction blocks the change; refactor before the feature only when it makes the feature safer or simpler.
- When fixing a bug in unclear code, characterize the current failure and refactor only enough to make the fix visible before changing behavior.
- When tests are absent or weak, make the smallest possible structural move and improve testability before attempting broader cleanup.
- When the same edit appears for a third time, remove duplication through clearer ownership instead of copying again.
- When a function mixes responsibilities, abstraction levels, phases, or hidden side effects, rename, extract, split phases, or isolate side effects before adding more logic.
- When one change forces edits across many files, centralize the knowledge or introduce a clearer boundary.
- When repeated conditionals or type codes grow, decompose intent first; introduce polymorphism, state, strategy, or a table only when the variation is real.
- When UI and domain behavior mix, move rules toward domain objects and verify any required presentation synchronization.
- When a patch mixes intents or code motion makes review hard, split the change unless context makes that impractical.
- When tempted to rewrite, choose the next small behavior-preserving transformation that recovers control.

## Final checklist

- Observable behavior preserved?
- Structural change, behavior change, and test updates separated where practical?
- Safety net, characterization, or verification gap recorded?
- At least one real source of friction removed?
- Names, responsibilities, control flow, data ownership, and interfaces clearer?
- Patch still reviewable and runnable?
- Cleanup stopped before speculative abstraction or rewrite pressure took over?
