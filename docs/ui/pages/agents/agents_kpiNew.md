---
title: "Sales Doctor - KpiNew"
audience: All sd-main developers, QA
summary: Live admin page at /agents/kpiNew
topics: [agents, page, ui]
---

# Sales Doctor - KpiNew

**URL**: `/agents/kpiNew` · **Module**: `agents` · **Controller**: `KpiNewController::index` · **RBAC**: `operation.kpi.list` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - KpiNew](/screens/admin/agents_kpiNew.jpg)

## Purpose

This page lives at `/agents/kpiNew` in the live admin. It belongs to the **Agents** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Период |
| 2 | Агенты |
| 3 | Изменить |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Установить KPI
- Добавить задачу
- Задачи
- Группировка
- Установка
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/agents/controllers/KpiNewController.php` (line 294)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.kpi.list`

## See also

- Module reference: [/modules/agents](/docs/modules/agents)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
