---
sidebar_position: 6
title: Cron & settlement
---

# Cron & settlement

`cron.php` is the console entry point. Schedules live in
`protected/commands/cronjob.txt` and on the host crontab.

## Schedule

| Command | When | Purpose |
|---------|------|---------|
| `notify` | every minute | Drain `d0_notify_cron` queue → Telegram + license-delete actions. Bot id resolved per row from `d0_notify_bot`. |
| `visit` / `visitOptimized` | daily 02:00 | Snapshot dealer visit data |
| `stat` | daily 03:00 | Daily statistics aggregation |
| `settlement` | daily 01:00 | Distributor ↔ dealer monthly debt computation |
| `botLicenseReminder` | daily 09:00 | Notify dealers near licence expiry |
| `pradata` (HTTP) | 05:30 / 05:40 / 05:50 | External `salesdoc.io` instances pull pre-computed data via curl |
| `cleanner` | Sat 22:00 | Weekly cleanup (subscriptions, etc.) |
| `reportBot send` / `countrysale` | hourly | Internal report bots |
| `notifyCleanup --days=7` | daily 08:00 | Trim sent notify rows |
| `log cleanup --days=7` | Sun 02:45 | Trim `log/` |

All commands extend `BaseCommand`
(`protected/components/BaseCommand.php`).

## Settlement

`SettlementCommand` (daily 01:00) computes monthly debts/credits
between distributors and dealers.

```mermaid
flowchart LR
  S(["01:00 cron"]) --> READ["Pull last-month payments grouped by Distributor + Diler"]
  READ --> CALC["Compute share % per agreement"]
  CALC --> DEB["Insert Payment TYPE=distribute (debit Distributor)"]
  DEB --> CRE["Insert Payment TYPE=distribute (credit Diler)"]
  CRE --> LOG["LogDistrBalans rolling balance row"]
  LOG --> NOTIF[("Telegram summary to ops")]

  class S cron
  class READ,CALC,DEB,CRE,LOG action
  class NOTIF external
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

The pair of `Payment` rows nets out across distributors so the running
`BALANS` is consistent — the DB triggers handle the math.

## Notifications cron

```mermaid
sequenceDiagram
  participant CR as cron notify
  participant DB as MySQL
  participant TG as Telegram bot proxy (10.0.0.2:3000)
  participant SD as sd-main

  loop every minute
    CR->>DB: SELECT * FROM d0_notify_cron WHERE sent=0 LIMIT 100
    Note over CR,DB: Branch is keyed by row type column on d0_notify_cron
    alt Telegram
      CR->>DB: lookup d0_notify_bot
      CR->>TG: POST /addRequest
      TG-->>CR: ok
      CR->>DB: mark sent
    else License delete
      CR->>SD: api/license/delete (HTTP)
      SD-->>CR: ok
      CR->>DB: mark sent
    end
  end
```

**Cron tenants gotcha:** sd-billing is single-tenant (one DB), so cron
commands don't need to fan out across tenants like `sd-main` would.

## botLicenseReminder cron (sequence)

`BotLicenseReminderCommand` (`protected/commands/BotLicenseReminderCommand.php`)
fires daily at 09:00. The SQL inside `run()` joins `Diler`, `City`,
`Subscription`, and `Package` to find active dealers whose
`bot_report` subscription has lapsed (`NOT EXISTS … sub.ACTIVE_TO`
covers today), then iterates the result and posts to each dealer's
`telegramLicense` endpoint via `sendRequest()` with retry-up-to-3.

```mermaid
sequenceDiagram
  participant CR as 09:00 cron<br/>botLicenseReminder
  participant DB as MySQL (d0_*)
  participant LOG as upload/bot-report-reminder
  participant SM as sd-main<br/>/api/billing/telegramLicense

  CR->>DB: SELECT Diler WHERE no active<br/>bot_report Subscription
  DB-->>CR: rows[]
  loop per dealer
    CR->>LOG: check stamp file for today
    alt new today
      CR->>SM: curl POST telegramLicense
      alt 200 OK
        SM-->>CR: ok
        CR->>LOG: write success stamp
      else fail (try ≤ 3)
        CR->>SM: retry
      else fail (try > 3)
        CR->>LOG: append error log
      end
    end
  end
