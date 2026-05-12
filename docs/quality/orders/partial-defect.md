---
sidebar_position: 5
title: Partial defect
audience: QA
---

# Partial defect on a delivered order

## What this feature is for

Sometimes the client accepts most of an order but rejects a few items because they're damaged, broken, expired or otherwise unsellable. The operator marks **only those line items** as defective without returning the whole order. The system reduces the order's total, releases the right amount of debt, and moves the rejected goods to the *defect store* (a separate warehouse for damaged stock) if the expeditor has one configured.

This is **not** the same as a whole-order return. If the client refused *everything*, see [Whole-order return](./whole-return.md).

## Who uses it and where they find it

| Role | What they do here | How they get to the screen |
|---|---|---|
| Operator (3) | Records defects reported by the expeditor after delivery | Web → Orders → click an order → "Mark defective quantity" dialog per line |

Other roles do **not** typically have this permission. Verify the button is hidden for Manager (2), Operations (5), Key-account (9), and definitely for Agent (4) and Expeditor (10).

## When this feature is allowed

| Order status | Allowed? |
|---|---|
| New | ❌ No |
| **Shipped** | ✅ Yes |
| **Delivered** | ✅ Yes |
| Returned | ❌ No |
| Cancelled | ❌ No |

The feature is also only valid on **Type 1 — Sale** orders. Defects on recovery or replacement orders are handled differently.

## The workflow — at a glance

```mermaid
flowchart TD
    A([Operator opens order detail]) --> B{Status is Shipped or Delivered?}
    B -- No --> ERR1[Error: 'Operation not available for this status']
    B -- Yes --> C{Order is type Sale?}
    C -- No --> ERR2[Error: 'Operation not available for this order type']
    C -- Yes --> D{Order is past close date?}
    D -- Yes --> ERR3[Error: 'Order date past close date']
    D -- No --> E{Order is waiting for filial decision?}
    E -- Yes --> ERR4[Error: 'Order waiting for dealer acceptance']
    E -- No --> F[Operator enters defective quantity per line]
    F --> G{New count would be negative?}
    G -- Yes --> ERR5[Error: 'Negative count not allowed']
    G -- No --> H{Defect count went DOWN?<br/>(operator removes some defect)}
    H -- Yes --> I{Enough stock to re-stock the items?}
    I -- No --> ERR6[Error: 'Insufficient stock to undo defect']
    I -- Yes --> J[Update lines, totals, debt]
    H -- No --> J
    J --> K{Expeditor has a defect store?}
    K -- Yes --> L[Move defective qty<br/>from order's warehouse<br/>to defect store]
    K -- No --> M[Skip the store move<br/>⚠ stock is not moved anywhere]
    L --> N[Append order history]
    M --> N
    N --> O([Done — refresh order view])
```

## Step by step

1. The operator opens the order's detail page (status must be **Shipped** or **Delivered**).
2. The operator opens the **Mark defective quantity** dialog for one or more lines, enters the defective quantity per line (e.g. *"5 of 12 are broken"*) and presses **Save**.
3. *The system verifies the order is in Shipped or Delivered.* ⛔ If not, the operator sees *"Operation not available for this status"*.
4. *The system verifies the order is type Sale.* ⛔ If not, *"Operation not available for this order type"*.
5. *The system verifies the order is not past the close date.* ⛔ If it is, the operator sees the close-date error.
6. *The system verifies the order is not waiting on a filial-order decision.* ⛔ If it is, the operator sees *"Order waiting for dealer acceptance"*.
7. *The system processes each defective line:*
    - Calculates **how much the defect changed by** versus what was already there.
    - If the defect went **up** (more items now defective): subtracts from the line's quantity and updates SUMMA, discount and volume **proportionally**.
    - If the defect went **down** (operator is correcting a prior mistake): checks that stock can cover putting items back into the sellable quantity. ⛔ If not, *"Insufficient stock to undo defect"*.
