---
title: "Изменить статус заявок"
audience: All sd-main developers, QA
summary: Live admin page at /orders/orders/editStatus
topics: [orders, page, ui]
---

# Изменить статус заявок

**URL**: `/orders/orders/editStatus` · **Module**: `orders` · **Controller**: `OrdersController::editStatus` · **RBAC**: `operation.orders.import` · **Role harvested**: `admin`

![Screenshot of Изменить статус заявок](/screens/admin/orders_orders_editStatus.jpg)

## Purpose

This page lives at `/orders/orders/editStatus` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Заказы.xlsx | `—` | file | — |
| Выберите статус | `—` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- выбрать столбцы
- применить
- шаблон
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/OrdersController.php` (line 183)
- **Action kind**: inline
- **View rendered**: `edit-status`
- **PageTitle()**: "Изменить статус заявок"
- **Required permission**: `operation.orders.import`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
