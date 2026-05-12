---
sidebar_position: 4
title: Manual ledger correction
audience: QA
---

# Manual ledger correction

## What this feature is for

The operator path for adding a one-off ledger row that doesn't come from an order or a mobile payment — initial balances, payouts to the client, debt write-offs, manual payments that arrived through an unsupported channel. This is the only way the finans module itself *writes* to the ledger (everything else is read).

## Who uses it and where they find it

| Role | Allowed types | Path |
|---|---|---|
| Operator (3), Operations (5), Key-account (9) | 3 (payment), 6 (initial balance), 7 (payout), 8 (writeoff) | Web → Finance → Client debt → Add transaction |
| Admin (1) | All including blocked-by-policy types | Same |
| Others | Read-only | — |

Permission gate: `operation.clients.finansCreate`.

## The workflow

```mermaid
sequenceDiagram
    autonumber
    participant U as Operator
    participant F as Form
    participant Closed as Closed-period gate
    participant DB as ClientTransaction
    participant CF as ClientFinans

    U->>F: Pick client, currency, cashbox, type, amount, date, comment
    U->>F: Save
    F->>Closed: Is date < closed period? If yes, is role in exception list?
    alt period closed and role not exempt
        Closed-->>U: Redirect to "period closed" error
    else allowed
        F->>DB: INSERT ClientTransaction (SUMMA=abs(amount), STATUS='Y', IDEN=0)
        Note over F,DB: ⚠ SUMMA always positive; the sign comes<br/>from TRANS_TYPE. Test that the displayed sign<br/>matches what the user expected.
        F->>CF: correct() — recompute running balance
        F->>F: notifyClient() + TelegramReport
        F-->>U: Saved
    end
```

## Step by step

1. The operator opens the client's debt view and clicks **Add transaction**.
2. The operator picks:
    - Client
    - Currency
    - Cashbox (subject to role-6 scoping)
    - Type — 3, 6, 7 or 8
    - Amount (positive number — sign is inferred from type)
    - Date
    - Comment (optional)
3. The operator submits.
4. *The system checks the closed-period gate* via `Closed::check_update('finans', date)`. ⛔ If the period is closed and the user's role is not in the exception list, the save is rejected with a redirect to the period-closed page.
5. *The system inserts a `ClientTransaction` row* with `SUMMA = abs(amount)`, `STATUS='Y'`, `IDEN=0` (no order linkage), with the chosen TRANS_TYPE.
6. *The system runs `ClientFinans::correct()`* which recomputes the cached running balance for that client / currency.
7. *The system notifies the client* (SMS / push) and sends a Telegram alert to the dealer's reporting channel.
8. The new row appears in the client's debt view.

## What can go wrong

| Trigger | What you see | Plain-language meaning |
|---|---|---|
| Period closed | Redirect to error page; nothing saved | The dealer has locked transactions before a certain date. |
| Amount = 0 | Field error | Must be positive. |
| Currency not active | Save fails | Pick a currency the dealer accepts. |
| Cashbox not yours (role 6) | Cashbox missing from dropdown | Scoping in effect. |
| Manager-approval flow on this row type | Row inserts but stays `STATUS='N'` (depends on dealer config) | The current finans flow saves as `Y`; if your dealer wraps a separate approval layer around this, test it explicitly. |

## Rules and limits

- **`SUMMA` is always stored as a positive number.** The sign you *see* on the screen is computed from the type. Test plans should record the actual stored value in addition to the displayed value.
- **`IDEN=0` for every manual row** — no linkage to an order. Reports that filter by order will not show these rows.
- **Closed-period gate uses `MODEL='finans'`**, separate from the orders module's *close date*. Each can be set independently.
- **`STATUS='Y'` is immediate** — there is no built-in approval queue at this layer.
- **Client notification is fire-and-forget.** If SMS / Telegram is down, the row still saves.

## What to test

- Add a TRANS_TYPE=3 payment manually. Client balance increases by the amount.
- Add a TRANS_TYPE=8 writeoff for the outstanding debt. Balance goes to zero (or credit if the writeoff exceeds it).
- Add a TRANS_TYPE=6 initial balance dated in the past. Verify it appears at the bottom of the date-sorted view.
- Save a row dated before the period close, as a non-exempt role. Should be rejected.
- Same scenario, as a role in the exception list. Should succeed.
- Save a row in a currency the dealer doesn't accept. Should fail.
- Cashier (role 6) tries to save a row pointing at a colleague's cashbox. Cashbox should be invisible in the dropdown.
- Audit: every save creates exactly one ClientTransaction row and triggers exactly one ClientFinans recompute.

## Where this leads next

- For how a TRANS_TYPE=3 payment closes existing TRANS_TYPE=1 invoices, see [Settlement](./settlement.md).
- For the cashbox dimension, see [Cashbox balance](./cashbox-balance.md).

## For developers

Developer reference: `protected/modules/clients/controllers/FinansController.php::actionCreate`.
