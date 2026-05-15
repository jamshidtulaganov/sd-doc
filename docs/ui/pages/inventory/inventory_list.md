---
title: "Список оборудований"
audience: All sd-main developers, QA
summary: Live admin page at /inventory/list
topics: [inventory, page, ui]
---

# Список оборудований

**URL**: `/inventory/list` · **Module**: `inventory` · **Controller**: `ListController::index` · **RBAC**: `operation.inventory.list` · **Role harvested**: `admin`

![Screenshot of Список оборудований](/screens/admin/inventory_list.jpg)

## Purpose

This page lives at `/inventory/list` in the live admin. It belongs to the **Inventory** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Агенты | `—` | text | — |
| Клиенты | `—` | text | — |
| Территория | `—` | text | — |
| Тип оборудования | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ID Инвентаря |
| 2 | Тип инвентаря |
| 3 | Название инвентаря |
| 4 | Клиент |
| 5 | Статус |
| 6 | Номер телефона |
| 7 | Локация |
| 8 | Состояние |
| 9 | Агенты |
| 10 | Дата прикрепления |
| 11 | Серийный номер |

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
- 2
- 3
- 4
- 5
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/inventory/controllers/ListController.php` (line 7)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.inventory.list`

## See also

- Module reference: [/modules/inventory](/docs/modules/inventory)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
