---
title: "Список поступлений"
audience: All sd-main developers, QA
summary: Live admin page at /warehouse/view/listPurchase
topics: [warehouse, page, ui]
---

# Список поступлений

**URL**: `/warehouse/view/listPurchase` · **Module**: `warehouse` · **Controller**: `ViewController::listPurchase` · **RBAC**: `operation.stock.purchaseView` · **Role harvested**: `admin`

![Screenshot of Список поступлений](/screens/admin/warehouse_view_listPurchase.jpg)

## Purpose

This page lives at `/warehouse/view/listPurchase` in the live admin. It belongs to the **Warehouse** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Склад | `—` | text | — |
| Отправитель | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ID документа |
| 2 | Дата поступления |
| 3 | Дата создания |
| 4 | Поставщик |
| 5 | Склад |
| 6 | В блоках |
| 7 | В штуках |
| 8 | Объём |
| 9 | Сумма |
| 10 | Комментарий |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Добавить
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/warehouse/controllers/ViewController.php` (line 34)
- **Action kind**: inline
- **View rendered**: `purchase/list/index`
- **PageTitle()**: "Список поступлений"
- **Required permission**: `operation.stock.purchaseView`

## See also

- Module reference: [/modules/warehouse](/docs/modules/warehouse)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
