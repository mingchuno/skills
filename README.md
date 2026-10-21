# Software Engineering Skills

Reusable agent instructions for assessing code quality, refactoring safely, designing production systems, writing concise documentation, and scaffolding new JS/TS projects. The skills can be installed independently.

## Choose a skill

| Skill | When to use it | What to expect |
| --- | --- | --- |
| [Code Quality](code-quality/SKILL.md) (`code-quality`) | You need to identify maintenance hotspots or verify that a change reduces complexity and risk. | Prioritized findings, or focused improvements with before/after evidence and verification gaps. |
| [Refactoring](refactoring/SKILL.md) (`refactoring`) | You have selected code whose structure needs improving while preserving behavior. | Small, reviewable transformations with relevant checks. |
| [Production Software Architecture](production-software-architecture/SKILL.md) (`production-software-architecture`) | You need to design or review boundaries, dependencies, compatibility, migrations, or production readiness. | Recommendations or implementation grounded in system constraints, failure modes, and trade-offs. |
| [Concise Technical Documentation](concise-docs/SKILL.md) (`concise-docs`) | A README, ADR, design document, or developer guide needs clearer, shorter prose. | Focused documentation that preserves commands, constraints, and technical meaning. |
| [JS/TS Project Scaffolding](js-ts-project-scaffolding/SKILL.md) (`js-ts-project-scaffolding`) | You are creating a new JavaScript or TypeScript Node.js or web project. | A minimal, requirements-led stack with preferred tooling and conditional libraries. |

If you are unsure where to start, ask **Code Quality** for an assessment without edits. Choose **Refactoring** when the target is already clear, or **Production Software Architecture** when the problem spans system boundaries.

## Supported agents

Every skill is a standard [Agent Skills](https://agentskills.io) folder: a `SKILL.md` with `name` and `description`, plus optional references and assets. Any agent that reads that format can use it without extra setup.

| Agent | Skills CLI `--agent` | Invoke explicitly | Disables automatic selection via |
| --- | --- | --- | --- |
| Codex (OpenAI) | `codex` | `$skill-name` | `agents/openai.yaml` → `policy.allow_implicit_invocation: false` |
| Claude Code | `claude-code` | `/skill-name` | `SKILL.md` → `disable-model-invocation: true` |
| GitHub Copilot (VS Code) | `github-copilot` | `/skill-name` | `SKILL.md` → `disable-model-invocation: true` |
| Other agents | see [agent list](https://github.com/vercel-labs/skills/blob/main/docs/agents.md) | agent-specific | Usually none; the skill may be selected automatically |

Code Quality, Refactoring, and Production Software Architecture are explicit-only in Codex, Claude Code, and Copilot. Concise Technical Documentation and JS/TS Project Scaffolding can be selected automatically for matching tasks.

When adding a skill, keep the two settings in sync: an explicit-only skill needs both `disable-model-invocation: true` and `agents/openai.yaml`. Other agents ignore both.

See [Codex skills](https://learn.chatgpt.com/docs/build-skills), [Claude Code skills](https://code.claude.com/docs/en/skills), and [Copilot agent skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills).

## Install

You need Node.js/npm with `npx` available. The examples use the [Skills CLI](https://github.com/vercel-labs/skills). Replace `<agent>` with an ID from the table, such as `codex`, `claude-code`, or `github-copilot`.

Install one skill for use across your projects:

```bash
npx skills add mingchuno/skills --skill code-quality --agent <agent> -g
```

Replace `code-quality` with any skill ID from the table. To install every skill in this repository:

```bash
npx skills add mingchuno/skills --skill '*' --agent <agent> -g
```

For a project-only installation, run the command from that project's root and omit `-g`:

```bash
npx skills add mingchuno/skills --skill code-quality --agent <agent>
```

Omit `--agent` to choose one or more agents interactively. Add `-y` to skip confirmation prompts.

Verify your global installation:

```bash
npx skills ls -g --agent <agent>
```

Omit `-g` to include project installations. When copying skills manually, keep the complete skill folder, including its references, assets, and `agents/` configuration.

## Use a skill

Open the project you want to work on in your agent. Invoke the skill by name (`$skill-name` in Codex, `/skill-name` in Claude Code and Copilot), followed by the **target**, **desired outcome**, and **constraints**. State whether you want assessment, a plan, or implementation. The examples use Codex syntax.

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
