---
sidebar_position: 7
title: Auth & access
---

# Auth & access (sd-billing)

Two layers of access control live side-by-side:

## 1. Session login

`PhpAuthManager` + `WebUser` + `UserIdentity` — classic Yii session
auth. Password storage is **MD5(plaintext)** — a known landmine. See
[security landmines](./security-landmines.md).

## 2. Bit-flag access grid

`Access::has($operation, $type_access)` checks per-user permissions
against `d0_access_user` with bit flags:

```
DELETE = 8
SHOW   = 4
UPDATE = 2
CREATE = 1
```

`Access::check()` throws `CHttpException(403)` on miss. Two
short-circuits:

- `User.IS_ADMIN = 1` — bypasses all checks.
- `User.ROLE = ROLE_ADMIN (3)` — bypasses all checks.

## Roles

Defined as `User::ROLE_*` constants:

| ID | Name |
|----|------|
| 3 | `ADMIN` |
| 4 | `MANAGER` |
| 5 | `OPERATOR` |
| 6 | `API` |
| 7 | `SALE` |
| 8 | `MENTOR` |
| 9 | `KEY_ACCOUNT` |
| 10 | `PARTNER` |

## Partner restrictions

`PartnerAccessService::checkAccess` limits `ROLE_PARTNER` to:

- the `partner` module
- the `directory` module
- `dashboard/dashboard/index`
- `site/*`

The check is **currently commented out** in
`protected/components/Controller.php:63` — meaning partners can hit
more than they should until that line is uncommented. Treat as a
high-priority security item.

## API authentication

API endpoints use mixed schemes:

| Controller | Auth |
|------------|------|
| `LicenseController` | Hard-coded `TOKEN` constant in the file |
| `ClickController` | Click-style sign verification |
| `PaymeController` | Payme HMAC header |
| `PaynetController` | SOAP / WS-Security in `paynetuz` extension |
| Several others | `new UserIdentity("sd","sd")` — fixed user login |

Migrate hard-coded tokens to environment variables and rotate after
publication.

## Sessions

Yii default `CHttpSession` (file-backed). Consider moving to a DB- or
Redis-backed session if you horizontally scale this app.

## Logging-out

`SiteController::actionLogout` destroys the session. There is no
device-token concept here — sd-billing is web-admin only.

## Rate limiting

Not implemented. Login throttling and IP-based limits are recommended
hardening — currently rely on the WAF in front.
