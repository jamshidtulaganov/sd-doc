---
title: "Рейсы"
audience: All sd-main developers, QA
summary: Live admin page at /orders/view/trips
topics: [orders, page, ui]
---

# Рейсы

**URL**: `/orders/view/trips` · **Module**: `orders` · **Controller**: `ViewController::trips` · **Role harvested**: `admin`

![Screenshot of Рейсы](/screens/admin/orders_view_trips.jpg)

## Purpose

This page lives at `/orders/view/trips` in the live admin. It belongs to the **Orders** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Автомобиль | `—` | text | — |
| Курьер | `—` | text | — |
| Экспедитор | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ID |
| 2 | Автомобиль |
| 3 | Заказы |
| 4 | Вес |
| 5 | Объем |
| 6 | Загруженность |
| 7 | Курьер |
| 8 | Экспедитор |
| 9 | Дата прикрепления |
| 10 | Статус |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Всего2
- Активные0
- В ожидании0
- Отмененные0
- Выполненные2
- Добавить
- Групповая обработка
- Показать по
- Excel
- Готов
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/orders/controllers/ViewController.php` (line 32)
- **Action kind**: inline
- **View rendered**: `/trips/index`
- **PageTitle()**: "Рейсы"

## See also

- Module reference: [/modules/orders](/docs/modules/orders)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
