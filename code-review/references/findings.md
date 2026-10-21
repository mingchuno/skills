# Review findings

## Priorities

| Priority | Meaning |
| --- | --- |
| P0 | Must not ship: data loss, security exposure, broken build or core path, irreversible damage. |
| P1 | Fix before merge: a bug users will hit, a missing acceptance criterion, a broken contract. |
| P2 | Should fix: edge-case bug, missing test for changed behavior, documented-standard violation. |
| P3 | Optional: a judgement-call smell, naming, minor clarity. |

Grade by effect on users and maintainers, not by how the finding was found. If
everything is P0, nothing is.

## Finding shape

Each finding states:

- `priority`: P0–P3.
- `path` and `line`: an added or changed line in the diff, or `null` when no
  valid location exists.
- `body`: the lens, what is wrong, a concrete failure scenario (inputs or
  state, then the wrong output or crash), and the fix when it is not obvious.

```text
P1 src/orders/refund.ts:42 [correctness]
A refund for a partially shipped order uses the full order total.
Order 100 with 2 of 3 items shipped -> refund(100) returns 90.00, expected 30.00.
Use the unshipped line items' total.
```

The structured form matches the agent-workflows review contract:

```json
{
  "complete": true,
  "limitations": [],
  "summary": "One paragraph: what the change does and whether it is ready.",
  "findings": [
    { "priority": "P1", "path": "src/orders/refund.ts", "line": 42, "body": "..." }
  ]
}
```

`complete: false` requires at least one limitation, such as files you could not
read or checks you could not run.

## Human-readable report

1. Summary and verdict: ready, ready with fixes, or not ready.
2. Limitations.
3. Findings under `### Correctness`, `### Spec`, and `### Standards`, highest
   priority first within each.
4. Dropped candidates, one line each with the reason, so the reader can
   overrule you.

## Smell baseline

Judgement calls from Fowler's _Refactoring_, ch. 3. A documented repository
standard always overrides them.

| Smell | Signal | Usual fix |
| --- | --- | --- |
| Mysterious Name | A name does not reveal what it does or holds. | Rename; if no honest name fits, the design is unclear. |
| Duplicated Code | The same logic shape appears in several hunks. | Extract the shared shape. |
| Feature Envy | A function uses another object's data more than its own. | Move it to that data. |
| Data Clumps | The same fields or parameters travel together. | Introduce a type. |
| Primitive Obsession | A string or number stands for a domain concept. | Give the concept a small type. |
| Repeated Switches | The same conditional on the same type recurs. | Polymorphism or one shared map. |
| Shotgun Surgery | One logical change forces edits across many files. | Gather what changes together. |
| Divergent Change | One module changes for unrelated reasons. | Split by reason to change. |
| Speculative Generality | Parameters, hooks, or abstractions the spec does not need. | Inline until a real need appears. |
| Message Chains | Callers navigate `a.b().c().d()`. | Hide the walk behind one method. |
| Middle Man | A unit mostly delegates. | Call the real target. |
| Refused Bequest | A subtype ignores most of what it inherits. | Use composition. |
