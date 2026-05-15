---
title: "Материальный отчёт"
audience: All sd-main developers, QA
summary: Live admin page at /store/materialReport
topics: [store, page, ui]
---

# Материальный отчёт

**URL**: `/store/materialReport` · **Module**: `store` · **Controller**: `MaterialReportController::index` · **RBAC**: `operation.stock.materialReport` · **Role harvested**: `admin`

![Screenshot of Материальный отчёт](/screens/admin/store_materialReport.jpg)

## Purpose

This page lives at `/store/materialReport` in the live admin. It belongs to the **Store** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Склады | `—` | text | — |
| Категория продуктов | `—` | text | — |
| Подкатегория продуктов | `—` | text | — |
| Группа продуктов | `—` | text | — |
| Бренд | `—` | text | — |
| Производитель | `—` | text | — |
| Продукты | `—` | text | — |
| Направление торговли | `—` | text | — |
| Статус товара | `—` | text | — |
| Тип данных | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Товар |
| 2 | Остаток на 01/05/2026 |
| 3 | Приход |
| 4 | Расход |
| 5 | Остаток на 15/05/2026 |
| 6 | Поступление |
| 7 | Корректировка+ |
| 8 | Возврат с полки |
| 9 | Перемещение + |
| 10 | Продажа |
| 11 | Возврат поставщику |
| 12 | Корректировка- |
| 13 | Бонус |
| 14 | Списание |
| 15 | Перемещение - |
| 16 | Обмен |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Развернуть
- Скачать
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/store/controllers/MaterialReportController.php` (line 12)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.materialReport`

## See also

- Module reference: [/modules/store](/docs/modules/store)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
