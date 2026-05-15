---
title: "Новый заказ"
audience: All sd-main developers, QA
summary: Live admin page at /orders/addOrder
topics: [orders, page, ui]
---

# Новый заказ

**URL**: `/orders/addOrder` · **Module**: `orders` · **Controller**: `AddOrderController::index` · **RBAC**: `operation.orders.update` · **Role harvested**: `admin`

![Screenshot of Новый заказ](/screens/admin/orders_addOrder.jpg)

## Purpose

This page lives at `/orders/addOrder` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Агент | `—` | text | — |
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
- Open Dialog
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/AddOrderController.php` (line 48)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.orders.update`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
