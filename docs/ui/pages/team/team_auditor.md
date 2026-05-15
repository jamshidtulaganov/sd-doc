---
title: "Sales Doctor - Auditor"
audience: All sd-main developers, QA
summary: Live admin page at /team/auditor
topics: [team, page, ui]
---

# Sales Doctor - Auditor

**URL**: `/team/auditor` · **Module**: `team` · **Controller**: `AuditorController::index` · **RBAC**: `operation.settings.tradingTeam` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Auditor](/screens/admin/team_auditor.jpg)

## Purpose

This page lives at `/team/auditor` in the live admin. It belongs to the **Team** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Пользователь |
| 2 | Логин |
| 3 | Версия apk |
| 4 | Последняя синхронизация |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Добавить
- Конфигурация для компании
- ×
- Завершить
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/team/controllers/AuditorController.php` (line 56)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.settings.tradingTeam`

## See also

- Module reference: [/modules/team](/docs/modules/team)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
