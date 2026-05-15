---
title: "Исходящие ЭСФ"
audience: All sd-main developers, QA
summary: Live admin page at /markirovka/view/outgoingInvoices
topics: [markirovka, page, ui]
---

# Исходящие ЭСФ

**URL**: `/markirovka/view/outgoingInvoices` · **Module**: `markirovka` · **Controller**: `ViewController::outgoingInvoices` · **RBAC**: `operation.marking.outgoing` · **Role harvested**: `admin`

![Screenshot of Исходящие ЭСФ](/screens/admin/markirovka_view_outgoingInvoices.jpg)

## Purpose

This page lives at `/markirovka/view/outgoingInvoices` in the live admin. It belongs to the **Markirovka (CIS)** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Статус | `—` | text | — |
| Способ оплаты | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Заказ |
| 2 | Дата заявки |
| 3 | Дата отгрузки |
| 4 | Статус заказа |
| 5 | Статус ЭСФ |
| 6 | Статус КИ |
| 7 | Клиент |
| 8 | ИНН клиента |
| 9 | Тел. клиента |
| 10 | Экспедитор |
| 11 | Тел. экспедитора |
| 12 | Документ ЭСФ |
| 13 | Оператор ЭСФ |
| 14 | Сумма |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Групповая обработка
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/markirovka/controllers/ViewController.php` (line 13)
- **Action kind**: inline
- **View rendered**: `/outgoing-invoices/index`
- **PageTitle()**: "Исходящие ЭСФ"
- **Required permission**: `operation.marking.outgoing`

## See also

- Module reference: [/modules/markirovka](/docs/modules/markirovka)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
