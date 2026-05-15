---
title: "Импорт корректировок"
audience: All sd-main developers, QA
summary: Live admin page at /stock/storeCorrector/fileImport
topics: [stock, page, ui]
---

# Импорт корректировок

**URL**: `/stock/storeCorrector/fileImport` · **Module**: `stock` · **Controller**: `StoreCorrectorController::fileImport` · **RBAC**: `operation.stock.corrector` · **Role harvested**: `admin`

![Screenshot of Импорт корректировок](/screens/admin/stock_storeCorrector_fileImport.jpg)

## Purpose

This page lives at `/stock/storeCorrector/fileImport` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Остатки.xlsx | `—` | file | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Скачать шаблон
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/StoreCorrectorController.php` (line 575)
- **Action kind**: inline
- **View rendered**: `file-import`
- **PageTitle()**: "Импорт корректировок"
- **Required permission**: `operation.stock.corrector`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
