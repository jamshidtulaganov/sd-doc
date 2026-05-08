---
sidebar_position: 5
title: Data schemes (sd-cs)
audience: Backend / data engineers
summary: sd-cs has two database connections at runtime — its own cs_* schema (HQ-owned) and a swappable dealer connection that reads d0_* tables read-only. This page maps both.
topics: [sd-cs, schema, multi-db, cs-prefix, dealer-connection]
---

# sd-cs · Data schemes

sd-cs holds **two MySQL connections in parallel** (see [Multi-DB connection](./multi-db.md) for the topology). Two schemas, two ownership models.

## Connection 1 — `db` · HQ schema (`cs_*`)

The HQ-owned schema. sd-cs writes here freely; this is the system of record for everything the brand owner manages directly.

| Domain | Tables (prefix `cs_`) |
|--------|-----------------------|
| HQ catalog | `cs_brand`, `cs_segment`, `cs_country_category` |
| Plans / targets | `cs_plan`, `cs_plan_product` |
| HQ users | `cs_user`, `cs_authassignment`, `cs_authitem`, `cs_authitemchild` |
| Pivoted intermediates | `cs_pivot_<name>` (large pre-computed pivots) |
| Audit log | `cs_dblog` (every cross-DB query is logged here) |

See the per-schema reference in [`docs/sd-cs/architecture.md`](./architecture.md) for column-level detail.

## Connection 2 — `dealer` · per-dealer read-only swap (`d0_*`)

A swappable connection — reset per dealer in cross-dealer reports. Always **read-only at the MySQL grant level**. sd-cs reads from this connection but never writes.

| Domain | Tables read (prefix `d0_`) |
|--------|----------------------------|
| Sales | `d0_order`, `d0_order_product`, `d0_defect` |
| Customers | `d0_client`, `d0_client_category` |
| Agents | `d0_agent`, `d0_visit`, `d0_kpi_*` |
| Catalog | `d0_product`, `d0_category`, `d0_price`, `d0_price_type` |
| Stock | `d0_stock`, `d0_warehouse`, `d0_inventory` |
| Audits | `d0_audit`, `d0_audit_result` |
| GPS | `d0_gps_track` |

These are sd-main's tables — for column-level detail and the ERD, see [sd-main · Data Schemes](../data/erd.md). sd-cs treats them as a read interface, not as its own data model.

## Conventions

- **Models** that target the dealer DB override `getDbConnection()` to return `Yii::app()->dealer`. See [sd-cs ↔ sd-main integration](./sd-main-integration.md#models) for the pattern.
- **Cross-DB JOINs are forbidden** — different MySQL hosts in production. Aggregate in PHP after pulling per-dealer projections.
- **Schema drift** between dealers is real. See [the schema-drift handling section](./sd-main-integration.md#schema-drift-handling).
- **Row-level isolation** is implicit: a dealer's `d0_*` tables only contain that dealer's data, so the connection swap effectively scopes the query.

## See also

- [Multi-DB connection](./multi-db.md) — how the two connections are wired in `protected/config/db.php`
- [sd-cs ↔ sd-main integration](./sd-main-integration.md) — the deep dive
- [sd-main · Core ERD](../data/erd.md) — the dealer-side data model
- [sd-main · Schema reference](../data/schema-reference.md) — column-level reference
