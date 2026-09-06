# Production Software Architecture Skill

A language-agnostic agent skill for designing, reviewing, evolving, and refactoring production software for long-term maintainability.

The skill emphasizes:

- understanding existing behavior before changing structure;
- simple, cohesive boundaries and low conceptual overhead;
- safe incremental refactoring instead of broad rewrites;
- production concerns such as failures, compatibility, migrations, and observability;
- executable architecture and dependency guardrails;
- evidence-based cleanup of AI-generated or spaghetti code.

It is deliberately architecture-style neutral. Clean Architecture, DDD, CQRS, microservices, repositories, and other patterns are used only when they solve a demonstrated problem.

## Install

Install the skill globally with the [Skills CLI](https://skills.sh/):

```bash
npx skills add mingchuno/skills -g --skill production-software-architecture -y
```

To install it only for the current project, omit `-g`:

```bash
npx skills add mingchuno/skills --skill production-software-architecture -y
```

Verify the global installation:

```bash
npx skills ls -g
```

Update it later with:

```bash
npx skills update production-software-architecture -g
```

## When to use it

The skill should activate for architecture decisions and reviews, legacy-code changes, module-boundary design, API or data evolution, production hardening, and structural problems such as:

- long, multi-responsibility functions or UI components;
- duplicated business rules or competing implementations;
- unclear ownership and mixed responsibilities;
- circular or uncontrolled dependencies;
- excessive forwarding layers and speculative abstractions;
- risky refactors in poorly tested systems.

Example prompts:

```text
Review this subsystem and propose the smallest safe architecture improvement.

Refactor this long component without changing its observable behavior.

Find duplicated business rules and determine which copies should share one owner.

Untangle this AI-generated codebase incrementally and add guardrails to prevent regression.
```

## How it approaches refactoring

For existing code, the skill follows an incremental loop:

1. Trace representative behavior and identify contracts.
2. Build an evidence-based inventory of structural problems.
3. Protect behavior with characterization or contract tests.
4. Choose one high-value behavior slice.
5. Make the smallest coherent structural improvement.
6. Verify after each meaningful move.
7. Encode stable architecture rules as automated checks where practical.

See [`production-software-architecture/SKILL.md`](production-software-architecture/SKILL.md) for the complete workflow.

## Relationship to clean-code and refactoring skills

This skill complements narrower implementation skills:

- **Clean Code** guides naming, function structure, readability, and local implementation quality.
- **Refactoring Best Practices** provides tactical behavior-preserving refactoring techniques.
- **Production Software Architecture** determines what to improve, where responsibilities and boundaries belong, which risks matter, and which rules should become lasting guardrails.

They can be used together: this skill supplies system-level direction while the narrower skills guide individual code changes.

## Repository structure

```text
production-software-architecture/
├── SKILL.md
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
```
