# Architecture policy and ratchets

Use executable repository rules and documented contracts as authority. Derive candidate ownership boundaries from callers, dependencies, and state, but label inference. A generic layered architecture example does not authorize imposing those layers on a repository.

The optional [architecture-policy.yaml](../assets/architecture-policy.yaml) is an agent-readable template. Its fields describe policy; v1 includes no runner that enforces them. Copy and tailor it only when a durable policy is requested or needed for the authorized task. Record the selected policy file or inline policy summary in the report.

## Baseline

Capture the actual pre-change source state, including existing working-tree changes. Record a revision plus a patch/artifact identity where a commit alone is insufficient. Reproduce relevant checks and measurements in that state. Distinguish confirmed baseline violations, failed collection, and uninspected scope.

Store violation identities using rule ID, source, target, and graph scope. For cycles, retain members and directed edges, or equivalent canonical graph evidence. Compare new edges as well as cycle membership: an existing strongly connected component must not hide a newly introduced cyclic edge. A cycle removed in one area does not pay for a new cycle elsewhere.

## Ratchet

| Change class | Rule |
| --- | --- |
| New code | Aim for soft targets; justify exceptions through actual behavior, responsibility, and boundaries. Enforce repository hard limits where present. |
| Modified code | Preserve required contracts and architecture rules; avoid material regression in relevant signals. Improve severe problems when within scope and justified. |
| Untouched legacy | Retain baseline debt without requiring cleanup. Report relevant risks; do not expand edits merely to reach thresholds. |

New cycles, forbidden edges, and established boundary violations are prohibited unless the user has explicitly authorized the corresponding architecture-policy change. Preserve the old policy and explain such a change separately; editing a rule to hide a violation is not a fix.

Match baseline debt by identity, not total count. Use the same graph scope, resolution rules, and treatment of dependencies on both sides. A missing analyzer, unresolved imports, or partial graph cannot establish zero violations. A manual dependency review may supply bounded evidence; name what it did and did not cover.

Do not rewrite a baseline during a comparison. Advance it only after an accepted change and within the repository's authorized workflow. An unrelated pre-existing check failure must remain visible; if it prevents required verification, the result is inconclusive. Any agreed exception must state its scope and rationale without turning the failure into a pass.

## Material regression

Set relevant guards before editing, using repository limits when defined. Otherwise assess whether a change increases the cost or risk of understanding and changing the selected behavior. One extra dependency at a real boundary may be acceptable; a new cross-boundary knowledge dependency may not be. Record the evidence and rationale instead of inventing a universal tolerance percentage.

Inspect surrounding code after extraction. Reducing one function's complexity while adding shared mutable state, dispersed policy, or multiple delegating types fails the intended improvement even if all local thresholds pass.

## Exceptions

Record the specific rule and affected scope, why compliance would worsen the change or exceed the task, compensating evidence, the decision's authority, and any expiry or follow-up condition. Distinguish a justified soft-target trade-off from an authorized change to a hard requirement. Preserve the original requirement and observed result in both cases; an exception cannot turn missing evidence into a passing check.

For architecture changes, compare dependency direction, boundary ownership, and public/API contracts explicitly. Document intended compatibility changes and affected consumers. A newly added interface or layer earns its place through clearer ownership or an actual contract, not its presence in an example policy.
