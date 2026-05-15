---
title: "Sales Doctor - Profit PurchaseReport"
audience: All sd-main developers, QA
summary: Live admin page at /stock/purchaseReport/profit
topics: [stock, page, ui]
---

# Sales Doctor - Profit PurchaseReport

**URL**: `/stock/purchaseReport/profit` · **Module**: `stock` · **Controller**: `PurchaseReportController::profit` · **RBAC**: `operation.stock.purchaseReportProfit` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Profit PurchaseReport](/screens/admin/stock_purchaseReport_profit.jpg)

## Purpose

This page lives at `/stock/purchaseReport/profit` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Категория |
| 2 | Наименование |
| 3 | Тип цены |
| 4 | Блок |
| 5 | Количество |
| 6 | Цена приходная |
| 7 | Сумма прихода |
| 8 | Цена продажи |
| 9 | Сумма скидки |
| 10 | Сумма продажи |
| 11 | Прибыль |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Категории продуктов
- Выбрать все
- Убрать все
- Продукт
- Агент
- Экспедитор
- Территория
- Сегменты клиентов
- Тип цены
- май 1 - май 31
- Блокировать
- Разрешить
- OK
- Отменить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PurchaseReportController.php` (line 992)
- **Action kind**: inline
- **Required permission**: `operation.stock.purchaseReportProfit`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
