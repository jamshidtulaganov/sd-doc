---
sidebar_position: 6
title: sd-main security landmines
---

# sd-main security & operational landmines

This page mirrors [sd-billing security landmines](../sd-billing/security-landmines.md) for the **sd-main** dealer CRM. Items are findings from the 2026-05 documentation audit, grounded in source reads at `/Users/jamshid/projects/salesdoctor/sd-main`. Each row lists severity, where it lives, and the target fix.

| # | Issue | Severity | Where | Target fix |
|---|-------|----------|-------|------------|
| 1 | **MD5 password hashing — no bcrypt fallback** | Critical | `protected/components/UserIdentity.php:26` (`md5($this->password) === $user->PASSWORD`); `protected/models/User.php:199, 208` (writes `md5($PASSWORD)`); `User.php:449` (validation) | Migrate to `password_hash()` (bcrypt). Transparent upgrade on next successful login. The previous claim in `auth-and-roles.md` that "bcrypt for new users" was active was incorrect. |
| 2 | **Zero project tests** | High | `composer.json` has no PHPUnit; the only `*Test.php` files are vendored from `Gumlet\ImageResize` under `protected/extensions/image2/test/` and aren't wired into anything | Bring up phpunit; start with `OrderService` transitions and the per-line defect / whole-order reject distinction (see `api/api-v3-mobile.md`). |
| 3 | **No CI** | High | No `.github/workflows/`, no `.gitlab-ci.yml`, no test-runner config | Wire phpunit (#2) into CI. Add a lint check for Mermaid diagrams (see `package.json` `lint:mermaid` in sd-docs). |
| 4 | **No application healthcheck endpoint** | Medium | No `/healthz`, `actionHealth`, or `actionPing` route anywhere in `protected/`. The smoke-test in the previous deployment doc that referenced `GET /healthz` was wishful. | Add a minimal `SiteController::actionHealthz` returning 200 + DB-ping JSON. Add to nginx allow-list for k8s/orchestrator probes. |
| 5 | **No deploy automation** | Medium | No `deploy.sh`, no `Makefile`, no `infra/smoke.sh`, no `.github/workflows/deploy*` | Document the actual rollout (now in `devops/deployment.md`). Add a `bin/deploy` script that codifies it. |
| 6 | **Hardcoded dev credentials in docs** | Low | `docs/project/local-setup.md` ships `jamshid / secret` for MySQL and `root / root` for phpMyAdmin | Switch to a neutral placeholder (`sd_dev / sd_dev`) and reference an `.env.example`. |
| 7 | **PHP 7.3 EOL** | High | `Dockerfile` pins PHP 7.3 (security patches stopped Dec 2021) | See [ADR 0001 — keep Yii 1](../adr/yii1-stay.md) for the upgrade path to PHP 8.2 with a compat-patched Yii 1.1. |

## Reporting flow

When you discover a new issue:

1. Open a ticket in the project tracker (label `security`).
2. If exploitable in production, mark **P0** and ping the security channel before merging the fix.
3. Add a regression test before fixing — but see #2 above (you may need to wire up PHPUnit first).
4. Add a row to this table with status (Open / In progress / Closed).

## Defence-in-depth (current state)

While the above items are open, compensating controls reduce risk:

- WAF in front of all sd-main endpoints.
- Subdomain-isolated session pools (`HTTP_HOST` prefix on `redis_session`).
- Per-tenant DB isolation (DB-per-customer, see [Multi-tenancy](../architecture/multi-tenancy.md)).
- IP allow-list on `api/billing/license` (single-IP today; see sd-billing landmine #4).

## Don'ts

- ❌ Don't add new MD5 password columns or paths.
- ❌ Don't add new endpoints under `api/` or `api2/` — they're frozen. Use `api3` (mobile) or `api4` (online).
- ❌ Don't ship dev credentials in committed config files.
- ❌ Don't claim a healthcheck endpoint exists in deploy/runbook docs until #4 is closed.

## See also

- [sd-billing security landmines](../sd-billing/security-landmines.md) — the sister project's landmine page; some items overlap.
- [security/auth-and-roles](./auth-and-roles.md) — current MD5 status documented under password policy.
- [quality/testing](../quality/testing.md) — actual test state (none).
- [devops/deployment](../devops/deployment.md) — actual deploy state (manual).
