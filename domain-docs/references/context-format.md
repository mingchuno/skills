# CONTEXT.md format

```md
# {Context name}

{One or two sentences: what this context is and why it exists.}

## Language

**Order**:
A customer's request to buy one or more products.
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request
```

## Rules

- **Be opinionated.** Pick one word per concept and list the others under
  `_Avoid_`.
- **Keep definitions tight.** One or two sentences that say what the term is,
  not what the code does with it.
- **Project-specific terms only.** General programming concepts such as
  timeouts or error types do not belong.
- **Group terms** under subheadings when natural clusters appear.

## Multiple contexts

`CONTEXT-MAP.md` at the repository root lists each context and the
relationships between them:

```md
# Context map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md): receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md): generates invoices and takes payments

## Relationships

- **Ordering → Billing**: Billing consumes `OrderPlaced` events to create invoices.
```

If the map exists, infer which context the topic belongs to and ask when it is
unclear. Otherwise use a single root `CONTEXT.md`.
