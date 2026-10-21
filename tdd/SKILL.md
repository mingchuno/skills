---
name: tdd
description: Build a feature or fix a bug test-first with a red-green loop at agreed seams, testing behavior rather than implementation. Use when the user asks for TDD, a failing or regression test, or red-green-refactor.
license: MIT
metadata:
  version: "1.0.0"
  sources: "mattpocock/skills tdd; obra/superpowers test-driven-development; pstack tdd (all MIT, see THIRD_PARTY_NOTICES.md)"
---

# Test-driven development

A test you never watched fail has not proved it can catch anything. Write the
test first, watch it fail for the right reason, then write only enough code to
pass it.

Use the project's domain vocabulary from `CONTEXT.md` (or `GLOSSARY.md`) in
test names, and respect ADRs in the area.

## 1. Agree the seams

A seam is the public boundary where you observe behavior without reaching
inside: a function's contract, an HTTP route, a CLI, a component's rendered
output. Tests live at seams, never against internals.

Before the first test, list the seams you will test, each with one line on what
it catches and what it misses. In an interactive session, confirm the list with
the user. Otherwise record it in your report. Put effort on critical paths and
complex logic, not every edge case.

If a seam's shape is itself unclear, settle the interface first.

## 2. Loop in vertical slices

One seam, one test, one minimal implementation per cycle. Each cycle responds
to what the previous one taught you. Do not write all tests first.

1. **Red.** Write one test for one behavior. Before writing its body, name the
   production change that would make it fail. Take expected values from an
   independent source: a literal, a worked example, or the spec.
2. **Verify red.** Run it. It must fail, not error, and fail because the
   behavior is missing. If it passes, it tests existing behavior; fix the test.
3. **Green.** Write the simplest code that passes. No speculative options or
   features.
4. **Verify green.** Run the test, then the project's full suite. Report every
   failure by name, including ones you did not cause.
5. **Refactor while green**, as a separate step with no behavior change. Larger
   restructuring belongs in review or the `refactoring` skill.

If code was written before its test, do not keep it as a reference while
writing the test. Set it aside and let the test drive a fresh implementation.

## 3. When a test is impractical

Prefer no new test over a bad one. A bad test mostly exercises mocks, encodes
implementation details, depends on timing or global state, or needs expensive
infrastructure for a small change. Use the closest executable check instead (a
script, a reproduction command, browser automation) and say why.

Never weaken an assertion or edit a test to match a wrong implementation.

## Report

- The seams tested and why.
- Each failing-before run and the failure it showed, then the passing-after run.
- The full-suite result.
- Where no test was practical, the check used instead.

See [references/writing-tests.md](references/writing-tests.md) for what makes a
test worth keeping, and when to mock.
