# Skill inventory

This repository is the engineering-technique library used next to
[agent-workflows](https://github.com/mingchuno/agent-workflows). It ports the
useful parts of popular open-source skill sets so users install one library
instead of several upstream repositories.

## Boundary

| agent-workflows | this repository |
| --- | --- |
| When to do what: tracks, approvals, routing, runner. | How to do an engineering task well. |
| Required for delegated work. | Optional: `start-work` says "use X if installed" and works without it. |
| Workflow contracts (WorkContract, review JSON). | Techniques that can produce those contracts. |

One exception: `start-work-lite` routes, gates and publishes inside a single
session. It is independent of agent-workflows and does not require it; install
one or the other. It has no enforcement: approval is the human's word in chat
or on the issue. agent-workflows is the durable, enforced version of the same
tracks. Every other skill here contains no routing, approval, or publication
logic.

`start-work-lite` loads companion skills by name when the host allows it, and
otherwise reads `../<skill>/SKILL.md` beside its folder. That is how it reaches
the explicit-only `clarify` and `code-quality`, which no other skill can
invoke. Each companion has a one-line fallback, so the skill works alone.

## Sources

Read on 2026-10-21. All are MIT-licensed; notices are in
[THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md).

| Short name | Repository | Commit |
| --- | --- | --- |
| superpowers | obra/superpowers | `b739a8a` |
| mattpocock | mattpocock/skills | `5beb35b` |
| pstack | Aqua-123/pstack-for-codex (port of cursor/plugins pstack 0.15.24) | `d5b20bc` |
| spec-kit | github/spec-kit | reference only |

`AGENTS.md` also lists addyosmani/agent-skills and luckys/agent-skills as
references. Nothing has been ported from them yet; add a row here when a skill
is compared against them.

## Inventory

| Source skill | Decision | Destination | Reason |
| --- | --- | --- | --- |
| mattpocock `diagnosing-bugs` | Merge | `debugging` | Feedback-loop-first phases, minimisation, ranked falsifiable hypotheses, tagged instrumentation, HITL script. |
| superpowers `systematic-debugging` | Merge | `debugging` | Root cause before fix, check recent changes, compare with working code, stop after three failed fixes. Techniques condensed into `references/techniques.md`. Pressure tests and creation log dropped as authoring artifacts. |
| superpowers `find-polluter.sh`, `condition-based-waiting-example.ts` | Drop | — | Described as techniques; the scripts are project-specific. |
| mattpocock `tdd` | Merge | `tdd` | Seams agreed up front, vertical slices, behavior through public interfaces, mocking at boundaries. |
| superpowers `test-driven-development` | Merge | `tdd` | Watch it fail, minimal green, full suite before done, mutation check, no change detectors. The "delete means delete" rule is softened to "set aside". |
| pstack `tdd` | Merge | `tdd` | Prefer no test over a bad test; report failing-before and passing-after evidence. |
| mattpocock `code-review` | Merge | `code-review` | Spec and Standards lenses with Fowler smell baseline, kept as separate lenses. Tracker setup dependency dropped. |
| superpowers `requesting-code-review` | Merge | `code-review` | Fresh-context, read-only reviewer with no history; correctness lens; reasonable-user expectation where the spec is silent. Critical/Important/Minor replaced by P0–P3. |
| superpowers `receiving-code-review` | Merge | `code-review/references/receiving.md` | Verify before implementing, clarify all items first, evidence-based pushback. |
| pstack `interrogate` | Merge (partial) | `code-review` | Lead-judgment filtering and a visible dropped list. Multi-model panel dropped: it needs host-specific model profiles. Despite the issue grouping, it is a review skill, not a clarification skill. |
| mattpocock `grilling` | Merge | `clarify` | Decision-tree rounds with recommended answers; facts looked up, decisions asked. |
| mattpocock `grill-me`, `grill-with-docs` | Drop | `clarify` | Aliases. `clarify` offers `domain-docs` at the end instead of composing two skills. |
| mattpocock `domain-modeling` | Port | `domain-docs` | Renamed `GLOSSARY.md` to `CONTEXT.md` (and `CONTEXT-MAP.md`) to match agent-workflows; existing `GLOSSARY.md` repositories are respected. |
| mattpocock `pr` | Fold | `concise-docs/references/pull-requests.md` | A PR body is documentation; a separate skill would add a listing for one template. Adds limitations and commit-message guidance. |
| superpowers `verification-before-completion` | Rule | README "Recommended project rule" | One rule, not a workflow: evidence before completion claims. Also built into each skill's report step. |
| pstack `setup-pstack` | Pattern | [Setup receipts](#setup-receipts) | No setup skill exists here yet. |
| spec-kit `workflows/bugfix`, `workflows/assess` | Reference | — | Gate shapes already owned by agent-workflows tracks. Nothing to port. |

## Overlap with existing skills

| Existing skill | Overlap | Resolution |
| --- | --- | --- |
| `code-quality` | Code review also judges maintainability; refactoring applies the moves it recommends. | `code-quality` is the auditor: hotspots, diagnosis, before/after evidence, acceptance. It hands edits to `refactoring` and architecture-rule design to `production-software-architecture`. `code-review` judges one diff against its spec. |
| `refactoring` | TDD's refactor step; review's smell baseline; architecture's legacy-code techniques. | `refactoring` owns every behavior-preserving move, including seams, sprout and wrap, and branch by abstraction (moved from `production-software-architecture` on 2026-10-22). `tdd` refactors only while green and small. Review reports smells; it does not apply them. |
| `production-software-architecture` | Debugging's "question the architecture after three failed fixes"; ADRs; refactoring across boundaries. | System level only: boundaries, contracts, failure, migration, operability, guardrails. Its Refactor mode loads `refactoring`. Debugging stops and discusses; `domain-docs` owns ADR format. |
| `concise-docs` | ADR and PR prose. | `concise-docs` owns prose style and PR descriptions; `domain-docs` owns ADR content rules. |
| `js-ts-project-scaffolding` | None. | — |

## Invocation policy

A skill allows automatic selection only when the agent must reach it on its
own during other work, or another skill must load it: in Claude Code and
Copilot, `disable-model-invocation: true` stops other skills from loading it
too. Every other skill is explicit-only and costs no always-loaded context.
Model-invoked descriptions stay narrow to keep that cost small.

| Skill | Automatic selection | Reason |
| --- | --- | --- |
| `debugging` | Yes | The agent hits failures during other work; `start-work` investigation loads it. |
| `tdd` | Yes | The fast path's regression-test step loads it. |
| `code-review` | Yes | Self-review and the fast path's review step load it. |
| `domain-docs` | Yes | Triggered by editing `CONTEXT.md` or an ADR; knowledge capture loads it. |
| `concise-docs` | Yes | The agent writes commit messages and change request descriptions unprompted; `start-work-lite` loads it. |
| `js-ts-project-scaffolding` | Yes | Users ask for a new project without naming the skill. |
| `refactoring` | Yes | The agent meets structure that blocks the current change; `start-work-lite` delivery loads it. Its scope rule limits unrequested cleanup to the blocking structure. |
| `production-software-architecture` | Yes | Boundary, contract, schema and migration changes are the riskiest the agent makes unprompted; `start-work-lite` design loads it. |
| `clarify` | No | An interview is the user's choice. `start-work` suggests it rather than loading it. |
| `code-quality` | No | A full audit is a deliberate, costly request. Self-review covers complexity through `code-review`'s smell baseline. |
| `start-work-lite` | No | An entry point with outward effects (issue comments, change requests); its own grooming covers clarification. |

## start-work references

Keep this table in sync with agent-workflows `skills/start-work/`. As of
`redesign-sdlc` commit `551b7db`, `start-work` names none of these skills; the
rows are the proposed references. Update the "Status" column when they land.

| start-work file | Step | Optional skill | Status |
| --- | --- | --- | --- |
| `references/investigate.md` | Defect needs a root cause | `debugging` | Proposed |
| `references/investigate.md` | Requirements unclear; suggest an interview to the human | `clarify` | Proposed |
| `references/fast-path.md` | Step 2: regression test that fails before the fix | `tdd` | Proposed |
| `references/fast-path.md` | Step 5: fresh-context review of the diff | `code-review` | Proposed |
| `references/fast-path.md` | Step 6: change request description | `concise-docs` | Proposed |
| `references/capture-knowledge.md` | Domain documentation or ADR proposal | `domain-docs` | Proposed |

Renaming a skill or changing its invocation policy here requires updating this
table and `start-work` together.

## Setup receipts

Pattern from pstack `setup-pstack`, for any future setup skill that writes user
configuration:

- On install, record each written file's scope, relative path, SHA-256, and
  template source in a receipt file owned by the skill.
- Update or remove a file only while its current hash matches the receipt.
- A modified, missing, or moved file needs human review; leave both the file
  and the receipt untouched.

## Host checks

Checked on 2026-10-21 by installing the five new skills into an empty project
with `npx skills add <path> --agent claude-code --agent codex --agent
github-copilot` and asking each headless agent which skills it sees.
`npx skills add . --list` discovers all ten skills. Not rechecked after
`refactoring` and `production-software-architecture` became model-invoked on
2026-10-22.

| Host | Model sees | `clarify` hidden from model | Explicit `clarify` loads |
| --- | --- | --- | --- |
| Codex (`codex exec`) | debugging, tdd, code-review, domain-docs | Yes | Yes, with `$clarify` |
| Claude Code (`claude -p`) | debugging, tdd, code-review, domain-docs | Yes | Yes, with `/clarify` |
| Copilot (VS Code) | Not checked: no headless chat | — | — |

A user-level skill with the same name (for example an upstream `tdd` or
`code-review` already installed) can shadow or duplicate these. Uninstall the
upstream copy when switching to this library.
