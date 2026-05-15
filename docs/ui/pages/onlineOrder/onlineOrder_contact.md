---
title: "Sales Doctor - Contact"
audience: All sd-main developers, QA
summary: Live admin page at /onlineOrder/contact
topics: [onlineOrder, page, ui]
---

# Sales Doctor - Contact

**URL**: `/onlineOrder/contact` · **Module**: `onlineOrder` · **Controller**: `ContactController::index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Contact](/screens/admin/onlineOrder_contact.jpg)

## Purpose

This page lives at `/onlineOrder/contact` in the live admin. It belongs to the **Online order** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Пакеты | `—` | text | — |
| Только реферальные клиенты | `—` | checkbox | — |
| Поиск | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Id |
| 2 | Имя |
| 3 | Номер |
| 4 | Никнейм |
| 5 | Клиент |
| 6 | Кол-во заказов |
| 7 | Реферер |
| 8 | Кол-во приглашенных клиентов |
| 9 | Действия |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Export
- edit
- list
- how_to_reg
- Прикрепить пакеты
- Открепить пакеты
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/onlineOrder/controllers/ContactController.php` (line 36)
- **Action kind**: inline
- **View rendered**: `index`

## See also

- Module reference: [/modules/onlineOrder](/docs/modules/onlineOrder)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
