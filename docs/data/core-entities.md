---
sidebar_position: 3
title: Core entities
---

# Core entities

Detailed reference for the most important models. Field lists below match
the Yii model docblocks.

## `Order`

`protected/models/Order.php`. Extends `BaseFilial`.

| Column | Type | Notes |
|--------|------|-------|
| `ORDER_ID` | string | Primary key (UUID-like) |
| `DILER_ID` | string | Tenant subdivision |
| `CLIENT_ID` | string | FK → `Client` |
| `AGENT_ID` | string | FK → `Agent` |
| `CITY_ID` | string | Geographic scope |
| `PRICE_TYPE` | string | Active price list |
| `STATUS` | int | See [Order State Machine](../architecture/diagrams.md) |
| `SUB_STATUS` | int | Fine-grained status |
| `SUMMA` | float | Total |
| `DEBT` | float | Outstanding receivable |
| `DATE` | datetime | Submitted |
| `DATE_LOAD` | datetime | Loaded for delivery |
| `DATE_DELIVERED` | datetime | Delivered |
| `DATE_CANCEL` | datetime | Cancelled |
| `STORE_ID` | string | Source warehouse / store |
| `XML_ID` | string | External (1C) identifier |
| `SOURCE` | string | Channel (mobile / web / online / import) |
| `CREATE_BY/AT`, `UPDATE_BY/AT` | – | Audit |

Relations: `client`, `agent`, `lines (OrderProduct)`, `payments`,
`invoice`.

## `Client`

| Column | Type | Notes |
|--------|------|-------|
| `CLIENT_ID` | string | Primary key |
| `NAME` | string | Display name |
| `INN` | string | Tax ID (used for Faktura.uz / Didox) |
| `ADDRESS` | string | Free-form address |
| `LAT`, `LNG` | decimal | For geofencing |
| `CATEGORY_ID` | string | FK → `ClientCategory` |
| `CONTRACT_ID` | string | FK → `ContractClient` |
| `DEBT` | float | Snapshot |
| `ACTIVE` | char(1) | `Y` / `N` |
| `APPROVED` | int | 0 = pending, 1 = approved |

## `Agent`

| Column | Notes |
|--------|-------|
| `AGENT_ID` | PK |
| `NAME` | Full name |
| `TEL` | Phone |
| `LOGIN` | Linked back via `User.AGENT_ID` |
| `CAR_ID` | Assigned vehicle |
| `ACTIVE` | `Y` / `N` |
| `ROUTE_ID` | Default route |

## `Product`

| Column | Notes |
|--------|-------|
| `PRODUCT_ID` | PK |
| `NAME` | Display name |
| `CODE` | Internal code |
| `XML_ID` | External ID |
| `CATEGORY_ID` | FK → `Category` |
| `BRAND_ID` | FK → `Brand` |
| `UNIT` | Base unit |
| `UNIT_SYMBOL` | UI symbol |

## `Stock`

| Column | Notes |
|--------|-------|
| `ID` | PK |
| `PRODUCT_ID` | FK |
| `WAREHOUSE_ID` | FK |
| `LOT` | Optional |
| `COUNT` | Available |
| `RESERVED` | Reserved by orders |
| `BLOCKED` | Quality / quarantine |
