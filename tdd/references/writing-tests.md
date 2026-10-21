# Writing tests worth keeping

A test earns its place by catching a specific break: a wrong branch, a missing
side effect, a wrong argument, a boundary case, or a broken contract.

## Test behavior through public interfaces

```typescript
// Bad: coupled to a collaborator, breaks on refactor
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});

// Good: observable outcome
test("user can check out a valid cart", async () => {
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Verify through the interface, not a side channel. Prefer
`getUser(created.id)` over querying the users table directly.

## Derive expected values independently

```typescript
// Bad: recomputes the answer the way the code does, so it always passes
const expected = items.reduce((sum, i) => sum + i.price, 0);
expect(calculateTotal(items)).toBe(expected);

// Good: a hand-checked literal
expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
```

Table-driven tests with literal expected values are a good default.

## Avoid change detectors

A test that only fails when someone makes a deliberate decision (a constant's
value, exact message wording, private structure) fires on redesign and misses
bugs. Test the behavior that depends on the decision instead: not
`MAX_RETRIES === 5`, but "a failing call is retried five times and no sixth
attempt happens."

Do not assert that a script or config contains a line. Run it against
controlled inputs and assert outputs, side effects, or exit codes.

Test your contract, not the framework's: the route you register and the payload
you produce, not that the router calls handlers.

## Mock only at system boundaries

Mock external APIs, time, randomness, and sometimes the database or filesystem.
Do not mock your own modules or internal collaborators.

- Learn every side effect of a method before replacing it. Mock the slow or
  external level below the behavior the test depends on.
- Never assert on the mock itself. If removing the mock would fail the
  assertion, the test checks the mock.
- Make doubles specific: give success, error, and malformed responses their own
  fixtures, and assert arguments or call order only when they are part of the
  contract.
- Mirror the complete real response shape, not only the fields the test reads.
- Keep test-only cleanup in test utilities, not on production classes.
- When mock setup outgrows the test, switch to an integration test with real
  components.

Design boundaries to be easy to replace: pass dependencies in, and prefer one
function per external operation (`getUser`, `createOrder`) over a generic
`fetch(endpoint, options)`.

## Mutation check

Before finishing, imagine realistic mutations of the production code: a wrong
constant or argument, a wrong branch, a missing state change, an empty return,
missing validation for empty, zero, unauthorized, or malformed input. At least
one test should fail for each. A mutation nothing catches marks unprotected
behavior or a tautological test.
