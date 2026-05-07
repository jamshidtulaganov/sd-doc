---
sidebar_position: 4
title: ADR-0003 — Redis split into 3 DBs
---

# ADR 0003 — Redis: three logical databases

- Status: **Accepted**
- Date: 2024-02-20
- Deciders: Platform team

## Context

A single Redis instance was used for sessions, queue, and application
cache, sharing the same keyspace. A `FLUSHDB` to clear stale cache
killed sessions. Queue depth metrics were polluted by cache keys.

## Decision

Use **three logical Redis databases** on the same instance:

| DB | Purpose |
|----|---------|
| 0 | Sessions (`HTTP_HOST` keyPrefix) |
| 1 | Queue |
| 2 | Application cache (scoped via `TenantContext`) |

`FLUSHDB` on one no longer affects the others.

## Consequences

- ✅ Cleaner separation; each component owns its DB.
- ✅ Distinct memory metrics per concern.
- ❌ Slightly more configuration ceremony per environment.
- ❌ Programmers must remember **never** to use `Yii::app()->cache`
  directly — go through `ScopedCache`.
