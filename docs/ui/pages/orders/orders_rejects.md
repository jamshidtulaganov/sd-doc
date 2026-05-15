---
title: "Отказы"
audience: All sd-main developers, QA
summary: Live admin page at /orders/rejects
topics: [orders, page, ui]
---

# Отказы

**URL**: `/orders/rejects` · **Module**: `orders` · **Controller**: `RejectsController::index` · **RBAC**: `operation.orders.rejects` · **Role harvested**: `admin`

![Screenshot of Отказы](/screens/admin/orders_rejects.jpg)

## Purpose

This page lives at `/orders/rejects` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Агент
- Выбрать все
- Убрать все
- Причина отказа
- Категории клиентов
- Город
- май 15 - май 15
- Блокировать
- Разрешить
- OK
- Отменить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/RejectsController.php` (line 47)
- **Action kind**: inline
- **View rendered**: `admingrid_diler`
- **PageTitle()**: "Отказы"
- **Required permission**: `operation.orders.rejects`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
