---
sidebar_position: 4
title: Caching
---

# Caching

## Three Redis databases, one job each

Verified against `protected/config/main_static.php:71-129`. Single Redis
instance at `10.0.0.11:6379`, three logical DBs:

| Redis DB | Component | Class | Key prefix | Purpose |
|----------|-----------|-------|-----------|---------|
| **db0** | `redis_session` | `CRedisCache` | `HTTP_HOST:` (cli on CLI) | HTTP session storage |
| **db1** | `queueRedis` | `RedisConnection` | `queue:{name}*` (see [Jobs](./jobs-and-scheduling.md)) | Background job queue (`BaseJob` payloads) |
| **db2** | `redis_app` | `CRedisCache` | none global; scoped at app level | Application cache, scoped via `TenantContext` |

`FLUSHDB` on one does **not** affect the others. Application code MUST
go through `Yii::app()->tenantContext->tenantCache()` or `filialCache()`
— never directly read/write `Yii::app()->redis_app` or callers will
leak data across tenants. See `TenantContext.php:84-115` for the wrapper
contract.

## When to use the cache

- ✅ Lookups that are read 100× more than they're written (price types,
  category tree, authitem hierarchy, filial list).
- ✅ Expensive aggregates (dashboard KPIs, debt totals).
- ❌ Per-request memoization — use a static property instead.
- ❌ Anything that must be transactionally consistent — keep it in MySQL.

## TTLs — defaults

| Data | TTL | Rationale |
|------|-----|-----------|
| Auth items / RBAC | 600s | Cheap to recompute, stale auth is risky |
| Filial list | 3600s | Changes very rarely |
| Catalog category tree | 1800s | Changes a few times a day |
| Dashboard KPIs | 60s | Snappy UI, near-real-time |
| Reports (heavy SQL) | 300s | Reduces DB load |

## Invalidation

Always invalidate at write time. Patterns:

```php
// After saving a price
$cache = Yii::app()->tenantContext->filialCache();   // ScopedCache wrapper
if ($cache !== null) {                               // null if tenant not resolved
    $cache->delete('catalog:price-types');
    $cache->delete("product:{$id}:prices");
}
```

For cache *bumps* (versioned keys):

```php
$ver = $cache->increment('catalog:version');
$key = "catalog:tree:v{$ver}";
```

This avoids fan-out invalidation when many keys depend on one source.

## RBAC caching

`DbAuthManager` (`main_static.php:143-152`) caches the auth-item tree
with `cachingDuration => 600` (10 minutes). The tenant context ID is
plumbed in via `tenantContextID => 'tenantContext'`, so the auth cache
respects the same tenant scoping as the application cache. A change to
a user's `authassignment` propagates within 600 s unless the writer
also calls the targeted invalidation hook on `DbAuthManager`.

## Anti-patterns spotted in code

- Reading from `Yii::app()->cache` directly — there is no such component
  registered (`main_static.php` declares `redis_session`, `queueRedis`,
  `redis_app`, but not a generic `cache`). Any such call is dead.
- Calling `Yii::app()->redis_app->set(...)` from controllers without
  scoping. Search for those and route them through `tenantContext`.
