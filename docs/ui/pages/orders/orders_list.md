---
title: "Список заявок"
audience: All sd-main developers, QA
summary: Live admin page at /orders/list
topics: [orders, page, ui]
---

# Список заявок

**URL**: `/orders/list` · **Module**: `orders` · **Controller**: `ListController::index` · **RBAC**: `operation.orders.list` · **Role harvested**: `admin`

![Screenshot of Список заявок](/screens/admin/orders_list.jpg)

## Purpose

This page lives at `/orders/list` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Статус заявки | `—` | text | — |
| Тип заявки | `—` | text | — |
| Категория клиента | `—` | text | — |
| Территория | `—` | text | — |
| Супервайзер | `—` | text | — |
| Агент | `—` | text | — |
| Экспедитор | `—` | text | — |
| Тип цены | `—` | text | — |
| Направление торговли | `—` | text | — |
| Склад | `—` | text | — |
| Категория товара | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Номер документа |
| 2 | Тип заявки |
| 3 | Статус |
| 4 | Агент |
| 5 | Клиент |
| 6 | Баланс |
| 7 | Сумма |
| 8 | Остаток долга |
| 9 | Дата заявки |
| 10 | Дата отгрузки |
| 11 | Экспедитор |
| 12 | Склад |
| 13 | Количество |
| 14 | Объём |
| 15 | Тег |
| 16 | Комментарий |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Сбросить фильтр
- Добавить
- Накладные
- Групповая обработка
- Отчёты
- Показать по
- Excel
- Развернуть
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/ListController.php` (line 8)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.orders.list`

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
