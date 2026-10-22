# Work contract

One contract per task, the same shape on every track. Tracks differ only in
which sections are required. It is the reviewer's and approver's reference, so
keep it short enough to read in a minute.

## Required sections

| Section | A | B | C |
| --- | --- | --- | --- |
| Gate line | — | Yes | Yes |
| Intent | Yes | Yes | Yes |
| Acceptance criteria | Yes, or a reproducible failure | Yes | Yes |
| Scope (in and out) | Yes | Yes | Yes |
| Verification | — | Yes | Yes |
| Constraints, assumptions, decisions, risks | When present | When present | Yes |
| Design | — | When the direction was groomed | Yes, after scope approval |

## Template

```markdown
## Work contract

**Track:** B: <one-line reason> · **Revision:** 1
**Gate:** <interactive, or autonomous: <basis>; no open decisions; <rollback kind> rollback>

### Intent
<the problem and the outcome, in one or two sentences>

### Acceptance criteria
- [ ] <observable behavior, including failure behavior>

### Scope
- In: <paths or areas>
- Out: <non-goals>

### Verification
<checks that prove the acceptance criteria: tests, commands, manual checks>

### Constraints
- <what must be reused, kept compatible, or avoided>

### Assumptions
- <reversible default>: <consequence if wrong>

### Decisions
- <question settled in grooming>: <answer>

### Risks
- <risk flag or concern>: <mitigation>

### Design
<Track C, filled from design.md>
```

Omit sections that are empty and not required. For Track A, the intent,
acceptance criteria and scope go into the change request description instead
of an issue.

## Rules

- Acceptance criteria describe behavior a reviewer can observe. They stay
  stable when the implementation strategy changes.
- Scope names paths or areas; delivery checks the diff against it.
- Raise the revision whenever intent, acceptance, scope or design changes.
  Approval applies to one revision, and so does an autonomous pass.
- Cite evidence by path or link. Keep credentials and sensitive data out.
