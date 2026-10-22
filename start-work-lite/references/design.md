# Design

Use after scope approval on Track C, or on Track B when grooming left the
design direction to you. The approved acceptance criteria and scope are the
design's limits: a design that needs more scope goes back for scope approval
first.

## Steps

1. Inspect the affected components, contracts, data lifecycle, and the ADRs in
   the area. Load `production-software-architecture` when available.
2. Compare the significant alternatives. Prefer the existing mechanism when it
   satisfies the acceptance criteria.
3. Fill the contract's Design section:

| Field | Content |
| --- | --- |
| Summary | The approach and the interfaces or data contracts it changes. |
| Alternatives | Rejected approaches and the tradeoff behind the choice. |
| Stages | Bounded implementation stages, each with an observable completion condition. |
| Verification | Checks for success, failure, and integration boundaries. |
| Rollback | How to recover, with irreversible consequences stated. |
| References | Evidence and existing decisions. |

The design lives in the contract, where it is approved. A separate design
document under `docs/` is warranted only when the repository already keeps
them there.

## Knowledge

Decide one outcome for the task, at design time for Track C and after the
self-review for every track:

| Outcome | When |
| --- | --- |
| No change | The work follows existing decisions and adds no lasting fact. |
| Update `CONTEXT.md` | A domain term or business invariant was settled or corrected. |
| New or superseding ADR in `docs/adr/` | A durable decision about architecture, persistence, security, an external contract or deployment, one a future maintainer would struggle to reconstruct. |

Write the update in the same branch so it is reviewed with the code, following
`domain-docs` when available: `CONTEXT.md` holds terms without implementation
detail; an ADR holds context, decision and consequences in under a page. Name
a planned ADR in the Design section so the approver sees it.
