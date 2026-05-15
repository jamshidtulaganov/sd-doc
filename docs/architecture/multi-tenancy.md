---
sidebar_position: 3
title: Multi-tenancy
---

# Multi-tenancy

SalesDoctor uses **DB-per-customer** multi-tenancy with **subdomain routing**.

## Tenant resolution

```
https://{tenant}.salesdoc.io/orders/list
                ↑
                Nginx vhost → tenant project root (a symlink in /var/www/{tenant})
                            → tenant-specific main_local.php overrides db
                              connection string → tenant DB is selected
```

The active database is **identified, not resolved, by `TenantContext`**.
`TenantContext::getTenantId()` runs `SELECT DATABASE()` once per request
and memoises the result (`protected/components/TenantContext.php:56-78`).
There is no host-to-database lookup table in code — the binding is set up
externally at provisioning time via the tenant-specific `main_local.php`.

Two granularities:

- **Tenant** — corresponds to one **MySQL database**. Names typically
  follow `<tenant>`, e.g. `novus_db`, `test200`, `sd_main`. The repo's
  committed `main.php` defaults to `mysql:host=db;dbname=sd_main` for
  the dev compose stack.
- **Filial** (branch) — a row inside the tenant DB. Multiple filials can
  share one tenant database; data is tagged with `FILIAL_ID`. Resolved by
  `FilialComponent` / `BaseFilial::setFilial()` for CLI runs.

`TenantContext` exposes (verified shape):

```php
Yii::app()->tenantContext->getTenantId()  // returns current DB name (string) or null
Yii::app()->tenantContext->tenantCache()  // ScopedCache prefixed with "t:{db}:"
Yii::app()->tenantContext->filialCache()  // ScopedCache prefixed with "t:{db}:f:{id}:"
```

Both cache accessors return `null` if the tenant id cannot be resolved
(e.g. DB error); callers MUST handle null and fall back to the source of
truth. See `TenantContext.php:84-100`.

## Queue + multi-tenancy

`QueueCommand` (`protected/commands/QueueCommand.php`) runs as a single
**global worker** that dispatches jobs to the right tenant project. The
flow:

1. The dispatch site (any tenant request handler) calls
   `MyJob::dispatch([...])`. `BaseJob` auto-injects `project_path` and
   `http_host` into the payload (`protected/components/jobs/README.md`).
2. The global worker pops the job, runs `autoProvisionProject($httpHost)`
   to find `/var/www/{httpHost}/`, and validates the project path
   (`realpath`, presence of `protected/` + `console.php`, optional
   `.queue-enabled` marker — currently commented out).
3. For remote tenants the worker shells out to
   `php {projectPath}/console.php internal execute --payload=<base64>`
   under a hard `timeout -s 9 {jobTimeout+5}s` system kill (line 236).
4. Local jobs (same project) bypass the shell and run via
   `runJobLocally()`.

This is what lets one worker fleet serve 2000+ tenants without per-tenant
worker pools, but it puts strong **security validation** on payloads —
see the class name `preg_match('/^[a-zA-Z_][a-zA-Z0-9_]*$/')` check
applied four separate times in `QueueCommand.php`.

## Caching strategy

Redis db2 is the application cache. Keys are namespaced so invalidation
fires across the right granularity:

| Scope | Key shape | Invalidates |
|-------|-----------|-------------|
| Tenant | `t:{db}:filial-list` | Every filial of that tenant |
| Filial | `t:{db}:f:{id}:authitem` | Only that filial |
| User | `t:{db}:f:{id}:u:{uid}:perms` | Only that user |

**Rule**: never write directly to `Yii::app()->cache`. Always go through
`ScopedCache` so the right prefix is applied.

## Sessions

`CCacheHttpSession` over Redis db0 (`session.cacheID = redis_session` in
`main_static.php`). The `redis_session` component's `keyPrefix` is
`HTTP_HOST + ':'` (line 89), which gives each subdomain a fully isolated
session pool. CLI runs use the literal prefix `cli:`.

## Adding a new tenant

1. Provision MySQL DB:
   ```sql
   CREATE DATABASE sd_newcustomer DEFAULT CHARSET utf8;
   ```
2. Apply schema (load the latest dump or run migrations).
3. Insert the tenant row in the registry table.
4. Add subdomain DNS + Nginx vhost (or use a wildcard cert).
5. Smoke test: log in, create one order, verify cache keys are scoped.

## Anti-patterns

- ❌ Hard-coding `sd_main` anywhere. Always read the live database name
  via `Yii::app()->tenantContext->getTenantId()`.
- ❌ Sharing Redis keys across tenants without a prefix.
- ❌ Cron jobs that don't loop over tenants — see
  [Jobs and scheduling](./jobs-and-scheduling.md) for the right pattern.
- ❌ Dispatching a `BaseJob` without a tenant context. `dispatch()`
  reads the current `HTTP_HOST` / project path; CLI dispatch must set
  these manually or the global worker will route the job to the wrong
  tenant.

## Diler model (the tenant registry row)

`protected/models/Diler.php` (model class `Diler extends BaseFilial`) is
the per-tenant configuration record. It carries the tenant business
identity — `INN`, `BANK`, `ACCOUNT`, `DIRECTOR`, `PRICE_TYPE`, etc.
There is **one row per filial** in the tenant DB. There is no
cross-tenant "Diler" registry — provisioning still flows through the
external infra (DNS + nginx vhost + `main_local.php`).
