---
title: "Возврат ванселлов"
audience: All sd-main developers, QA
summary: Live admin page at /vs/view/return
topics: [vs, page, ui]
---

# Возврат ванселлов

**URL**: `/vs/view/return` · **Module**: `vs` · **Controller**: `ViewController::return` · **RBAC**: `operation.stock.vsReturn` · **Role harvested**: `admin`

![Screenshot of Возврат ванселлов](/screens/admin/vs_view_return.jpg)

## Purpose

This page lives at `/vs/view/return` in the live admin. It belongs to the **Van-selling** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Статус | `—` | text | — |
| Агенты | `—` | text | — |
| Склад (Van selling) | `—` | text | — |
| Склад | `—` | text | — |
| Тип цены | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Дата заявки |
| 2 | Дата возврата |
| 3 | Агенты |
| 4 | Тип цены |
| 5 | Количество |
| 6 | Сумма |
| 7 | Статус |
| 8 | Со склада |
| 9 | На склад |
| 10 | Создал |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Сбросить фильтр
- Групповая обработка
- Накладные
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/vs/controllers/ViewController.php` (line 5)
- **Action kind**: inline
- **View rendered**: `return/index`
- **PageTitle()**: "Возврат ванселлов"
- **Required permission**: `operation.stock.vsReturn`

## See also

- Module reference: [/modules/vs](/docs/modules/vs)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
