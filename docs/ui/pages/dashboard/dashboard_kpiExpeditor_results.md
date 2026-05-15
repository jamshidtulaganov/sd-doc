---
title: "KPI Результаты"
audience: All sd-main developers, QA
summary: Live admin page at /dashboard/kpiExpeditor/results
topics: [dashboard, page, ui]
---

# KPI Результаты

**URL**: `/dashboard/kpiExpeditor/results` · **Module**: `dashboard` · **Controller**: `KpiExpeditorController::results` · **Role harvested**: `admin`

![Screenshot of KPI Результаты](/screens/admin/dashboard_kpiExpeditor_results.jpg)

## Purpose

This page lives at `/dashboard/kpiExpeditor/results` in the live admin. It belongs to the **Dashboard** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Вид | `—` | text | — |
| Экспедиторы | `—` | text | — |
| Задачи | `—` | text | — |
| Сортировка по KPI | `—` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/dashboard/controllers/KpiExpeditorController.php` (line 444)
- **Action kind**: inline
- **View rendered**: `results`
- **PageTitle()**: "KPI Результаты"

## See also

- Module reference: [/modules/dashboard](/docs/modules/dashboard)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
