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
                HTTP_HOST → TenantContext.resolveByHost()
                          → returns { db: "sd_acme", filialId: 7 }
```

Two granularities:

- **Tenant** — corresponds to one **MySQL database** (`sd_<tenant>`).
- **Filial** (branch) — a row inside the tenant DB. Multiple filials can
  share one tenant database; data is tagged with `FILIAL_ID`.

`TenantContext` exposes:

```php
Yii::app()->tenantContext->db            // 'sd_acme'
Yii::app()->tenantContext->filialId      // 7
Yii::app()->tenantContext->scoped()      // ScopedCache for tenant
Yii::app()->tenantContext->scopedFilial()// ScopedCache for filial
```

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

`CCacheHttpSession` over Redis db0. The `keyPrefix` is `HTTP_HOST` which
gives each subdomain a fully isolated session pool.

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

- ❌ Hard-coding `sd_main` anywhere. Always go through `tenantContext->db`.
- ❌ Sharing Redis keys across tenants without a prefix.
- ❌ Cron jobs that don't loop over tenants — see
  [Jobs and scheduling](./jobs-and-scheduling.md) for the right pattern.
