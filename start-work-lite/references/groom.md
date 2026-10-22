# Groom

Grooming settles the few decisions that shape the work, then gets out of the
way. Stay at the altitude of the big picture: what problem, what outcome, how
far, which direction. Everything below that altitude is yours to decide and
record as an assumption.

## Altitude

| Ask the human | Decide yourself, record as an assumption |
| --- | --- |
| The problem and who it is for. | Names, file layout, module placement. |
| The observable outcome, including failure behavior. | Library choice inside the existing stack. |
| The scope boundary and non-goals. | Error message wording, log format. |
| How success is verified, when it is not obvious. | Test structure and fixtures. |
| The design direction, when approaches differ in cost, risk or reversibility. | Refactors the chosen direction needs. |
| Risk: compatibility, data, security, rollout. | Defaults any reasonable answer satisfies. |

The test for each candidate question: would a different answer change the
acceptance criteria, the scope, the track, or the design direction? If not, it
is an assumption.

## Rounds

1. Look up every fact first: code, tests, issue history, `CONTEXT.md`, ADRs.
   A question the repository answers is legwork, not a question.
2. Ask at most three questions per round, behavior before design. Number them,
   give each your recommendation and the consequence of the choice, worded so
   "yes" accepts it:

   ```text
   Q1 - <title>: <question, with options where useful>
   Recommended: <answer>. Changes: <what this decides>.
   ```

3. For a design direction, offer two or three approaches with one line of
   tradeoff each, and recommend one.
4. After each answer, re-route: an answer can raise the track.

Stop after the round that settles the intent, the acceptance criteria, the
scope boundary and, for Tracks B and C, the design direction. After three
rounds, stop anyway: carry what remains as assumptions or open items in the
contract and say so. The groomed result is the contract itself; write it next.

When the human uses a term that conflicts with `CONTEXT.md` or the code, name
the conflict and propose the precise term.
