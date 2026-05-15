---
title: "Заявки на карте"
audience: All sd-main developers, QA
summary: Live admin page at /orders/view/onMap
topics: [orders, page, ui]
---

# Заявки на карте

**URL**: `/orders/view/onMap` · **Module**: `orders` · **Controller**: `ViewController::onMap` · **RBAC**: `operation.orders.onMap` · **Role harvested**: `admin`

![Screenshot of Заявки на карте](/screens/admin/orders_view_onMap.jpg)

## Purpose

This page lives at `/orders/view/onMap` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Статус | `—` | text | — |
| Экспедитор | `—` | text | — |
| Тип заявки | `—` | text | — |
| Категория клиента | `—` | text | — |
| Территория | `—` | text | — |
| Прикрепить экспедитора | `—` | text | — |
| Рейс | `—` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Сохранить рейс
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/ViewController.php` (line 26)
- **Action kind**: inline
- **View rendered**: `/onMap/index`
- **PageTitle()**: "Заявки на карте"
- **Required permission**: `operation.orders.onMap`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
