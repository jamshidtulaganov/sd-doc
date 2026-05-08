---
sidebar_position: 6
title: Scaling
---

# Scaling

## Vertical first

Yii 1 is forgiving; a single 8-core / 16 GB box runs comfortably for
mid-sized tenants. Squeeze more from a single box before going horizontal:

- `pm = dynamic` for php-fpm with `pm.max_children` ≈ `(memory_avail /
  avg_php_mem)`.
- Tune `innodb_buffer_pool_size` to ~70 % of DB host RAM.
- `redis maxmemory-policy = allkeys-lru` for the cache db (db2).

## Horizontal

App tier is stateless → run N replicas behind the LB. Sticky sessions are
**not** required (sessions are in Redis).

Workers: run a separate replica set; each replica picks from db1.

Database: vertical first (read replicas are an option but joins across
tenant DBs are rare).

## Hot tables

| Table | Mitigation |
|-------|------------|
| `gps_track` | Daily partition; truncate older than 90 days |
| `integration_log` | Daily partition; archive after 30 days |
| `audit_*` | Per-tenant partitioning |
| `order` (large tenants) | Index review; consider `(STATUS, DATE)` |

## CDN

Put a CDN (Cloudfront, Bunny) in front of `static/`, `assets/`, `js/`,
`css/` with a long max-age. The hash-based `assets/` folder makes cache
invalidation automatic.
