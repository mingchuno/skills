Personal SDLC agent skills for Claude Code, Codex and Copilot, installed with the Skills CLI or the Claude plugin manifest.

## Writing a skill

- Load `writing-for-agents`, when available, before editing any `SKILL.md`, skill reference, or this file.
- Write each skill in plain Agent Skills format (`SKILL.md` with `name` and `description`, optional references and assets) so any host and model can run it. Name host-specific tools only as optional alternatives.
- Before writing a skill, check [the inventory](docs/skill-inventory.md#inventory) for an existing port. Then look for an equivalent to port, merge or drop in:
  - https://github.com/addyosmani/agent-skills
  - https://github.com/cursor/plugins/tree/main/pstack
  - https://github.com/obra/superpowers
  - https://github.com/mattpocock/skills
  - https://github.com/luckys/agent-skills

  Record the decision, source and commit in the inventory.

## Invocation

Make a skill model-invoked only when the agent must reach it on its own during other work, or another skill must load it. Make every other skill explicit-only. Ask the user when the case is unclear, and record the choice and its reason in [Invocation policy](docs/skill-inventory.md#invocation-policy).

A model-invoked skill's `description` lists its trigger cases. An explicit-only skill's `description` is a one-line summary for humans, and it needs both settings:

- `SKILL.md` frontmatter: `disable-model-invocation: true` (Claude Code, Copilot).
- `agents/openai.yaml`: `policy.allow_implicit_invocation: false` (Codex).

## Sync list

When adding, renaming, removing, or changing the invocation of a skill, update in the same change:

- `README.md`: the "Choose a skill" table and the explicit-only sentence under "Supported agents".
- `.claude-plugin/plugin.json`: the `skills` array.
- `docs/skill-inventory.md`: the Invocation policy and Overlap tables, and the start-work references table when `start-work` names the skill.
- `start-work-lite/SKILL.md`: the Companion skills table when it names the skill.
- `THIRD_PARTY_NOTICES.md`: when the skill ports upstream material.

## Verify

Run `npx skills add . --list` and confirm it lists every skill in `.claude-plugin/plugin.json`.