8. **If the expeditor has a defect store configured:**
    - *The system moves the defective quantity* from the order's warehouse into the defect store.
    - *Stock balances update on both sides* (the order's warehouse drops, the defect store rises).
    - *An exchange record is written* to track the movement.
9. **If the expeditor does *not* have a defect store:** the defect is recorded but **no stock move happens**. The defective goods are conceptually lost. ⚠ This is a real, silent behavioural fork — test both.
10. *The system updates the bonus order if any* (because line quantities changed).
11. *The system updates the client's debt row* — the order's total has dropped, so the debt drops too.
12. *The system appends a row to the order history.*

## What can go wrong (errors the operator sees)

| Trigger | Error message | Plain-language meaning |
|---|---|---|
| Order is not Shipped or Delivered | "Operation not available for this status" | The order is in New, Returned or Cancelled. |
| Order type is not Sale | "Operation not available for this order type" | This is a recovery or replacement order; defect flow doesn't apply. |
| Order older than close date | "Order date [date] is past the close date [closeDate]" | Order is too old to modify. |
| Order waiting on filial decision | "Order waiting for dealer acceptance / rejection" | Defects are blocked until the dealer accepts the order. |
| Operator entered a negative number | "Negative count not allowed" | The defective quantity cannot be a negative number. |
| Operator is reducing a previous defect but stock cannot cover it | "Insufficient stock in warehouse" (per product) | The system needs stock back to "un-defect" the line, and there isn't any. |

## Rules and limits

- **Defect is per-line, not whole-order.** Each line can have its own defective quantity. Lines that the client took fine keep their original quantity.
- **Re-saving the same defect is idempotent.** If the operator opens the dialog and saves without changing numbers, nothing happens.
- **Reducing a defect is allowed but uses stock.** Bringing a defective item back into the sellable count requires that the warehouse can give back the stock.
- **The defect store move is conditional.** It happens only if the expeditor assigned to this order has a defect store configured on their profile. Test plans must cover both: expeditor with and without a defect store.
- **Bonus orders are recalculated.** If the original order had a bonus order linked, marking lines as defective may shrink or empty the bonus. Verify the linked bonus reflects the new quantities.
- **The line's discount is recalculated proportionally** — if the operator marks 5 of 12 boxes as defective, the line's discount amount drops by 5/12.
- **Manual discounts have a flag** that affects how the recalculation works. If a line had a manual discount entered by the operator, the system honours the per-unit discount rather than the rule-based one.
- **Bonus triggering products are read-only.** A line that *qualified* the order for a bonus cannot be marked as defective via this dialog — defects there must be handled separately. (Test that the dialog blocks editing such lines.)

## What to test

### Happy paths

- Operator opens a Delivered order with 10 line items, marks line 1 as 2-of-10 defective. Order total drops by 2 line's worth; debt drops accordingly.
- Same on a Shipped order — passes.
- Mark defects on three lines at once — all three are reduced; order total drops by sum of three.
- Order is on an expeditor with a defect store — verify stock moved from order's warehouse to defect store.
- Order is on an expeditor with no defect store — verify the defect is recorded but no stock moved.
- Reduce a previously-recorded defect (e.g. operator entered 5, now corrects to 2) — verify the line's sellable count goes back up and stock is consumed accordingly.

### Validation failures

- Try on a New order. Expect: status error.
- Try on a Returned or Cancelled order. Expect: status error.
- Try on a Type 2 (recovery) or Type 3 (defect) order. Expect: type error.
- Try on an order whose date is older than the close date. Expect: close-date error.
- Try on an order with a pending filial-order acceptance. Expect: filial-block error.
- Enter a negative defect quantity. Expect: negative-count error.
- Enter a defect quantity larger than the line's quantity. Expect: rejection.
- Reduce a defect when the warehouse cannot supply the un-defected stock. Expect: stock-error.

### Edge cases and data integrity

- Defect every line in an order down to zero. Verify the order's total is now zero and debt is zero (but order is still in Delivered status, not Returned — that's the difference from a whole-order return).
- Operator on filial A tries to mark defects on an order in filial B. Verify it is rejected.
- Operator opens the dialog, the expeditor's defect store is removed in another tab, operator saves. Verify the defect is recorded but no stock move happens (or that the system handles the missing defect store cleanly).
- Operator marks 3 lines defective; one of those lines was the bonus-triggering product. Verify that line's defect dialog refuses to edit it (it should be read-only).
- After defects are recorded, verify the bonus order's quantities reflect the lower line counts.
- After defects, run the daily debt report — verify the client's debt matches the reduced order total.

### Side effects to verify

- The order's totals (count, sum, volume) drop.
- Each defective line shows its defective quantity stored separately from its sellable quantity.
- If the expeditor has a defect store, the defect store's stock has risen by the defective quantity.
- The order's warehouse stock has fallen by the same quantity (it moved out).
- The client's debt is reduced by the defect amount.
- The bonus order, if any, is updated.
- A row is appended to the order history.

## Where this leads next

- If the operator decides the *entire* order should be returned, not just some lines, see [Whole-order return](./whole-return.md).
- If the order needs to be re-opened to fix something else, see [Edit order](./edit-order.md).

## For developers

Developer reference: `docs/modules/orders.md` — see *Workflow 1.4 — Partial defect declaration and stock return*.
