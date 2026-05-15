---
title: "Sales Doctor - AgentRoute"
audience: All sd-main developers, QA
summary: Live admin page at /clients/agentRoute
topics: [clients, page, ui]
---

# Sales Doctor - AgentRoute

**URL**: `/clients/agentRoute` · **Module**: `clients` · **Controller**: `AgentRouteController::index` · **RBAC**: `operation.clients.list` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - AgentRoute](/screens/admin/clients_agentRoute.jpg)

## Purpose

This page lives at `/clients/agentRoute` in the live admin. It belongs to the **Clients** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Агенты | `—` | text | — |
| Супервайзер | `—` | text | — |
| Категория клиента | `—` | text | — |
| Территория | `—` | text | — |
| Дни недели | `—` | text | — |
| Клиенты | `—` | text | — |
| Периодичность по неделям | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Территория |
| 2 | Пн |
| 3 | Вт |
| 4 | Ср |
| 5 | Чт |
| 6 | Пт |
| 7 | Сб |
| 8 | Вс |
| 9 | Итог |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Фильтр
- Сбросить фильтр
- Показать по
- Excel
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/clients/controllers/AgentRouteController.php` (line 5)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.clients.list`

## See also

- Module reference: [/modules/clients](/docs/modules/clients)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
