---
sidebar_position: 1
title: Data model overview
---

# Data model overview

The schema has **300+ tables** across the tenant database. The mental model
is layered:

| Layer | Examples |
|-------|----------|
| **Identity & access** | `user`, `agent`, `authitem`, `authitemchild`, `authassignment`, `filial` |
| **Catalog** | `product`, `category`, `brand`, `sku`, `price`, `price_type`, `unit` |
| **Sales** | `order`, `order_product`, `defect`, `bonus_*`, `visit`, `route` |
| **Customer** | `client`, `client_category`, `contract_client`, `client_debt` |
| **Stock** | `stock`, `warehouse`, `lot`, `inventory`, `tara` |
| **Finance** | `pay`, `payment`, `cashbox`, `pnl_*`, `invoice` |
| **Audit / merch** | `audit`, `audit_result`, `adt_*`, `facing` |
| **Field ops** | `gps_track`, `visit`, `route`, `kpi_*` |
| **Integration** | `integration_log`, `xml_id`, sync state tables |

For the high-level relationships, see the
[ERD diagram](../architecture/diagrams.md).

## Conventions

- **Tables** prefix `d0_` (configurable).
- **Filial scoping** via `FILIAL_ID`. Models inherit `BaseFilial` which
  auto-applies the scope.
- **External IDs** stored in `XML_ID` columns (1C / EDI tracking).
- **Soft delete** via `ACTIVE = 'N'`.
- **Audit columns** `CREATE_BY/AT`, `UPDATE_BY/AT`, `TIMESTAMP_X`.

## Migrations

There is currently a single `migrations/` folder; new schema changes go
through Yii's migration tool (`yiic migrate create <name>`). See
[Migrations](./migrations.md).
