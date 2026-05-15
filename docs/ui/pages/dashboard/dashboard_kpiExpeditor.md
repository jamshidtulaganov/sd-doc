---
title: "KPI Экспедитора"
audience: All sd-main developers, QA
summary: Live admin page at /dashboard/kpiExpeditor
topics: [dashboard, page, ui]
---

# KPI Экспедитора

**URL**: `/dashboard/kpiExpeditor` · **Module**: `dashboard` · **Controller**: `KpiExpeditorController::index` · **Role harvested**: `admin`

![Screenshot of KPI Экспедитора](/screens/admin/dashboard_kpiExpeditor.jpg)

## Purpose

This page lives at `/dashboard/kpiExpeditor` in the live admin. It belongs to the **Dashboard** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Поиск | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ИД установки |
| 2 | Месяц |
| 3 | Экспедиторы |
| 4 | Задачи |
| 5 | Установка |
| 6 | Редакт. |
| 7 | Удалить |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Установка KPI
- Установка KPI c excel
- Новая задача
- Задачи
- Результаты
- Настройки
- Установить
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/dashboard/controllers/KpiExpeditorController.php` (line 55)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "KPI Экспедитора"

## See also

- Module reference: [/modules/dashboard](/docs/modules/dashboard)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
