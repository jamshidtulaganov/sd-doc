---
title: "Склады"
audience: All sd-main developers, QA
summary: Live admin page at /warehouse/list
topics: [warehouse, page, ui]
---

# Склады

**URL**: `/warehouse/list` · **Module**: `warehouse` · **Controller**: `ListController::index` · **RBAC**: `operation.stock.list` · **Role harvested**: `admin`

![Screenshot of Склады](/screens/admin/warehouse_list.jpg)

## Purpose

This page lives at `/warehouse/list` in the live admin. It belongs to the **Warehouse** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Тип | `—` | text | — |
| Агенты | `—` | text | — |
| Способ оплаты | `—` | text | — |
| Активность | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Название склада |
| 2 | Тип склада |
| 3 | Кладовщик |
| 4 | Агенты |
| 5 | Экспедиторы |
| 6 | Способ оплаты |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Добавить
- Групповая обработка
- Показать по
- Excel
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/warehouse/controllers/ListController.php` (line 26)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.list`

## See also

- Module reference: [/modules/warehouse](/docs/modules/warehouse)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
