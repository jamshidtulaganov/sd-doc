---
title: "Sales Doctor - Superviser KpiNew"
audience: All sd-main developers, QA
summary: Live admin page at /agents/kpiNew/superviser
topics: [agents, page, ui]
---

# Sales Doctor - Superviser KpiNew

**URL**: `/agents/kpiNew/superviser` · **Module**: `agents` · **Controller**: `KpiNewController::superviser` · **RBAC**: `operation.kpi.list` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Superviser KpiNew](/screens/admin/agents_kpiNew_superviser.jpg)

## Purpose

This page lives at `/agents/kpiNew/superviser` in the live admin. It belongs to the **Agents** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Период |
| 2 | Супервайзеры |
| 3 | Установка |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Установить KPI
- Добавить задачу
- Задачи
- KPI Результаты
- Установка
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/agents/controllers/KpiNewController.php` (line 339)
- **Action kind**: inline
- **View rendered**: `superviser`
- **Required permission**: `operation.kpi.list`

## See also

- Module reference: [/modules/agents](/docs/modules/agents)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
