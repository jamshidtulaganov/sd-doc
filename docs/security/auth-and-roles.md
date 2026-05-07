---
sidebar_position: 2
title: Auth & roles
---

# Authentication & roles

:::note Scope
This page documents roles in **sd-main** (the dealer CRM). The numeric role IDs here are NOT the same as the role IDs in [sd-billing](../sd-billing/auth-and-access.md), even though the integers overlap. When a sd-main module page says "Approve: 1, 2, 9", refer to the table on this page.
:::

## Roles (canonical)

Defined in `protected/config/auth.php`:

| ID | Role | Notes |
|----|------|-------|
| 1 | Super Administrator | All filials, all features |
| 2 | Administrator Filial | One filial, full feature set |
| 3 | Diler | Dealer, restricted admin |
| 4 | Agent | Mobile sales agent |
| 5 | Operator | Backoffice operator |
| 6 | Kassir | Cashier |
| 7 | Partner | External partner access |
| 8 | Supervayzer | Supervisor / team lead |
| 9 | Manager | Sales manager |
| 10 | Expeditor | Delivery |
| guest | Guest | Anonymous |

The hierarchy is partial: `1 → 2 → 3 → 4 → guest`. Roles 5–10 inherit
only from `guest` and rely on per-permission grants in `authassignment`.

## Authentication paths

| Surface | Mechanism |
|---------|-----------|
| Web admin | session cookie + `WebUser` |
| Mobile app | Bearer token via `LoginController` (api3) |
| Online portal / WebApp | Bearer token via api4 + Telegram-signed init |
| Server-to-server | Shared secret per integration |

## Password policy

- Minimum length **8** at create / change time.
- Hashing (per-account): **MD5 only** — both `UserIdentity::authenticate`
  and `User::validatePassword` compare `md5($plain)` against the stored
  `PASSWORD` column. Migration to `password_hash()` (bcrypt) is pending.
- No common-password list; this is a planned improvement.

## Failure handling

- 5 consecutive failed logins for a login → 1-minute lockout.
- 30 failed logins from an IP in 10 minutes → IP throttled at the gateway.
