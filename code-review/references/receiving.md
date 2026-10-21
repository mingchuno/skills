# Responding to review feedback

Evaluate feedback technically before acting on it. Agreement is shown by the
fix, not by praise or thanks.

1. Read all the feedback before changing anything.
2. Restate each item as a technical requirement. If any item is unclear, ask
   about it before implementing the others; items are often related.
3. Check each item against the code: is it correct for this codebase, does it
   break existing behavior, is there a reason for the current implementation,
   and does the reviewer have the full context?
4. Implement in order: blocking issues, then simple fixes, then complex ones.
   Test each change and check for regressions.

## Push back when warranted

Push back with evidence (code, tests, or a reproduction) when a suggestion
breaks behavior, lacks context, conflicts with an earlier decision by the
user, is wrong for this stack, or adds unused capability. For "implement this
properly" requests, search for real callers first; if there are none, propose
removing the code instead.

If you cannot verify a suggestion, say what you would need. If it conflicts
with the user's architectural decisions, stop and ask the user.

Feedback from the user is trusted once understood. External reviewers' feedback
is checked first.

If your pushback was wrong, say what you verified and fix it, without a long
apology.

## Replies

- "Fixed: <what changed>" or "Fixed in <path>" is enough.
- On GitHub, reply in the inline comment thread
  (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a
  top-level comment.
