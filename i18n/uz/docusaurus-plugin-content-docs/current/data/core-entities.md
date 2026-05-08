---
sidebar_position: 3
title: Asosiy obyektlar
---

# Asosiy obyektlar

Eng muhim modellar uchun batafsil havola. Pastdagi maydon ro'yxatlari Yii model docblock-lariga mos keladi.

## `Order`

`protected/models/Order.php`. `BaseFilial` ni kengaytiradi.

| Ustun | Tur | Eslatmalar |
|--------|------|-------|
| `ORDER_ID` | string | Birlamchi kalit (UUID-ga o'xshash) |
| `DILER_ID` | string | Tenant kichik bo'limi |
| `CLIENT_ID` | string | FK → `Client` |
| `AGENT_ID` | string | FK → `Agent` |
| `CITY_ID` | string | Geografik scope |
| `PRICE_TYPE` | string | Faol narx ro'yxati |
| `STATUS` | int | Qarang [Order State Machine](../architecture/diagrams.md) |
| `SUB_STATUS` | int | Mayda donador status |
| `SUMMA` | float | Jami |
| `DEBT` | float | To'lanmagan debitorlik qarz |
| `DATE` | datetime | Yuborilgan |
| `DATE_LOAD` | datetime | Yetkazib berish uchun yuklangan |
| `DATE_DELIVERED` | datetime | Yetkazilgan |
| `DATE_CANCEL` | datetime | Bekor qilingan |
| `STORE_ID` | string | Manba ombor / do'kon |
| `XML_ID` | string | Tashqi (1C) identifikator |
| `SOURCE` | string | Kanal (mobile / web / online / import) |
| `CREATE_BY/AT`, `UPDATE_BY/AT` | – | Audit |

Munosabatlar: `client`, `agent`, `lines (OrderProduct)`, `payments`, `invoice`.

## `Client`

| Ustun | Tur | Eslatmalar |
|--------|------|-------|
| `CLIENT_ID` | string | Birlamchi kalit |
| `NAME` | string | Ko'rsatish nomi |
| `INN` | string | Soliq identifikatori (Faktura.uz / Didox uchun) |
| `ADDRESS` | string | Erkin shakldagi manzil |
| `LAT`, `LNG` | decimal | Geofencing uchun |
| `CATEGORY_ID` | string | FK → `ClientCategory` |
| `CONTRACT_ID` | string | FK → `ContractClient` |
| `DEBT` | float | Snapshot |
| `ACTIVE` | char(1) | `Y` / `N` |
| `APPROVED` | int | 0 = kutilmoqda, 1 = tasdiqlangan |

## `Agent`

| Ustun | Eslatmalar |
|--------|-------|
| `AGENT_ID` | PK |
| `NAME` | To'liq ism |
| `TEL` | Telefon |
| `LOGIN` | `User.AGENT_ID` orqali ulangan |
| `CAR_ID` | Tayinlangan avtomobil |
| `ACTIVE` | `Y` / `N` |
| `ROUTE_ID` | Default marshrut |

## `Product`

| Ustun | Eslatmalar |
|--------|-------|
| `PRODUCT_ID` | PK |
| `NAME` | Ko'rsatish nomi |
| `CODE` | Ichki kod |
| `XML_ID` | Tashqi ID |
| `CATEGORY_ID` | FK → `Category` |
| `BRAND_ID` | FK → `Brand` |
| `UNIT` | Asosiy birlik |
| `UNIT_SYMBOL` | UI belgisi |

## `Stock`

| Ustun | Eslatmalar |
|--------|-------|
| `ID` | PK |
| `PRODUCT_ID` | FK |
| `WAREHOUSE_ID` | FK |
| `LOT` | Ixtiyoriy |
| `COUNT` | Mavjud |
| `RESERVED` | Buyurtmalar tomonidan zaxiraga olingan |
| `BLOCKED` | Sifat / karantin |
