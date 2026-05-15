---
title: "Входящие ЭСФ"
audience: All sd-main developers, QA
summary: Live admin page at /markirovka/view/incomingInvoices
topics: [markirovka, page, ui]
---

# Входящие ЭСФ

**URL**: `/markirovka/view/incomingInvoices` · **Module**: `markirovka` · **Controller**: `ViewController::incomingInvoices` · **RBAC**: `operation.marking.incoming` · **Role harvested**: `admin`

![Screenshot of Входящие ЭСФ](/screens/admin/markirovka_view_incomingInvoices.jpg)

## Purpose

This page lives at `/markirovka/view/incomingInvoices` in the live admin. It belongs to the **Markirovka (CIS)** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | # |
| 2 | Роуминг ID документа |
| 3 | Роуминг ID исправленного документа |
| 4 | Номер счёт фактуры |
| 5 | Дата счёт фактуры |
| 6 | Номер договора |
| 7 | Дата договора |
| 8 | Статус документа |
| 9 | Состояние кодов |
| 10 | Состояние приёмки |
| 11 | Отправитель |
| 12 | ИНН отправителя |
| 13 | Сумма |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Синхронизация с Faktura.UZ
- Обновить API-ключ для маркировки
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/markirovka/controllers/ViewController.php` (line 7)
- **Action kind**: inline
- **View rendered**: `/incoming-invoices/index`
- **PageTitle()**: "Входящие ЭСФ"
- **Required permission**: `operation.marking.incoming`

## See also

- Module reference: [/modules/markirovka](/docs/modules/markirovka)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
