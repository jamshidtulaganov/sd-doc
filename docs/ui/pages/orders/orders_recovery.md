---
title: "Sales Doctor - Recovery"
audience: All sd-main developers, QA
summary: Live admin page at /orders/recovery
topics: [orders, page, ui]
---

# Sales Doctor - Recovery

**URL**: `/orders/recovery` · **Module**: `orders` · **Controller**: `RecoveryController::index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Recovery](/screens/admin/orders_recovery.jpg)

## Purpose

This page lives at `/orders/recovery` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Поиск | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Id |
| 2 | Название |
| 3 | Название фирмы |
| 4 | Телефон |
| 5 | Категория |
| 6 | Территория |
| 7 | Адрес |
| 8 | Ориентир |
| 9 | Баланс клиента |
| 10 | Просрочки |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/RecoveryController.php` (line 41)
- **Action kind**: inline
- **View rendered**: `index`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
