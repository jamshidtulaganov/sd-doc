---
title: "Sales Doctor - DailyRemainder PurchaseReport"
audience: All sd-main developers, QA
summary: Live admin page at /stock/purchaseReport/dailyRemainder
topics: [stock, page, ui]
---

# Sales Doctor - DailyRemainder PurchaseReport

**URL**: `/stock/purchaseReport/dailyRemainder` · **Module**: `stock` · **Controller**: `PurchaseReportController::dailyRemainder` · **RBAC**: `operation.stock.dailyRemainder` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - DailyRemainder PurchaseReport](/screens/admin/stock_purchaseReport_dailyRemainder.jpg)

## Purpose

This page lives at `/stock/purchaseReport/dailyRemainder` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Навои возврат
- Выбрать все
- Убрать все
- Категории продуктов
- Продукт
- Дата операции
- -
- По 10000
- Показ./Скр. столбцы
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PurchaseReportController.php` (line 496)
- **Action kind**: inline
- **View rendered**: `daily`
- **Required permission**: `operation.stock.dailyRemainder`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
