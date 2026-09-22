# Software Engineering Skills

Reusable agent instructions for assessing code quality, refactoring safely, designing production systems, and writing concise documentation. The skills are language-agnostic and can be installed independently.

## Choose a skill

| Skill | When to use it | What to expect |
| --- | --- | --- |
| [Code Quality](code-quality/SKILL.md) (`code-quality`) | You need to identify maintenance hotspots or verify that a change reduces complexity and risk. | Prioritized findings, or focused improvements with before/after evidence and verification gaps. |
| [Refactoring](refactoring/SKILL.md) (`refactoring`) | You have selected code whose structure needs improving while preserving behavior. | Small, reviewable transformations with relevant checks. |
| [Production Software Architecture](production-software-architecture/SKILL.md) (`production-software-architecture`) | You need to design or review boundaries, dependencies, compatibility, migrations, or production readiness. | Recommendations or implementation grounded in system constraints, failure modes, and trade-offs. |
| [Concise Technical Documentation](concise-docs/SKILL.md) (`concise-docs`) | A README, ADR, design document, or developer guide needs clearer, shorter prose. | Focused documentation that preserves commands, constraints, and technical meaning. |

If you are unsure where to start, ask **Code Quality** for an assessment without edits. Choose **Refactoring** when the target is already clear, or **Production Software Architecture** when the problem spans system boundaries.

## Install

You need Node.js/npm with `npx` available. The examples use the [Skills CLI](https://github.com/vercel-labs/skills) and target Codex.

Install one skill for use across your projects:

```bash
npx skills add mingchuno/skills --skill code-quality --agent codex -g
```

Replace `code-quality` with any skill ID from the table. To install every skill in this repository:

```bash
npx skills add mingchuno/skills --skill '*' --agent codex -g
```

For a project-only installation, run the command from that project's root and omit `-g`:

```bash
npx skills add mingchuno/skills --skill code-quality --agent codex
```

For another supported agent, omit `--agent codex` and select your agent interactively. Add `-y` to skip confirmation prompts.

Verify your global Codex installation:

```bash
npx skills ls -g --agent codex
```

Use `npx skills ls --agent codex` to include project installations. When copying skills manually, keep the complete skill folder, including its references, assets, and agent configuration.

## Use a skill

Open the project you want to work on in Codex. Include `$skill-name` in your prompt, followed by the **target**, **desired outcome**, and **constraints**. State whether you want assessment, a plan, or implementation.

**Assess before editing:**

```text
$code-quality Assess src/orders for maintenance hotspots. Prioritize findings and explain the evidence. Do not edit code.
```

**Improve a selected area and compare the result:**

```text
$code-quality Reduce complexity in src/orders/checkout.ts. Preserve behavior and report before/after evidence, checks, and remaining uncertainty.
```

**Refactor without changing behavior:**

```text
$refactoring Separate pricing rules from I/O in src/orders/checkout.ts. Preserve the public API and side-effect order, and run the relevant tests.
```

**Plan a system change:**

```text
$production-software-architecture Review the billing API and plan a backward-compatible migration. Include rollout, rollback, and verification. Do not implement yet.
```

**Improve documentation:**

```text
$concise-docs Edit README.md for first-time users. Make installation and usage easy to find while preserving working commands and important constraints.
```

In Codex, Code Quality, Refactoring, and Production Software Architecture require explicit invocation. Concise Technical Documentation also allows automatic selection for matching tasks. These settings are specific to Codex; other agents may handle invocation differently. See [Codex skill invocation](https://learn.chatgpt.com/docs/build-skills#how-chatgpt-and-codex-use-skills).

## Workflow details

The engineering skills inspect the selected scope, respect repository constraints, and report verification results and unresolved gaps. Whole-codebase requests track completed, deferred, and uninspected areas. Refactoring preserves observable behavior; architecture work introduces patterns only when they solve a demonstrated problem.

Code Quality uses metrics as evidence, with existing repository tools or labeled manual observations. It includes no analyzer, policy runner, or CI gate. Structured reports are optional for ordinary changes; schema validation checks their structure, not the truth of their evidence.

- [Code Quality workflow](code-quality/SKILL.md) and [report format](code-quality/references/reporting.md)
- [Refactoring guide](refactoring/refactoring.md)
- [Architecture workflow and references](production-software-architecture/SKILL.md#reference-map)

## Update an installed skill

To update a global installation, use its skill ID:

```bash
npx skills update code-quality -g
```

Replace `code-quality` with the skill you want to update. Use `-p` instead of `-g` for a project installation.
