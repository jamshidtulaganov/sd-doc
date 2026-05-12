---
sidebar_position: 5
title: Settlement (FIFO matching)
audience: QA
---

# Settlement — how payments close invoices

## What this feature is for

A payment row (TRANS_TYPE=3) does not automatically know which invoice (TRANS_TYPE=1) it covers. The settlement engine pairs them up using a **first-in-first-out** algorithm: the oldest open invoice gets covered first, the next oldest next, until the payment is exhausted (or there are no more invoices).

The pairing produces a `TransactionClosed` row per match. The `COMPUTATION` field on each side tracks how much of that side has been *applied* to its counterpart so far.

This is the most arithmetic-heavy area of the entire system. Tests here must check exact numbers, not just success / fail.

## Who triggers settlement

| Trigger | Who | When |
|---|---|---|
| Auto-settlement on payment save | System | A new TRANS_TYPE=3 row is written by the payment module or by finans manual entry. |
| Manual settlement | Operator | Operator clicks a *"close"* action on the debt view to force-match a specific payment to a specific invoice. |
| Re-settle after correction | System | An existing settlement is invalidated and the engine re-runs. |

## The algorithm in plain words

```mermaid
flowchart TD
    A([New payment saved]) --> B[Load all OPEN invoices for this client + currency<br/>ordered by DATE ASC]
    B --> C[Iterate invoices oldest-first]
    C --> D{Invoice still has open balance?}
    D -- yes --> E{Payment still has unallocated SUMMA?}
    E -- yes --> F[Close min(invoice.open, payment.remaining)]
    F --> G[Insert TransactionClosed row<br/>TR_FROM=payment, TR_TO=invoice, SUMMA=amount]
    G --> H[Update payment.COMPUTATION -= amount<br/>Update invoice.COMPUTATION += amount]
    H --> D
    E -- no --> X([Stop])
    D -- no --> C
```

The same algorithm runs across all invoices in the client × currency bucket. If one invoice is half-paid, the next payment continues where the last left off.

## Step by step (for a simple test scenario)

1. Client has one open invoice: TRANS_TYPE=1, SUMMA = −1,000,000 UZS, COMPUTATION = 0.
2. The system receives a payment: TRANS_TYPE=3, SUMMA = 600,000 UZS, COMPUTATION = 0.
3. *Settlement runs.* The 600,000 covers half of the invoice.
4. Result:
    - One `TransactionClosed` row: TR_FROM = payment id, TR_TO = invoice id, SUMMA = 600,000.
    - Invoice's COMPUTATION = 600,000 (so the *open balance* = |SUMMA| − COMPUTATION = 400,000 still owed).
    - Payment's COMPUTATION = −600,000 (so the *unallocated balance* = 0 — fully distributed).
5. Another payment arrives: SUMMA = 500,000 UZS.
6. Settlement runs again. It applies 400,000 to the original invoice (now fully closed) and leaves 100,000 unallocated as an overpayment.

## What can go wrong

| Trigger | What you see | Plain-language meaning |
|---|---|---|
| Multi-currency mismatch | Payment is in USD; invoice is in UZS. No settlement happens. | Currencies cannot cross. Both rows stay open. |
| TRANS_TYPE=4 in the mix | A conversion row exists for this client. It's silently skipped. | By design. See [Multi-currency](./multi-currency.md). |
| Race condition: two payments saved at the same time | Both attempt settlement, possible double-allocation | Test concurrent saves explicitly. |
| Manual `closeTransaction(transID, requestedAmount, ...)` over-asks | Returns actual closed amount, may be less than requested | Test that the return value is checked. |
| Invoice with `STATUS='N'` (pending approval) | Excluded from settlement until status flips to Y | Verify your test fixtures use STATUS=Y. |

## Rules and limits

- **FIFO is per client × currency.** Same client, different currencies = different settlement chains.
- **The `close_by_agent` variant** scopes by agent in addition — used when a payment is tagged to a specific agent and should only close that agent's invoices.
- **`COMPUTATION` is the source of truth for open balance**, not `SUMMA`. The view's "open" badge is computed: `|SUMMA| − |COMPUTATION|`.
- **Overpayment** sits as `COMPUTATION` on the payment row. The next invoice (later in time) can absorb it.
- **No automatic refund of overpayment.** Operators handle excess credit by manually entering a payout (TRANS_TYPE=7) or applying it via `closeTransaction`.
- **Deleting a transaction with linked settlements** must cascade: the `TransactionClosed` rows on either side must be removed and the counterpart's COMPUTATION recomputed. Test this — it's a known source of orphan rows.

## What to test

### Single-invoice happy paths

- 1 invoice 1,000 + 1 payment 1,000 → fully closed; both COMPUTATION at limit; one TransactionClosed row of 1,000.
- 1 invoice 1,000 + 1 payment 600 → partial close. Open balance 400. TransactionClosed.SUMMA = 600.
- 1 invoice 1,000 + 1 payment 1,200 → invoice closed, payment has COMPUTATION = −1,000, unallocated 200.

### Multi-invoice

- 3 invoices each 500, total 1,500. One payment 1,500. All three close. Three TransactionClosed rows.
- Same scenario, payment 1,200 instead. Invoices 1 and 2 close fully. Invoice 3 is half-closed (250 of 500).
- Same, payment 1,800. All three close, 300 left as overpayment.

### Multi-currency

- Invoice UZS 100,000 + payment USD 10. No settlement. Both stay open.
- Conversion row TRANS_TYPE=4 between USD and UZS exists. Settlement still doesn't cross. Test the row's presence does not perturb other matches.

### Manual closeTransaction

- Operator force-matches a specific payment to a specific invoice. Verify the result row matches the requested pair and amount, even if it would not have been picked by FIFO.
- Over-ask: request closing 1,000 against a payment with 600 remaining. Return value should be 600.

### Deletion / re-settle

- Delete a payment that had two TransactionClosed children. Verify both children are removed and the two invoices' COMPUTATION re-decreases by the right amounts.
- Edit an invoice's SUMMA after a settlement (rare but possible via correction). Verify the next correct() pass adjusts.

### Reconciliation invariants

- For any client × currency: `SUM(SUMMA) = ClientFinans.BALANS` (the cache must match the live sum, modulo TRANS_TYPE=4 exclusion).
- For any payment: `SUM(TransactionClosed.SUMMA where TR_FROM=payment) ≤ |payment.SUMMA|`.
- For any invoice: `SUM(TransactionClosed.SUMMA where TR_TO=invoice) ≤ |invoice.SUMMA|`.

## Where this leads next

- For multi-currency edge cases, see [Multi-currency](./multi-currency.md).
- For cashbox-level aggregation of payments, see [Cashbox balance](./cashbox-balance.md).

## For developers

Developer reference: `protected/models/TransactionClosed.php` — `close_by_client`, `close_by_client_currency`, `close_by_agent`, `closeTransaction`.
