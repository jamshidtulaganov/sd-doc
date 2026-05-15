---
title: "Список агентов"
audience: All sd-main developers, QA
summary: Live admin page at /staff/view/agent
topics: [staff, page, ui]
---

# Список агентов

**URL**: `/staff/view/agent` · **Module**: `staff` · **Controller**: `ViewController::agent` · **RBAC**: `operation.agents.list` · **Role harvested**: `admin`

![Screenshot of Список агентов](/screens/admin/staff_view_agent.jpg)

## Purpose

This page lives at `/staff/view/agent` in the live admin. It belongs to the **Staff** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Тип | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | ИД |
| 2 | Ф.И.О. |
| 3 | Логин |
| 4 | Телефон |
| 5 | Последняя синхронизация |
| 6 | Тип |
| 7 | Код агента |
| 8 | Доступные товары |
| 9 | Доступные типы цен |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Конфигурация
- Добавить агента
- Групповая обработка
- Показать по
- Excel
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/staff/controllers/ViewController.php` (line 5)
- **Action kind**: inline
- **View rendered**: `agents/index`
- **PageTitle()**: "Список агентов"
- **Required permission**: `operation.agents.list`

## See also

- Module reference: [/modules/settings-access-staff](/docs/modules/settings-access-staff)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
