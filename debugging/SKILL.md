---
name: debugging
description: Find the root cause of a bug, failing test, build failure, or performance regression before fixing it. Use when something is broken, throwing, flaky, or slow, or when a fix attempt has already failed.
license: MIT
metadata:
  version: "1.0.0"
  sources: "mattpocock/skills diagnosing-bugs; obra/superpowers systematic-debugging (both MIT, see THIRD_PARTY_NOTICES.md)"
---

# Debugging

No fix without a root cause. A fix that makes the symptom disappear without an
explanation is a guess.

Read `CONTEXT.md` (or `GLOSSARY.md`) and ADRs for the affected area first.
Redact secrets in every command, output, and artifact you show: write
`<REDACTED>`, keep credentials in environment variables, and quote only the
lines that carry the signal.

## 1. Build a feedback loop

This is most of the work. Find one command that drives the real code path and
asserts the user's exact symptom. In rough order of preference: a failing test
at a seam that reaches the bug, an HTTP script, a CLI run diffed against a
known-good output, a headless browser script, a replayed captured payload, a
throwaway harness, a property or fuzz loop, a `git bisect run` harness, or a
differential run of old against new. If a human must act, drive them with
[scripts/hitl-loop.template.sh](scripts/hitl-loop.template.sh).

Then tighten it: faster, a sharper assertion, deterministic (pinned time,
seeded randomness, isolated filesystem and network). For flaky bugs, raise the
reproduction rate until it is debuggable.

Done when you have **run** the command at least once and it is red on this bug,
deterministic, fast, and runnable without you. If you cannot build one, stop,
list what you tried, and ask for an environment, a redacted artifact, or
permission to add temporary instrumentation. Do not theorise without a loop.

## 2. Reproduce, read, minimise

- Confirm the loop shows the failure the user described, not a nearby one.
- Read the full error, stack trace, and warnings.
- Check what changed: `git log`, diffs, dependency and config changes,
  environment differences.
- Shrink the repro one element at a time until every remaining input, step,
  and setting is needed for the failure.

## 3. Hypothesise

Find working code that resembles the broken code and list every difference.
For multi-component paths, log what enters and leaves each boundary once to
locate the failing layer.

Write 3–5 ranked, falsifiable hypotheses: "If X is the cause, changing Y makes
the bug disappear." Show the list to the user before testing; they may re-rank
it. Continue with your ranking if they are away.

## 4. Instrument

Each probe tests one prediction and changes one variable. Prefer a debugger,
then targeted logs at distinguishing boundaries. Tag temporary logs with a
unique prefix such as `[DEBUG-a4f2]`. For performance, measure a baseline and
bisect instead of logging. Trace bad values backward to where they originate;
see [references/techniques.md](references/techniques.md).

## 5. Fix with a regression test

Turn the minimised repro into a failing test at a seam that exercises the real
bug pattern (use the `tdd` skill if installed). If no such seam exists, record
that as a finding instead of writing a shallow test. Watch it fail, fix the
root cause with one change, watch it pass, then rerun the original loop.

If a fix fails, return to step 3 with what you learned. After three failed
fixes, stop: the design is probably wrong. Discuss the architecture with the
user before a fourth attempt.

## 6. Clean up and report

- The original loop no longer reproduces the bug.
- The regression test passes, or the missing seam is documented.
- `[DEBUG-` instrumentation and throwaway harnesses are removed.
- The confirmed hypothesis is stated in the commit or change request.

If the cause is genuinely external or timing-related, say what you
investigated, add handling and monitoring, and label it as such. Most "no root
cause" conclusions are incomplete investigations.
