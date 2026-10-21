# Change request descriptions and commit messages

Sources: mattpocock/skills `pr`, whose summary visuals come from Dex Horthy's
`show-me` (MIT, see THIRD_PARTY_NOTICES.md).

## Change request template

Follow the repository's template when one exists. Otherwise:

```markdown
## Summary

<one or two sentences, plus the smallest visual that shows the change>

## Evidence

- **Before:** <failing test, output, or screenshot>
  **After:** <passing test, output, or screenshot>

## Risk

**Reversibility:** <two-way door, or one-way door and why>
**Blast radius:** <who or what is affected if this is wrong>

## Limitations

<checks not run, manual steps left, known gaps; omit when none>
```

Reference the issue (`Closes #123`). Use the domain terms from `CONTEXT.md`.
Skip preambles and restating the diff.

## Summary visuals

Pick the smallest view that makes the point; often none is needed.

| Change | Visual |
| --- | --- |
| Logic or algorithm | Pseudocode |
| Runtime control flow | Indented call tree |
| UI structure | Component tree with state and module boundaries |
| File responsibilities | Shallow file tree with one comment per entry |
| Interaction between components | Mermaid sequence diagram |
| Change to an existing shape | `diff` of the tree, call stack, or pseudocode |

```diff
 submitForm
   createSession
     persistPrompt
+    expandSkillMention
     launchAgent
```

## Evidence

Screenshots are best for visual changes. Otherwise show execution: the test
that failed before and passes after, or command output. Label checks you could
not run as limitations, never as passes.

## Risk

A two-way door is cheap to roll back. Destructive or hard-to-reverse changes
(data migrations, deletions, published APIs) are one-way doors and need the
rollback or mitigation stated. Blast radius names the consumers, users, or
systems a mistake would reach.

## Commit messages

Follow the repository's convention, such as Conventional Commits. The subject
says what changed in the imperative. The body, when needed, says why and
anything a future reader of `git log` must know, such as the confirmed root
cause of a bug.
