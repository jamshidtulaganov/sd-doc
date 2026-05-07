---
sidebar_position: 9
title: Security landmines
---

# Security landmines (and remediation)

This page is **internal-only** but lives in the docs so contributors
see it. Each item lists severity, where the issue lives, and the
target fix. The source of truth for status is
`sd-billing/doc/IMPROVEMENTS.md`.

| # | Issue | Severity | Where | Target fix |
|---|-------|----------|-------|------------|
| 1 | **MD5 password hashing** | Critical | `UserIdentity::authenticate`, `User::generatePassword` (sd-billing only — sd-main's status: see [security/auth-and-roles](../security/auth-and-roles.md)) | Migrate to `password_hash()` (bcrypt). Transparent upgrade on next successful login. |
| 2 | **Hardcoded SMS / Telegram secrets in code** | Critical | `protected/components/Sms.php` (Eskiz creds, Mobizon API key); `SiteController::actionLogin` (Telegram bot token) | Move to env vars; rotate the publicly-leaked tokens immediately. |
| 3 | **`Distr::getFilter()` is SQL-injectable** | Critical | string-interpolates user data | Migrate callers to `protected/helpers/QueryBuilder.php`. Don't extend `Distr::getFilter()`'s surface in the meantime. |
| 4 | **`Controller::hasAccessIpAddress()` short-circuits** | High | The first line is `return true;`, the IP allowlist below is unreachable. | Replace with a real allowlist check; add tests. |
| 5 | **`YII_DEBUG = true` in `index.php`** | High | Stack traces leak in production responses. | Drive from env (`YII_DEBUG=getenv('APP_DEBUG')`). |
| 6 | **`Curl::run` uses `CURLOPT_TIMEOUT => 0`** | Medium | Outbound calls can hang forever. | Set sensible defaults (15 s) + retry. |
| 7 | **`composer.lock` without `composer.json`** | Medium | Dependency state non-reproducible. | Reconstruct `composer.json` (Phase 0 of `doc/TESTING_PLAN.md`). |
| 8 | **Partner access check commented out** | High | `protected/components/Controller.php:63` | Uncomment; verify with tests. |
| 9 | **License `TOKEN` is a hard-coded constant** | High | `protected/modules/api/controllers/LicenseController.php` | Move to env; rotate; add per-source signing. |
| 10 | **Test coverage is being built up** | n/a | Treat untested paths as high-risk. | Follow `doc/TESTING_PLAN.md`. |

## Reporting flow

When you discover a new issue:

1. Open a ticket in the project tracker (label `security`).
2. If exploitable in production, mark **P0** and ping the security
   channel before merging the fix.
3. Add a regression test before fixing (per CLAUDE.md §7 hard rule).
4. Add a row to `doc/IMPROVEMENTS.md` with status (Open / In progress /
   Closed).

## Defence-in-depth (current state)

While the above items are open, compensating controls reduce risk:

- WAF in front of all sd-billing endpoints.
- Frequent OS-level patching of the container hosts.
- Network-level allowlist for `api/license` callers.
- Read-only DB user for analytical replicas.

## Don'ts

- ❌ Don't introduce another MD5 password column.
- ❌ Don't add new hard-coded secrets.
- ❌ Don't extend `Distr::getFilter()` callers — migrate them.
- ❌ Don't paste Telegram bot tokens or Eskiz creds in tickets, Slack,
  or PR descriptions.
