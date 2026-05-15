---
title: "Sales Doctor - Settings"
audience: All sd-main developers, QA
summary: Live admin page at /adt/settings
topics: [adt, page, ui]
---

# Sales Doctor - Settings

**URL**: `/adt/settings` · **Module**: `adt` · **Controller**: `SettingsController::index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Settings](/screens/admin/adt_settings.jpg)

## Purpose

This page lives at `/adt/settings` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Названия |
| 2 | Сортировка |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Добавить
- ×
- Завершить
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/SettingsController.php` (line 50)
- **Action kind**: inline

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
