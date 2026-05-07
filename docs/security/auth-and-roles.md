---
sidebar_position: 2
title: Auth & roles
---

# Authentication & roles

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
- Active hashing: MD5 (legacy) for old users; bcrypt for new. Migration
  is opportunistic on next successful login.
- No common-password list; this is a planned improvement.

## Failure handling

- 5 consecutive failed logins for a login → 1-minute lockout.
- 30 failed logins from an IP in 10 minutes → IP throttled at the gateway.
