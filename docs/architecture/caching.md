---
sidebar_position: 4
title: Caching
---

# Caching

## Three Redis databases, one job each

| Redis DB | Component | Purpose |
|----------|-----------|---------|
| **db0** | `redis_session` (`CRedisCache`) | HTTP session storage. Prefix: `HTTP_HOST:` |
| **db1** | `queueRedis` (`RedisConnection`) | Background job queue (`BaseJob` payloads) |
| **db2** | `redis_app` (`CRedisCache`) | Application cache, scoped via `TenantContext` |

`FLUSHDB` on one does **not** affect the others.

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
$cache = Yii::app()->tenantContext->scopedFilial();
$cache->delete('catalog:price-types');
$cache->delete("product:{$id}:prices");
```

For cache *bumps* (versioned keys):

```php
$ver = $cache->increment('catalog:version');
$key = "catalog:tree:v{$ver}";
```

This avoids fan-out invalidation when many keys depend on one source.
