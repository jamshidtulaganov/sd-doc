---
sidebar_position: 1
title: API overview
---

# API overview

There are **four versioned API surfaces**, each a separate Yii module:

| Version | Module | Audience | Status |
|---------|--------|----------|--------|
| **v1** | `api` | Legacy server-to-server, partner integrations | Maintenance |
| **v2** | `api2` | Older mobile clients | Frozen |
| **v3** | `api3` | **Current mobile agent app** | Active |
| **v4** | `api4` | **B2B / online order portal / new mobile clients** | Active |

URLs follow the pattern `/<module>/<controller>/<action>`. Examples:

- `POST /api3/login/index`
- `GET  /api3/order/list`
- `POST /api4/order/create`
- `POST /api/json1c/import`

## Conventions

- **Transport**: HTTPS only (TLS terminated at Nginx).
- **Auth**: token-based (`api3` / `api4`); shared-secret or basic auth for
  some v1 endpoints. See [Authentication](./authentication.md).
- **Format**: JSON request/response. v1 has a few XML endpoints
  (`xml1c`, `pradata`).
- **Date/time**: ISO 8601 in UTC unless an endpoint specifies otherwise.
- **Errors**: HTTP status + JSON body
  ```json
  { "success": false, "error": "Описание ошибки", "code": "INVALID_TOKEN" }
  ```
- **Pagination**: query params `?page=N&limit=M`. Response includes
  `total`, `page`, `limit`.
- **Locale**: `?lang=ru|en|uz` overrides the user default.
- **Rate limit**: per-IP at the gateway. App-level rate limit on auth
  endpoints (`LoginController` throttles failed attempts).

## Versioning policy

- **v3 and v4 are stable**. Breaking changes ship as new endpoints, never
  in-place.
- **v1 and v2 are frozen** — the `*.obsolete` files in their controllers
  are removed code retained for archaeology.

## Quick map

- [Authentication](./authentication.md)
- [API v1 reference](./api-v1.md)
- [API v2 reference](./api-v2.md)
- [API v3 (mobile agent)](./api-v3-mobile/)
- [API v4 (online / B2B)](./api-v4-online/)
- [Error codes](./error-codes.md)
- [Webhooks](./webhooks.md)
