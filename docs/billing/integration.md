---
sidebar_position: 2
title: Integration with sd-main & sd-cs
---

# Integration with sd-main & sd-cs

## Licence delivery

```http
GET https://<dealer>.salesdoc.io/api/billing/license
Source-IP: 185.22.234.226 (Billing server)
```

Behaviour:

1. Deletes every file in `protected/license2/`.
2. Returns 200 + JSON with status.
3. Billing then PUTs the new licence file (mechanism TBD when source is
   shared).

The `if (Http::getRemoteAddress() == "185.22.234.226")` check in
`BillingController` is the **only** authentication today; this should be
upgraded to a signed token.

## Status check (sd-cs)

```http
POST https://<hq>.salesdoc.io/api/billing/status
{ "app": "sdmanager" }
```

Response:

```json
{
  "status": "success",
  "url": "https://<host>",
  "code": "<first-subdomain-token>",
  "type": "countrysale"
}
```

Used by Billing to verify the HQ is reachable.

## Licence consumption

Login (`api3 LoginController`) calls
`User::hasSystemActive($systemId)`. The check loads the latest licence
file from `protected/license2/` and asserts the (system, expiry, seat
count) tuple.

System IDs:

| ID | System |
|----|--------|
| 1 | Web admin |
| 2 | Audit |
| 4 | Mobile agent |
| 5 | Online store |

If the licence is missing or expired, login responds:

```json
{ "success": false, "error": "Срок лицензии программы истёк" }
```

## Failure modes

- **Licence push fails** — sd-main keeps using the previous licence
  until expiry. Plan a "grace period" config knob.
- **Billing unreachable** — sd-cs status pings will fail; Billing's UI
  shows the HQ as offline. No customer-visible impact.
- **Mass licence revocation** — equivalent to deleting `license2/*`
  across all tenants. Avoid; prefer per-tenant freezes.

## Hardening checklist

- Replace IP allowlist with mutual TLS or signed JWT.
- Move licence files out of the web root.
- Add a `/api/billing/healthz` endpoint that returns version + last
  licence applied.
- Audit-log every licence change.
