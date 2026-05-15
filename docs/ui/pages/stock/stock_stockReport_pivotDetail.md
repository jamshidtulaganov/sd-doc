---
title: "Отчёт об остатках"
audience: All sd-main developers, QA
summary: Live admin page at /stock/stockReport/pivotDetail
topics: [stock, page, ui]
---

# Отчёт об остатках

**URL**: `/stock/stockReport/pivotDetail` · **Module**: `stock` · **Controller**: `StockReportController::pivotDetail` · **RBAC**: `operation.stock.pivotDetail` · **Role harvested**: `admin`

![Screenshot of Отчёт об остатках](/screens/admin/stock_stockReport_pivotDetail.jpg)

## Purpose

This page lives at `/stock/stockReport/pivotDetail` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Типы складов | `—` | text | — |
| Склады | `—` | text | — |
| Категории товаров | `—` | text | — |
| Группа товаров | `—` | text | — |
| Товары | `—` | text | — |
| Направление торговли | `—` | text | — |
| Активность товаров | `—` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/StockReportController.php` (line 7)
- **Action kind**: inline
- **View rendered**: `pivot-detail`
- **PageTitle()**: "Отчёт об остатках"
- **Required permission**: `operation.stock.pivotDetail`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
