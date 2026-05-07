---
sidebar_position: 5
title: Data isolation
---

# Data isolation between tenants

Three layers stack to keep tenants apart:

1. **Network** — each subdomain is its own vhost; CORS is closed for
   cross-subdomain calls.
2. **Database** — DB-per-tenant. `TenantContext` selects the DB on every
   request; there is no fall-through.
3. **Cache** — every key in `redis_app` is prefixed with `t:{db}:` (and
   `f:{filial}:` for filial-scoped data) so cross-tenant key collisions
   are structurally impossible.

## Threat model

The realistic attacks we defend against:

- **Compromised tenant credentials** → can only see their own DB.
- **Compromised app process** → if PHP RCE, the attacker could read all
  tenants. Defence: WAF + container sandbox + minimal mounted secrets.
- **Stale cache after a delete** → at most 600 s of stale RBAC; orders /
  payments are never cached.

## Anti-patterns

- ❌ `Yii::app()->cache->get(...)` directly — bypasses the tenant prefix.
- ❌ Hard-coded `connectionString` referencing a default DB.
- ❌ Cron job loops over all tenants but writes to a single shared cache
  key.
