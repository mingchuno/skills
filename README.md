# Software Engineering Skills

Language-agnostic skills for improving existing code, maintaining production software, and writing technical documentation. All skills are manually invoked in Codex.

| Skill | Purpose |
| --- | --- |
| [Refactoring](refactoring/SKILL.md) | Refactor a selected module, file, class, functions, or whole codebase through small changes that preserve observable behavior. |
| [Production Software Architecture](production-software-architecture/SKILL.md) | Design, review, and evolve system boundaries, compatibility, operability, and architecture guardrails. |
| [Concise Technical Documentation](concise-docs/SKILL.md) | Write and edit concise technical documentation for experienced engineers. |

## Install

Install a skill globally with the [Skills CLI](https://skills.sh/):

```bash
npx skills add mingchuno/skills -g --skill refactoring -y
npx skills add mingchuno/skills -g --skill production-software-architecture -y
npx skills add mingchuno/skills -g --skill concise-docs -y
```

To install only for the current project, omit `-g`. Verify the global installation with:

```bash
npx skills ls -g
```

## Manual invocation

Explicitly select the skill and describe the target and desired improvement:

```text
$refactoring Refactor src/orders/checkout.ts without changing its observable behavior.

$refactoring Simplify the Invoice class and its calculateTotal and applyDiscount functions.

$refactoring Refactor the billing module to clarify ownership and remove duplicated rules.

$refactoring Refactor this whole codebase incrementally, prioritizing the most consequential structural problems and tracking coverage.

$production-software-architecture Review this subsystem and improve its module boundaries.

$production-software-architecture Plan a backward-compatible API migration with verification and rollback.

$concise-docs Edit this README for clarity while preserving its commands and repository details.
```

Both skill folders contain `agents/openai.yaml` with:

```yaml
policy:
  allow_implicit_invocation: false
```

This is Codex's invocation-policy setting, stored separately from `SKILL.md` frontmatter. It prevents implicit selection while preserving explicit `$skill-name` invocation. See the [official skill documentation](https://learn.chatgpt.com/docs/build-skills#optional-metadata). Other agents may use different invocation controls; this policy is specific to Codex.

Keep the complete skill folder when installing or copying it so any policy and reference files accompany `SKILL.md`. Existing installed copies need updating to receive changes.

## Refactoring workflow

The refactoring entrypoint was converted from `refactoring/refactoring.mini.md`. It retains the core decision rules and links to the detailed [refactoring guide](refactoring/refactoring.md), whose relevant sections are read only when needed.

The workflow is:

1. Inspect the selected scope, callers, contracts, and existing checks.
2. Identify concrete structural friction and choose small, useful transformations.
3. Establish a verification baseline and protect unclear behavior before risky edits.
4. Refactor in coherent steps and verify after each meaningful change.
5. Report improvements, verification results, remaining work, and uncertainty.

For a whole-codebase request, inventory and prioritize the major areas, then work through them incrementally. Track completed, deferred, and uninspected areas. Preserve behavior and stop where further changes would be speculative.

## Choosing between the skills

Use **Refactoring** to carry out structural improvements within a requested scope. Use **Production Software Architecture** when the central question concerns responsibilities, system boundaries, production risks, or lasting architecture constraints. Explicitly invoke both when the task needs both perspectives.

Production Software Architecture remains neutral about architecture styles. Clean Architecture, DDD, CQRS, microservices, repositories, and other patterns are appropriate when they solve a demonstrated problem. Its detailed references cover system understanding, modularity, safe changes, testing, failure and data evolution, operability, architecture decisions, governance, and reviews.

## Repository structure

```text
refactoring/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── refactoring.md
production-software-architecture/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    ├── architecture-decisions.md
    ├── boundaries-and-modularity.md
    ├── failure-data-and-evolution.md
    ├── fitness-functions-and-governance.md
    ├── operability-and-production-readiness.md
    ├── review-checklists.md
    ├── safe-change-and-refactoring.md
    ├── system-understanding.md
    └── testing-and-verification.md
concise-docs/
└── SKILL.md
```
