# Debugging techniques

## Trace to the original trigger

When an error surfaces deep in a call stack, the failing line is rarely the
cause. Walk backward:

1. Find the code that directly fails.
2. Ask what called it and with which values.
3. Repeat until you reach the place the bad value was created.
4. Fix there, not at the symptom.

If you cannot follow the chain by reading, capture it: log the arguments,
`process.cwd()` or equivalent, and a stack trace immediately before the failing
operation. In tests, write to stderr; loggers are often suppressed.

## Find the test that pollutes state

When a file, directory, or global appears during a test run and you do not know
which test creates it, run test files one at a time and check for the artifact
after each. Stop at the first test that creates it. `git bisect run` uses the
same idea across commits.

## Wait for conditions, not durations

Flaky tests often sleep for a guessed duration. Replace the sleep with polling
for the condition the test needs (an event, a state, a count, a file), with a
timeout and a description in the timeout error. Keep a fixed delay only when the
behavior under test is itself timing (debounce, throttle), and comment why.

## Make the bug structurally impossible

After fixing the root cause of invalid data, consider validating at each layer
it crosses:

| Layer | Purpose |
| --- | --- |
| Entry point | Reject invalid input at the API boundary. |
| Business logic | Check the value makes sense for this operation. |
| Environment guard | Refuse dangerous operations in a specific context, such as writes outside a temporary directory during tests. |
| Diagnostics | Log context that makes the next failure explainable. |

Add layers only where the data's path and the cost of the failure justify them.
