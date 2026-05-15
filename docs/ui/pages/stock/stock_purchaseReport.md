---
title: "Sales Doctor - PurchaseReport"
audience: All sd-main developers, QA
summary: Live admin page at /stock/purchaseReport
topics: [stock, page, ui]
---

# Sales Doctor - PurchaseReport

**URL**: `/stock/purchaseReport` · **Module**: `stock` · **Controller**: `PurchaseReportController::index` · **RBAC**: `operation.stock.purchaseReport` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - PurchaseReport](/screens/admin/stock_purchaseReport.jpg)

## Purpose

This page lives at `/stock/purchaseReport` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Склад
- Выбрать все
- Убрать все
- Категории продуктов
- Продукт
- Поставщик
- май 1 - май 31
- Показать все
- Экспорт в excel
- Детальный отчет по датам
- Сбросить фильтр
- Блокировать
- Разрешить
- OK
- Отменить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PurchaseReportController.php` (line 57)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.purchaseReport`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
