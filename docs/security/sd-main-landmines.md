---
sidebar_position: 6
title: sd-main security landmines
---

# sd-main security & operational landmines

This page mirrors [sd-billing security landmines](../sd-billing/security-landmines.md) for the **sd-main** dealer CRM. Items are findings from the 2026-05 documentation audit, grounded in source reads at `/Users/jamshid/projects/salesdoctor/sd-main`. Each row lists severity, where it lives, and the target fix.

| # | Issue | Severity | Where | Target fix |
|---|-------|----------|-------|------------|
| 1 | **MD5 password hashing — no bcrypt fallback** | Critical | `protected/components/UserIdentity.php:26` (`md5($this->password) === $user->PASSWORD`); `protected/models/User.php:199, 208` (writes `md5($PASSWORD)`); `User.php:449` (validation) | Migrate to `password_hash()` (bcrypt). Transparent upgrade on next successful login. The previous claim in `auth-and-roles.md` that "bcrypt for new users" was active was incorrect. |
| 2 | **Zero project tests** | High | `composer.json` has no PHPUnit; the only `*Test.php` files are vendored from `Gumlet\ImageResize` under `protected/extensions/image2/test/` and aren't wired into anything | Bring up phpunit; start with `OrderService` transitions and the per-line defect / whole-order reject distinction (see `api/api-v3-mobile/index.md`). |
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

## Landmines discovered via Phase 1 harvest

These were surfaced by the Playwright crawler (`scripts/harvest-live.mjs`,
output `static/data/pages.json`, 72 admin URLs) and by walking
`static/data/routes.json` (2,788 controller actions). Each item is
reproducible from those artifacts.

### L8 — `/stock/purchase/refund` returns HTTP 500

| Field | Value |
|-------|-------|
| Severity | High |
| Where | `stock/PurchaseController::actionRefund` (see `protected/modules/stock/controllers/`) |
| Symptom | `CDbException` page on every admin role observed during harvest. `pages.json` records `status: 500, title: "CDbException"` |
| Likely cause | Schema drift — the action references a column or table that has not been added to the demo DB. Repro by visiting `/stock/purchase/refund` while logged in. |
| Action | Open the page in dev; capture the failing SQL from the stack trace; add the missing migration or guard the query. Until fixed, the **Refund** button on the purchase list lands users on a 500 page. |

### L9 — Unrendered Vue templates leak to the page (i18n placeholders)

| Field | Value |
|-------|-------|
| Severity | Medium |
| Where | `/orders/view/onMap` and other Angular/Vue-island routes. Strings of the form `{{ $t('orders.label') }}` reach the DOM verbatim when the Vue bundle has not been initialised for a region of the page. |
| Why | Some Angular pages embed Vue islands without waiting for the Vue runtime to attach. If the template is rendered server-side first, the curly braces appear as literal text. |
| Action | Either (a) hide the placeholder container until the Vue mount fires (`v-cloak` + CSS), or (b) move to a pure-Angular implementation. Quick win: scan the page DOM for `{{ ` and add a `v-cloak` rule before merging new Vue islands. |

### L10 — Russian labels mixed with i18n placeholders

| Field | Value |
|-------|-------|
| Severity | Low |
| Where | Multiple admin pages; visible in `pages.json` field labels. Examples in `orders_view_onMap`: `"Тип заявки"`, `"Статус"`, `"Экспедитор"` exist as raw Russian alongside `Yii::t(...)` calls in the same view file. |
| Why | Pages were translated piecewise. The Russian forms survive in templates that were never run through `Yii::t('app', '...')`. |
| Action | Add a CI grep for non-ASCII letters in `protected/modules/*/views/**/*.php` outside `Yii::t()` calls; fail the build on first finding once the existing backlog is cleared. |

### L11 — 2,281 of 2,788 routes have no RBAC tag

| Field | Value |
|-------|-------|
| Severity | High |
| Where | `static/data/routes.json` — `rbac == null` on 2,281 routes (82%). Examples include user-facing pages like `audit/dashboard/index`, `clients/stock/index`, `adt/reports/index`. |
| Why | These routes rely on `accessControl()` filters on the controller class, on session-only gating, or on **nothing at all**. The harvest walker only extracts explicit `@AccessControl` / `controllers[]` lookups; anything else shows as `null`. |
| Caveats | Not every `null` is a bug — many are pure-internal AJAX endpoints behind authenticated pages. But the **untagged set includes pages reachable by URL guess**, and 100% of `api/*` integration endpoints (Json1C, Mef1c, SmartUp, Push, TelegramBot, Didox, Faktura) are tagged `noRbac` — they rely on **shared-secret tokens in the URL or header**, not on the RBAC layer. |
| Action | Cross-walk `routes.json` against `accessControl()` per controller; flag the residual pages without either. Add a regression test that any route under `protected/modules/*/controllers/*.php` either has `@AccessControl` or is explicitly listed on an allow-list. |

### L12 — `gii` module shipped in production config

| Field | Value |
|-------|-------|
| Severity | Medium |
| Where | `protected/config/main_static.php:56-61` — `gii` registered with `password => '123456'`, `ipFilters => ['127.0.0.1', '::1']` |
| Why | Gii is Yii's code generator. The IP filter restricts it to localhost, which is *usually* safe, but the password is hard-coded and committed. If nginx ever forwards traffic with `X-Forwarded-For` stripped or if the listener binds outside `127.0.0.1` accidentally, Gii is exposed with a trivial password. |
| Action | Remove the `gii` module from the production module list. If devs need it locally, gate it on `YII_ENV === 'dev'` or move it into `main_local.php`. |

### L13 — Queue worker recovers `console.php` by copying from a hard-coded path

| Field | Value |
|-------|-------|
| Severity | Medium |
| Where | `protected/commands/QueueCommand.php:419` — when a tenant's `console.php` is missing, the worker copies from `/var/www/novus/data/www/novus.salesdoc.io/console.php`. |
| Why | Convenience for ops, but it means **every tenant runs the `novus` build of `console.php`** the moment their own one disappears (rm, failed deploy, symlink swap). |
| Action | Replace with a hard fail + alert; force the operator to re-deploy that tenant. Or template the path through a config constant. |

### L14 — `.queue-enabled` marker check is commented out

| Field | Value |
|-------|-------|
| Severity | Low |
| Where | `protected/commands/QueueCommand.php:432-435` |
| Why | The README at `protected/components/jobs/README.md` promises that only tenants with `.queue-enabled` will receive remote jobs. The actual check is commented out, so any tenant directory with a valid Yii layout will accept a dispatched job. |
| Action | Re-enable the marker check **or** delete the unfulfilled promise from the README to avoid lulling deployers into a false sense of isolation. |

## See also

- [sd-billing security landmines](../sd-billing/security-landmines.md) — the sister project's landmine page; some items overlap.
- [security/auth-and-roles](./auth-and-roles.md) — current MD5 status documented under password policy.
- [quality/testing](../quality/testing.md) — actual test state (none).
- [devops/deployment](../devops/deployment.md) — actual deploy state (manual).
- [architecture/multi-tenancy](../architecture/multi-tenancy.md) — Queue + tenant routing context for L13/L14.
- [/docs/ui/pages](../ui/pages/) — harvested pages used to surface L8–L10.
