---
title: "Новый заказ - Список клиентов"
audience: All sd-main developers, QA
summary: Live admin page at /orders/view/createOrder
topics: [orders, page, ui]
---

# Новый заказ - Список клиентов

**URL**: `/orders/view/createOrder` · **Module**: `orders` · **Controller**: `ViewController::createOrder` · **RBAC**: `operation.orders.create` · **Role harvested**: `admin`

![Screenshot of Новый заказ - Список клиентов](/screens/admin/orders_view_createOrder.jpg)

## Purpose

This page lives at `/orders/view/createOrder` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Агент | `—` | text | — |
| Территория | `—` | text | — |
| Категория клиентов | `—` | text | — |
| Дни посещений | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ID Клиента |
| 2 | Название клиента |
| 3 | Номер телефона |
| 4 | Агенты |
| 5 | Дни посещений |
| 6 | Территория |
| 7 | Адрес |
| 8 | Ориентир |
| 9 | Баланс |
| 10 | Срок оплаты |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Показать по
- Excel
- Выбрать
- 1
- 2
- 3
- 4
- ...
- 9
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/ViewController.php` (line 7)
- **Action kind**: inline
- **View rendered**: `clients/index`
- **PageTitle()**: "Новый заказ - Список клиентов"
- **Required permission**: `operation.orders.create`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
