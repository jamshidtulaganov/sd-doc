---
title: "Sales Doctor - Outlet"
audience: All sd-main developers, QA
summary: Live admin page at /planning/outlet
topics: [planning, page, ui]
---

# Sales Doctor - Outlet

**URL**: `/planning/outlet` · **Module**: `planning` · **Controller**: `OutletController::index` · **RBAC**: `operation.planning.outlet` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Outlet](/screens/admin/planning_outlet.jpg)

## Purpose

This page lives at `/planning/outlet` in the live admin. It belongs to the **Planning** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Кол-во рабочих дней: 26
- Отработано: 13
- Осталось: 13
- 2026
- Май
- Ничего не выбрано
- ×
- Последний месяц
- Получить рекомендацию
- Сумма
- Количество
- Объем
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/planning/controllers/OutletController.php` (line 14)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.planning.outlet`

## See also

- Module reference: [/modules/planning](/docs/modules/planning)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
