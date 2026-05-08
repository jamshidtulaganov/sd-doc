---
sidebar_position: 5
title: Схемы данных (sd-cs)
audience: Backend / data-инженеры
summary: sd-cs во время выполнения держит два подключения к БД — собственную схему cs_* (HQ-owned) и swappable дилерское подключение, читающее d0_* таблицы read-only. Эта страница описывает обе.
topics: [sd-cs, schema, multi-db, cs-prefix, dealer-connection]
---

# sd-cs · Схемы данных

sd-cs держит **два MySQL-подключения параллельно** (см. [Multi-DB connection](./multi-db.md) для топологии). Две схемы, две модели владения.

## Connection 1 — `db` · HQ-схема (`cs_*`)

HQ-владеемая схема. sd-cs пишет сюда свободно; это система записи для всего, что бренд-владелец управляет напрямую.

| Домен | Таблицы (префикс `cs_`) |
|--------|-----------------------|
| HQ-каталог | `cs_brand`, `cs_segment`, `cs_country_category` |
| Планы / цели | `cs_plan`, `cs_plan_product` |
| HQ-пользователи | `cs_user`, `cs_authassignment`, `cs_authitem`, `cs_authitemchild` |
| Pivoted intermediates | `cs_pivot_<name>` (большие предрассчитанные pivots) |
| Audit log | `cs_dblog` (каждый кросс-DB-запрос логируется здесь) |

См. per-schema справочник в [`docs/sd-cs/architecture.md`](./architecture.md) для column-level деталей.

## Connection 2 — `dealer` · per-dealer read-only swap (`d0_*`)

Swappable-подключение — сбрасывается на каждого дилера в кросс-дилерских отчётах. Всегда **read-only на уровне MySQL grant**. sd-cs читает с этого подключения, но никогда не пишет.

| Домен | Читаемые таблицы (префикс `d0_`) |
|--------|----------------------------|
| Sales | `d0_order`, `d0_order_product`, `d0_defect` |
| Customers | `d0_client`, `d0_client_category` |
| Agents | `d0_agent`, `d0_visit`, `d0_kpi_*` |
| Catalog | `d0_product`, `d0_category`, `d0_price`, `d0_price_type` |
| Stock | `d0_stock`, `d0_warehouse`, `d0_inventory` |
| Audits | `d0_audit`, `d0_audit_result` |
| GPS | `d0_gps_track` |

Это таблицы sd-main — для column-level детали и ERD см. [sd-main · Data Schemes](../data/erd.md). sd-cs относится к ним как к read-интерфейсу, не как к собственной модели данных.

## Соглашения

- **Модели**, нацеленные на dealer-DB, переопределяют `getDbConnection()`, чтобы возвращать `Yii::app()->dealer`. См. [интеграция sd-cs ↔ sd-main](./sd-main-integration.md#models) для паттерна.
- **Кросс-БД JOIN запрещены** — разные MySQL-хосты в production. Агрегируйте в PHP после вытягивания per-dealer проекций.
- **Schema drift** между дилерами реален. См. [секцию по обработке schema-drift](./sd-main-integration.md#schema-drift-handling).
- **Row-level isolation** неявная: таблицы `d0_*` дилера содержат только данные этого дилера, поэтому смена подключения эффективно scope`ит запрос.

## См. также

- [Multi-DB connection](./multi-db.md) — как два подключения подключены в `protected/config/db.php`
- [интеграция sd-cs ↔ sd-main](./sd-main-integration.md) — глубокое погружение
- [sd-main · Core ERD](../data/erd.md) — модель данных на стороне дилера
- [sd-main · Schema reference](../data/schema-reference.md) — column-level справочник
