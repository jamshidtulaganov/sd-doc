---
title: "Sales Doctor - PurchaseReportPivot"
audience: All sd-main developers, QA
summary: Live admin page at /stock/purchaseReportPivot
topics: [stock, page, ui]
---

# Sales Doctor - PurchaseReportPivot

**URL**: `/stock/purchaseReportPivot` · **Module**: `stock` · **Controller**: `PurchaseReportPivotController::index` · **RBAC**: `operation.stock.purchaseReport` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - PurchaseReportPivot](/screens/admin/stock_purchaseReportPivot.jpg)

## Purpose

This page lives at `/stock/purchaseReportPivot` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Май 2026 |
| 2 | вс |
| 3 | пн |
| 4 | вт |
| 5 | ср |
| 6 | чт |
| 7 | пт |
| 8 | сб |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- май 9 - май 15
- ×
- Отменить
- Удалить
- Блокировать
- Разрешить
- OK

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PurchaseReportPivotController.php` (line 7)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.purchaseReport`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
