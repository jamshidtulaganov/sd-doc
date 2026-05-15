---
title: "CDbException"
audience: All sd-main developers, QA
summary: Live admin page at /stock/purchase/refund
topics: [stock, page, ui]
---

# CDbException

**URL**: `/stock/purchase/refund` · **Module**: `stock` · **Controller**: `PurchaseController::refund` · **RBAC**: `operation.stock.movement` · **Role harvested**: `admin`

![Screenshot of CDbException](/screens/admin/stock_purchase_refund.jpg)

## Purpose

This page lives at `/stock/purchase/refund` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PurchaseController.php` (line 120)
- **Action kind**: inline
- **View rendered**: `admingrid_refund`
- **Required permission**: `operation.stock.movement`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
