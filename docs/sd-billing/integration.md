---
sidebar_position: 10
title: Integration with sd-main & sd-cs
---

# Integration with sd-main & sd-cs

`sd-billing` is upstream of every dealer's `sd-main` and every HQ's
`sd-cs`. The integration surface is small and **one-directional**:
sd-billing pushes to dealers; dealers do read-only licence checks back.

```mermaid
sequenceDiagram
  participant B as sd-billing
  participant M as sd-main (dealer)
  participant C as sd-cs (HQ)

  Note over B,M: Subscription purchase
  M->>B: api/license/buyPackages (UserIdentity sd/sd)
  B->>B: validate, charge BALANS, insert Subscription
  B-->>M: 200 + new licence file payload
  M->>M: write protected/license2/<licence>
  Note over B,C: Periodic status pings
  B->>C: api/billing/status?app=sdmanager
  C-->>B: { status:success, url, code }
  Note over B,M: Phone directory sync
  B->>M: api/billing/phone (sync)
  M->>M: User.TEL updates from Spravochnik
  Note over B,M: Licence expiry
  B->>M: api/billing/license (DELETE)
  M->>M: clear protected/license2/*
```

## Endpoints exposed by sd-main (called by sd-billing)

| Endpoint | Purpose |
|----------|---------|
| `GET /api/billing/license` | Trigger licence-file refresh (clears `protected/license2/*` so a new one can land). IP-restricted to `185.22.234.226`. |
| `POST /api/billing/phone` | Sync phone numbers for agents and expeditors from the Spravochnik master. |
| `/dashboard/billing` | Internal billing UI inside sd-main; reads licence info. |

## Endpoints exposed by sd-cs (called by sd-billing)

| Endpoint | Purpose |
|----------|---------|
| `GET/POST /api/billing/status?app=sdmanager` | Liveness / capability check. Returns `{ status:"success", url, code, type:"countrysale" }`. |

## Endpoints exposed by sd-billing (called by sd-main)

The dealer's `sd-main` mostly pulls licence info on login. The
authoritative API is in `sd-billing/protected/modules/api/`:

| Endpoint | Purpose |
|----------|---------|
| `POST /api/license/buyPackages` | Buy / renew packages |
| `POST /api/license/exchange` | Special "swap one package for another" |
| `GET /api/license/info` | Dealer's current entitlements |
| `POST /api/host/heartbeat` | Dealer reports it's alive (some flows) |

Several of these log in via `new UserIdentity("sd","sd")` — **fix as
part of the auth hardening track**.

## Identifiers

- **`Diler.HOST`** in sd-billing = the dealer's `sd-main` hostname.
- **`Diler.DILER_ID`** = primary integration key. Mirror it into
  `sd-main` config and into `sd-cs` directory rows.
- **Licence files** stored in
  `sd-main/protected/license2/<diler-id>.license` (or similar).

## Failure modes

| Scenario | Effect |
|----------|--------|
| Licence push fails | Dealer keeps the previous licence until expiry. Add grace-period config. |
| sd-billing → sd-cs ping fails | Billing dashboard shows HQ as offline. No customer-visible impact. |
| Mass licence revocation | Equivalent to deleting `license2/*` everywhere. Avoid; prefer per-tenant freezes. |

## Hardening checklist

- Replace IP allowlist with mutual TLS or signed JWT.
- Move licence files outside the web root.
- Add `/api/billing/healthz` returning version + last licence applied.
- Audit-log every licence change (see `IntegrationLog` pattern in
  sd-main).
- Replace `UserIdentity("sd","sd")` machine logins with API tokens.

## SMS workflows

### SMS package buy

`SmsController::actionBuySmsPackage` in
`protected/modules/api/controllers/SmsController.php` (around line 127)
charges a `Diler` for a `SmsPackage`. After resolving the `Diler` by
`object_id` or `host`, it asserts `BALANS >= PRICE`, writes
`SmsBoughtPackage`, then a sibling `Service` row of `TYPE_DILER`
status `DONE`, and finally a `BoughtPackage` joining them. The closing
`$dealer->deleteLicense()` propagates the new balance back to the
dealer's `sd-main`.

```mermaid
sequenceDiagram
  participant SM as sd-main (dealer)
  participant API as api/sms/buySmsPackage
  participant DB as MySQL
  participant D as Diler

  SM->>API: POST {package_id, host, sd_id, sd_login, type=dealer}
  API->>DB: SmsPackage active?
  API->>D: Diler by id or HOST
  API->>API: BALANS >= PRICE?
  alt insufficient
    API-->>SM: not_enough_balance
  else ok
    API->>DB: INSERT SmsBoughtPackage
    API->>DB: INSERT Service (TYPE_DILER, DONE)
    API->>DB: INSERT BoughtPackage (joins)
    API->>D: deleteLicense()
    API-->>SM: success [{id, name, count, ...}]
  end
```

### SMS send + forward

`SmsController::actionSend` and `actionSendingForward` are the two
inbound entry points from a dealer's `sd-main`. `actionSend` validates
the dealer's remaining SMS limit by summing `SmsBoughtPackage.getLimit()`
across non-deleted packages where the dealer id appears in
`DEALERS`. `actionSendingForward` is the lighter variant used when the
dealer already authorised the batch — it skips the limit math and
delegates straight to `Sms::multy`.

```mermaid
sequenceDiagram
  participant SM as sd-main
  participant API as api/sms
  participant DB as MySQL
  participant SMS as Sms component<br/>(Eskiz/Mobizon)

  SM->>API: POST /send {type, object_id, host, messages}
  API->>API: hasAccessIpAddress() check
  API->>DB: load SmsBoughtPackage rows (USED_LIMIT != SMS_LIMIT)
  API->>API: maxSmsLimit ≥ countSMS?
  alt over limit
    API-->>SM: fail "недостаточно SMS"
  else ok
    API->>SMS: Sms::multy(messages, host)
    SMS-->>API: status, response
    API-->>SM: success {left_sms_limit, status}
  end
  Note over API: actionSendingForward skips<br/>limit math and calls multy() directly
```

### SMS delivery callback

`SmsController::actionCallback` is the DLR webhook receiver. It logs
the raw params to `log/sms-callback-all.json`, resolves the `Diler` by
`HOST`, and on `status=DELIVERED` increments
`SmsBoughtPackage.USED_LIMIT` across the dealer's active packages
(packing `sms_count` greedily). For both `DELIVERED` and `REJECTED`
the controller forwards the original payload to
`{Diler.DOMAIN}/sms/callback/item` so sd-main can update its own
`SmsMessage` rows.

```mermaid
sequenceDiagram
  participant P as Provider (Eskiz/Mobizon)
  participant API as api/sms/callback
  participant DB as MySQL
  participant SM as sd-main /sms/callback/item

  P->>API: POST DLR {host, status, sms_count, ...}
  API->>API: Logger::writeLog (sms-callback-all.json)
  API->>DB: find Diler by HOST
  alt status == DELIVERED
    API->>DB: load active SmsBoughtPackage rows
    loop pack sms_count
      API->>DB: USED_LIMIT += min(left, smsCount)
    end
  end
  alt status in (DELIVERED, REJECTED)
    API->>SM: POST {host, status, ...}
    SM-->>API: 2xx
  end
```

## See also

- [sd-main billing-integration surface (legacy redirect)](/docs/billing/overview)
- [Subscription flow](./subscription-flow.md)
- [Cron & settlement](./cron-and-settlement.md)
- [Security landmines](./security-landmines.md)
