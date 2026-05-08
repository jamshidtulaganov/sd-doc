---
sidebar_position: 1
title: Ma'lumotlar modeli umumiy ko'rinishi
---

# Ma'lumotlar modeli umumiy ko'rinishi

Sxemada tenant ma'lumotlar bazasi bo'ylab **300+ jadval** mavjud. Tushunish modeli qatlamli:

| Qatlam | Misollar |
|-------|----------|
| **Identity & access** | `user`, `agent`, `authitem`, `authitemchild`, `authassignment`, `filial` |
| **Catalog** | `product`, `category`, `brand`, `sku`, `price`, `price_type`, `unit` |
| **Sales** | `order`, `order_product`, `defect`, `bonus_*`, `visit`, `route` |
| **Customer** | `client`, `client_category`, `contract_client`, `client_debt` |
| **Stock** | `stock`, `warehouse`, `lot`, `inventory`, `tara` |
| **Finance** | `pay`, `payment`, `cashbox`, `pnl_*`, `invoice` |
| **Audit / merch** | `audit`, `audit_result`, `adt_*`, `facing` |
| **Field ops** | `gps_track`, `visit`, `route`, `kpi_*` |
| **Integration** | `integration_log`, `xml_id`, sync state jadvallari |

Yuqori darajadagi munosabatlar uchun [ERD diagramma](../architecture/diagrams.md) ga qarang.

## Konvensiyalar

- **Jadvallar** prefiksi `d0_` (sozlanadigan).
- **Filial scoping** `FILIAL_ID` orqali. `BaseFilial` dan meros olgan modellar scope-ni avtomatik qo'llaydi.
- **Tashqi ID-lar** `XML_ID` ustunlarida saqlanadi (1C / EDI kuzatuvi).
- **Soft delete** `ACTIVE = 'N'` orqali.
- **Audit ustunlari** `CREATE_BY/AT`, `UPDATE_BY/AT`, `TIMESTAMP_X`.

## Migratsiyalar

Hozirda yagona `migrations/` papkasi mavjud; yangi sxema o'zgarishlari Yii ning migration tool (`yiic migrate create <name>`) orqali o'tadi. Qarang [Migrations](./migrations.md).