```

## Operation: manual payment entry

`operation/PaymentController::actionCreateOrUpdate`
(`protected/modules/operation/controllers/PaymentController.php`) is
the operator-side fallback when an inbound payment arrives off-gateway
(P2P, cash, cashless). It checks `Access` on
`operation.dealer.payment`, validates that the dealer's
`CURRENCY_ID` matches the posted currency, opens a DB transaction,
saves the `Payment` row, then commits and calls
`$dealer->deleteLicense()` so the dealer's `sd-main` notices the new
balance.

```mermaid
flowchart LR
  S(["Operator submits<br/>Payment row"]) --> A["actionCreateOrUpdate"]
  A --> CB{"Operator has cashbox?"}
  CB -- "no" --> R1(["error: no cashbox"])
  CB -- "yes" --> DLR{"Diler/Currency/Cashbox<br/>found?"}
  DLR -- "no" --> R2(["error: not found"])
  DLR -- "yes" --> CUR{"Diler.CURRENCY_ID<br/>matches?"}
  CUR -- "no" --> R3(["error: валюта"])
  CUR -- "yes" --> AC{"Access::check<br/>operation.dealer.payment"}
  AC -- "deny" --> R4(["403"])
  AC -- "allow" --> TX["BEGIN; Payment->save();<br/>COMMIT"]
  TX --> DL["Diler::deleteLicense()"]
  DL --> OK(["success"])

  class S,A,TX,DL action
  class CB,DLR,CUR,AC approval
  class R1,R2,R3,R4 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## Cashbox transfer

`cashbox/TransferController::actionAdd` /
`actionCreateAjax`
(`protected/modules/cashbox/controllers/TransferController.php`) moves
money between two cash desks. The action saves a `Transfer` model
then creates a paired `Consumption` outcome (negative `AMOUNT` on
`FROM_CASHBOX_ID`, `flowType=transfer`) and `Consumption` income
(positive on `TO_CASHBOX_ID`, `comingType=transfer`), backfilling
`Transfer.FROM_COMP_ID` / `TO_COMP_ID`. Cross-currency rows multiply
`EQUIVALENT` by `model->CURRENCY`.

```mermaid
flowchart LR
  S(["Operator submits<br/>Transfer form"]) --> FT{"FlowType +<br/>ComingType 'transfer'<br/>exist?"}
  FT -- "no" --> R1(["redirect: error flash"])
  FT -- "yes" --> SAVE["Transfer->save()"]
  SAVE --> OUT["Consumption OUTCOME<br/>(FROM_CASHBOX, -AMOUNT)"]
  OUT --> IN["Consumption INCOME<br/>(TO_CASHBOX, +AMOUNT)"]
  IN --> EQ{"isUZB()?"}
  EQ -- "yes" --> E1["EQUIVALENT = AMOUNT"]
  EQ -- "no" --> E2["EQUIVALENT = AMOUNT × CURRENCY"]
  E1 --> LINK["Transfer.FROM_COMP_ID,<br/>TO_COMP_ID set"]
  E2 --> LINK
  LINK --> OK(["success flash"])

  class S,SAVE,OUT,IN,E1,E2,LINK action
  class FT,EQ approval
  class R1 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## Idempotency

- Notify rows have a `sent` flag — once-only delivery.
- Settlement is keyed by `(distributor, diler, month)` so re-running
  the command (within the same month) produces no duplicates.
- `pradata` jobs are pull-only — safe to re-run.

## Backfilling

Use `dbservice` module utilities to backfill missing days. Example:

```bash
docker compose exec web php cron.php settlement --year=2026 --month=4
```

(Adjust the action signature based on the actual `SettlementCommand`
options — confirm before running in production.)

## Error handling

`FileLogRoute` (web) / `CFileLogRoute` (console) catches error-level
logs. A failed cron run leaves the affected rows in their previous
state, so the next minute's tick retries cleanly.
