---
title: "Sales Doctor - Kpi"
audience: All sd-main developers, QA
summary: Live admin page at /dashboard/kpi
topics: [dashboard, page, ui]
---

# Sales Doctor - Kpi

**URL**: `/dashboard/kpi` · **Module**: `dashboard` · **Controller**: `KpiController::index` · **RBAC**: `operation.kpi.result` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Kpi](/screens/admin/dashboard_kpi.jpg)

## Purpose

This page lives at `/dashboard/kpi` in the live admin. It belongs to the **Dashboard** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Супервайзер
- Выбрать все
- Убрать все
- Агент
- Май
- 2026
- установите план
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/dashboard/controllers/KpiController.php` (line 2626)
- **Action kind**: inline
- **Required permission**: `operation.kpi.result`

## See also

- Module reference: [/modules/dashboard](/docs/modules/dashboard)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
