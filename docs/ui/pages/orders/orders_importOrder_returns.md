---
title: "Импорт возвратов"
audience: All sd-main developers, QA
summary: Live admin page at /orders/importOrder/returns
topics: [orders, page, ui]
---

# Импорт возвратов

**URL**: `/orders/importOrder/returns` · **Module**: `orders` · **Controller**: `ImportOrderController::returns` · **RBAC**: `operation.orders.importDefect` · **Role harvested**: `admin`

![Screenshot of Импорт возвратов](/screens/admin/orders_importOrder_returns.jpg)

## Purpose

This page lives at `/orders/importOrder/returns` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Заказы.xlsx | `—` | file | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Проверить
- Скачать шаблон
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/ImportOrderController.php` (line 64)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Импорт возвратов"
- **Required permission**: `operation.orders.importDefect`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
