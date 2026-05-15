---
sidebar_position: 5
title: Subscription & licensing
---

# Subscription & licensing

The end-to-end flow from a dealer signing up to their `sd-main`
unlocking features.

```mermaid
flowchart LR
  S(["Dealer signs up"]) --> P["Pay (online or offline)"]
  P --> B["Diler.BALANS += summa"]
  B --> BUY["api/license/buyPackages"]
  BUY --> CHK{"Validation passes?"}
  CHK -- "no" --> ERR(["Reject"])
  CHK -- "yes" --> SUB["Subscription rows<br/>[START_FROM, ACTIVE_TO]"]
  SUB --> NEG["Payment TYPE=license (negative)"]
  NEG --> SET["Diler.refresh() — recompute BALANS, FREE_TO, MONTHLY"]
  SET --> SRV["Diler.HOST → Server.STATUS=SENT → OPENED"]
  SRV --> NOTIF(["Telegram + SMS to dealer"])

  class S action
  class P,B,BUY,SUB,NEG,SET,SRV action
  class CHK approval
  class ERR reject
  class NOTIF success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

The `Validation` step rejects on any of these independent checks:

| Check | Reject when |
|-------|-------------|
| Balance | `Diler.BALANS` < `Package.PRICE` (total across requested packages) |
| Minimum thresholds | `MIN_SUMMA` or `MIN_LICENSE` anti-abuse limit not met |
| Currency match | Posted currency ≠ `Diler.CURRENCY_ID` |

## Buy packages — round-trip sequence

`LicenseController::actionBuyPackages` in
`protected/modules/api/controllers/LicenseController.php` runs inside a
`new UserIdentity("sd","sd")` session. After the validation block it
loops `month_count` times, writes one `Subscription` row per requested
package, mirrors each with a negative `Payment(TYPE_LICENSE)`, calls
`$diler->writeVisit()`, and ends with `deleteLicenseImmediately($diler)`
so the dealer's `sd-main` sees the new entitlements on the same
response.

```mermaid
sequenceDiagram
  participant SM as sd-main (dealer)
  participant API as sd-billing<br/>api/license/buyPackages
  participant DB as MySQL
  participant D as Diler

  SM->>API: POST {token, host, packages[], start_date, month_count}
  API->>API: UserIdentity("sd","sd") authenticate
  API->>DB: validate package, currency, day-of-month
  loop each month × each package
    API->>DB: INSERT Subscription (START_FROM, ACTIVE_TO)
    API->>DB: INSERT Payment TYPE=license (-amount)
  end
  API->>D: writeVisit() + deleteLicenseImmediately()
  API-->>SM: 200 {success, diler_id}
```

## Buy packages

`POST /api/license/buyPackages` — called by the dealer's `sd-main` (a
fixed-user login session via `new UserIdentity("sd","sd")`).

Validation done in `LicenseController::actionBuyPackages`:

1. Dealer exists + is active.
2. Posted currency matches `Diler.CURRENCY_ID`.
3. Each requested package is sellable to this dealer's
   `Diler.COUNTRY_ID`.
4. `Diler.BALANS` ≥ total.
5. `MIN_SUMMA` / `MIN_LICENSE` thresholds satisfied (anti-abuse).

On success:

- Insert `Subscription` rows for each chosen package, dated
  `START_FROM = today`, `ACTIVE_TO = today + Package.TYPE` days.
- Insert one `Payment` row with `TYPE = license` and a **negative**
  `SUMMA` (so triggers decrement `BALANS` by the cost).
- Call `Diler::refresh()` to recompute the dealer's balance, `FREE_TO`,
  and `MONTHLY` summary.
- Touch `Server.STATUS` so the dealer's `sd-main` receives the new
  licence.

## Free trial

`Diler.IS_DEMO` and `Diler.FREE_TO` give a date-bounded free window.
While the trial is active, `hasSystemActive(systemId)` (called by
`sd-main` at login) returns `true` even without subscriptions.

## Renewal

Renewal is just another **buy** call with the same packages. The new
`Subscription` rows extend the dealer's coverage from the **end of the
last active subscription** (not from today), so users don't lose days.

## Expiry

Daily cron `botLicenseReminder` warns dealers approaching expiry:

- 7, 3, 1 days before `ACTIVE_TO` — Telegram + SMS notification.
- After expiry — `Diler::refresh()` flips the licence file (consumed by
  `sd-main`).

### License renewal + expiry notify (flowchart)

`BotLicenseReminderCommand::run` in
`protected/commands/BotLicenseReminderCommand.php` selects active
`Diler` rows (status 10, non-SMPRO, country not in 7/9/10) which
**don't** currently hold an active `bot_report` `Subscription`, then
hits each dealer's `https://{host}/api/billing/telegramLicense` with up
to three retries; the first 200 response writes a per-host stamp file
that prevents repeat sends that day.

```mermaid
flowchart LR
  CR(["09:00 cron<br/>botLicenseReminder"]) --> Q["SELECT Diler<br/>NOT EXISTS active bot_report Subscription"]
  Q --> EMP{"rows?"}
  EMP -- "no" --> DONE(["log + end"])
  EMP -- "yes" --> LOOP["per dealer: build URL<br/>{DOMAIN}/api/billing/telegramLicense"]
  LOOP --> SENT{"stamp file<br/>exists today?"}
  SENT -- "yes" --> SKIP(["skip"])
  SENT -- "no" --> POST["curl POST"]
  POST --> CODE{"http_code == 200?"}
  CODE -- "no, try≤3" --> POST
  CODE -- "no, try>3" --> ERR(["write error log"])
  CODE -- "yes" --> OK(["write success stamp"])

  class CR cron
  class Q,LOOP,POST action
  class EMP,SENT,CODE approval
  class ERR reject
  class OK,DONE,SKIP success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## Bonus packages

`Subscription` rows can be marked `is_bonus = true` (free seat grants).
They count toward licence checks but don't bill against `BALANS`.

## All-packages mode (`MONTHLY=15`)

If `Diler.MONTHLY = 15`, the dealer is on an "all packages" plan. The
licence file gates by global expiry rather than per-package
`SUBSCRIP_TYPE`.
