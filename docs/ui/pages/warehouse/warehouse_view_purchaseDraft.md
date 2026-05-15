---
title: "Sales Doctor - PurchaseDraft View"
audience: All sd-main developers, QA
summary: Live admin page at /warehouse/view/purchaseDraft
topics: [warehouse, page, ui]
---

# Sales Doctor - PurchaseDraft View

**URL**: `/warehouse/view/purchaseDraft` · **Module**: `warehouse` · **Controller**: `ViewController::purchaseDraft` · **RBAC**: `operation.stock.purchaseView` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - PurchaseDraft View](/screens/admin/warehouse_view_purchaseDraft.jpg)

## Purpose

This page lives at `/warehouse/view/purchaseDraft` in the live admin. It belongs to the **Warehouse** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Склад | `—` | text | — |
| Тип цены | `—` | text | — |
| Поставщик | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ID |
| 2 | Дата поступления |
| 3 | Дата создания |
| 4 | Склад |
| 5 | Тип цены |
| 6 | Поставщик |
| 7 | Статус |
| 8 | Комментарий |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/warehouse/controllers/ViewController.php` (line 114)
- **Action kind**: inline
- **View rendered**: `purchase-draft/index`
- **Required permission**: `operation.stock.purchaseView`

## See also

- Module reference: [/modules/warehouse](/docs/modules/warehouse)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
