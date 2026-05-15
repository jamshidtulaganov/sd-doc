---
title: "За весь период"
audience: All sd-main developers, QA
summary: Live admin page at /vs/order
topics: [vs, page, ui]
---

# За весь период

**URL**: `/vs/order` · **Module**: `vs` · **Controller**: `OrderController::index` · **RBAC**: `operation.stock.vsExchange` · **Role harvested**: `admin`

![Screenshot of За весь период](/screens/admin/vs_order.jpg)

## Purpose

This page lives at `/vs/order` in the live admin. It belongs to the **Van-selling** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Агент | `—` | text | — |
| Склад (Vansel) | `—` | text | — |
| Склад (Клиент) | `—` | text | — |
| Тип цены | `—` | text | — |
| Статус | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Дата создания |
| 2 | Дата отгрузки |
| 3 | Агент |
| 4 | Тип цены |
| 5 | Количество |
| 6 | Сумма |
| 7 | Статус |
| 8 | Со склада |
| 9 | На склад |
| 10 | Создан кем |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Сбросить фильтр
- Изменить статус
- Документы
- Отчёты
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/vs/controllers/OrderController.php` (line 12)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.vsExchange`

## See also

- Module reference: [/modules/vs](/docs/modules/vs)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
