---
title: "Остатки по партиям"
audience: All sd-main developers, QA
summary: Live admin page at /stock/lotReport
topics: [stock, page, ui]
---

# Остатки по партиям

**URL**: `/stock/lotReport` · **Module**: `stock` · **Controller**: `LotReportController::index` · **RBAC**: `operation.stock.lotReport` · **Role harvested**: `admin`

![Screenshot of Остатки по партиям](/screens/admin/stock_lotReport.jpg)

## Purpose

This page lives at `/stock/lotReport` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Дата | `—` | text | — |
| Категория продуктов | `—` | text | — |
| Направление торговли | `—` | text | — |
| Склад | `—` | text | — |
| Тип партии | `—` | text | — |
| Подкатегория продуктов | `—` | text | — |
| Группа продуктов | `—` | text | — |
| Бренд | `—` | text | — |
| Производитель | `—` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/LotReportController.php` (line 12)
- **Action kind**: inline
- **View rendered**: `index2`
- **Required permission**: `operation.stock.lotReport`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
