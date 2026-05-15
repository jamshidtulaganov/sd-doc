---
title: "Отчёты"
audience: All sd-main developers, QA
summary: Live admin page at /adt/reports
topics: [adt, page, ui]
---

# Отчёты

**URL**: `/adt/reports` · **Module**: `adt` · **Controller**: `ReportsController::index` · **Role harvested**: `admin`

![Screenshot of Отчёты](/screens/admin/adt_reports.jpg)

## Purpose

This page lives at `/adt/reports` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Отчёт |
| 2 | Группа |
| 3 | Описание |
| 4 | Показать в меню |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/ReportsController.php` (line 36)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Отчёты"

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
