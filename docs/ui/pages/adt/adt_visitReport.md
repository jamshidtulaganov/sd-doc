---
title: "Sales Doctor - VisitReport"
audience: All sd-main developers, QA
summary: Live admin page at /adt/visitReport
topics: [adt, page, ui]
---

# Sales Doctor - VisitReport

**URL**: `/adt/visitReport` · **Module**: `adt` · **Controller**: `VisitReportController::index` · **RBAC**: `operation.adt.visit-report` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - VisitReport](/screens/admin/adt_visitReport.jpg)

## Purpose

This page lives at `/adt/visitReport` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Первая активность |
| 2 | Последняя активность |
| 3 | Время у клиентов |
| 4 | Общее рабочее время |
| 5 | Успешные запланированные визиты |
| 6 | Незапланированные визиты |
| 7 | Все запланированные визиты |
| 8 | Все визиты |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/VisitReportController.php` (line 5)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.adt.visit-report`

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
