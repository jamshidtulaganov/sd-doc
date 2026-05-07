---
sidebar_position: 2
title: 1C / Esale
---

# 1C / Esale

Most tenants run **1C: Enterprise** as their accounting system. The
integration synchronises:

| Direction | Entities |
|-----------|----------|
| 1C → SD | Catalog (products, categories, prices, units), clients (master), warehouses, payments |
| SD → 1C | Orders (header + lines), defects, returns, payments collected by agents |

## Endpoints

- `POST /api/json1c/<action>` — JSON, recent.
- Legacy XML: `/api/xml1c/...` — frozen.

Operations:

```
POST /api/json1c/import?type=products
POST /api/json1c/import?type=clients
POST /api/json1c/export?type=orders
POST /api/json1c/ack?type=order&id=O-2026-0123
```

Auth: shared secret (`Authorization: SDocSecret <token>`).

## Mapping

`XML_ID` on `Product`, `Client`, `Order`, etc. holds the 1C reference.
`integration_log` keeps every request/response.

## Failure handling

If 1C returns an error mid-batch:

1. The whole batch is rolled back **on the SD side**.
2. The `integration_log` row gets `status=ERROR`.
3. The job re-enqueues with backoff (max 6 retries).
4. After 6 failures, an alert is dispatched to `adminEmail`.

## See also

- [`integration` module](../modules/integration.md)
- [`sync` module](../modules/sync.md)
