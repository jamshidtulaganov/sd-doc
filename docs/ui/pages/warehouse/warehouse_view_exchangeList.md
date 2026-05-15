---
title: "Список перемещений"
audience: All sd-main developers, QA
summary: Live admin page at /warehouse/view/exchangeList
topics: [warehouse, page, ui]
---

# Список перемещений

**URL**: `/warehouse/view/exchangeList` · **Module**: `warehouse` · **Controller**: `ViewController::exchangeList` · **RBAC**: `operation.stock.exchange` · **Role harvested**: `admin`

![Screenshot of Список перемещений](/screens/admin/warehouse_view_exchangeList.jpg)

## Purpose

This page lives at `/warehouse/view/exchangeList` in the live admin. It belongs to the **Warehouse** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | # |
| 2 | ID документа |
| 3 | Дата перемещения |
| 4 | Со склада |
| 5 | На склад |
| 6 | Тип перемещения |
| 7 | Кол-во |
| 8 | Блок |
| 9 | Дата создания |
| 10 | Комментарий |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Добавить
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/warehouse/controllers/ViewController.php` (line 4)
- **Action kind**: inline
- **View rendered**: `exchange-list/index`
- **PageTitle()**: "Список перемещений"
- **Required permission**: `operation.stock.exchange`

## See also

- Module reference: [/modules/warehouse](/docs/modules/warehouse)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
