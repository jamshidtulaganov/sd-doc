---
title: "Sales Doctor - Auditor ReportVisit"
audience: All sd-main developers, QA
summary: Live admin page at /report/reportVisit/auditor
topics: [report, page, ui]
---

# Sales Doctor - Auditor ReportVisit

**URL**: `/report/reportVisit/auditor` · **Module**: `report` · **Controller**: `ReportVisitController::auditor` · **RBAC**: `operation.reports.reportVisit` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Auditor ReportVisit](/screens/admin/report_reportVisit_auditor.jpg)

## Purpose

This page lives at `/report/reportVisit/auditor` in the live admin. It belongs to the **Reports** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Мерчендайзер |
| 2 | День (Май) |
| 3 | 1 |
| 4 | 2 |
| 5 | 3 |
| 6 | 4 |
| 7 | 5 |
| 8 | 6 |
| 9 | 7 |
| 10 | 8 |
| 11 | 9 |
| 12 | 10 |
| 13 | 11 |
| 14 | 12 |
| 15 | 13 |
| 16 | 14 |
| 17 | 15 |
| 18 | 16 |
| 19 | 17 |
| 20 | 18 |
| 21 | 19 |
| 22 | 20 |
| 23 | 21 |
| 24 | 22 |
| 25 | 23 |
| 26 | 24 |
| 27 | 25 |
| 28 | 26 |
| 29 | 27 |
| 30 | 28 |
| 31 | 29 |
| 32 | 30 |
| 33 | 31 |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Все визиты
- % от заплан. визитов
- Посещенные
- Май
- 2026
- По 20
- Показ./Скр. столбцы
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/report/controllers/ReportVisitController.php` (line 150)
- **Action kind**: inline
- **Required permission**: `operation.reports.reportVisit`

## See also

- Module reference: [/modules/report](/docs/modules/report)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
