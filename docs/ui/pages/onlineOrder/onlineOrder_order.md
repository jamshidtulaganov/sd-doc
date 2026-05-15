---
title: "Онлайн заявки"
audience: All sd-main developers, QA
summary: Live admin page at /onlineOrder/order
topics: [onlineOrder, page, ui]
---

# Онлайн заявки

**URL**: `/onlineOrder/order` · **Module**: `onlineOrder` · **Controller**: `OrderController::index` · **Role harvested**: `admin`

![Screenshot of Онлайн заявки](/screens/admin/onlineOrder_order.jpg)

## Purpose

This page lives at `/onlineOrder/order` in the live admin. It belongs to the **Online order** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Статус | `—` | text | — |
| Контакт | `—` | text | — |
| Поиск | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Id |
| 2 | Имя |
| 3 | Номер |
| 4 | Дата заказа |
| 5 | Клиент |
| 6 | Комм-ий |
| 7 | Способ оплаты |
| 8 | Адрес |
| 9 | Сумма |
| 10 | Бонус |
| 11 | Статус |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Excel
- ×
- `{{ $t('Показать на карте') }}`
- `{{ $t('Закрыть') }}`
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/onlineOrder/controllers/OrderController.php` (line 36)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Онлайн заявки"

## See also

- Module reference: [/modules/onlineOrder](/docs/modules/onlineOrder)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
