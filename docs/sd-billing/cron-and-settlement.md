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
  LOG --> NOTIF["Telegram summary to ops"]
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
