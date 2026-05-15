---
title: "Список корректировок"
audience: All sd-main developers, QA
summary: Live admin page at /warehouse/view/listAdjustment
topics: [warehouse, page, ui]
---

# Список корректировок

**URL**: `/warehouse/view/listAdjustment` · **Module**: `warehouse` · **Controller**: `ViewController::listAdjustment` · **RBAC**: `operation.stock.corrector` · **Role harvested**: `admin`

![Screenshot of Список корректировок](/screens/admin/warehouse_view_listAdjustment.jpg)

## Purpose

This page lives at `/warehouse/view/listAdjustment` in the live admin. It belongs to the **Warehouse** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | ID документа |
| 2 | Дата документа |
| 3 | Дата создания |
| 4 | Склад |
| 5 | Кол-во |
| 6 | Объём |
| 7 | Сумма |
| 8 | Комментарий |
| 9 | Кто создал |

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

- **Controller file**: `protected/modules/warehouse/controllers/ViewController.php` (line 58)
- **Action kind**: inline
- **View rendered**: `adjustment-list/index`
- **PageTitle()**: "Список корректировок"
- **Required permission**: `operation.stock.corrector`

## See also

- Module reference: [/modules/warehouse](/docs/modules/warehouse)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
