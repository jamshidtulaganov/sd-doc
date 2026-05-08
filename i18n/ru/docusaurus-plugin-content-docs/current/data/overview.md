---
sidebar_position: 1
title: Обзор модели данных
---

# Обзор модели данных

В схеме **300+ таблиц** в БД тенанта. Ментальная модель — слоёная:

| Слой | Примеры |
|------|---------|
| **Identity & access** | `user`, `agent`, `authitem`, `authitemchild`, `authassignment`, `filial` |
| **Каталог** | `product`, `category`, `brand`, `sku`, `price`, `price_type`, `unit` |
| **Продажи** | `order`, `order_product`, `defect`, `bonus_*`, `visit`, `route` |
| **Клиенты** | `client`, `client_category`, `contract_client`, `client_debt` |
| **Склад** | `stock`, `warehouse`, `lot`, `inventory`, `tara` |
| **Финансы** | `pay`, `payment`, `cashbox`, `pnl_*`, `invoice` |
| **Аудит / merch** | `audit`, `audit_result`, `adt_*`, `facing` |
| **Полевые операции** | `gps_track`, `visit`, `route`, `kpi_*` |
| **Интеграции** | `integration_log`, `xml_id`, sync state-таблицы |

Для high-level связей см.
[ER-диаграмма](../architecture/diagrams.md).

## Соглашения

- **Таблицы** имеют префикс `d0_` (конфигурируемый).
- **Скоупинг по филиалу** через `FILIAL_ID`. Модели наследуют
  `BaseFilial`, который применяет скоуп автоматически.
- **Внешние ID** хранятся в колонках `XML_ID` (трекинг 1C / EDI).
- **Soft-delete** через `ACTIVE = 'N'`.
- **Audit-колонки** `CREATE_BY/AT`, `UPDATE_BY/AT`, `TIMESTAMP_X`.

## Миграции

Сейчас одна папка `migrations/`; новые изменения схемы идут через
Yii-миграционный инструмент (`yiic migrate create <name>`). См.
[Миграции](./migrations.md).
