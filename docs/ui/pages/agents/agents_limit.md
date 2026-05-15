---
title: "Sales Doctor - Limit"
audience: All sd-main developers, QA
summary: Live admin page at /agents/limit
topics: [agents, page, ui]
---

# Sales Doctor - Limit

**URL**: `/agents/limit` · **Module**: `agents` · **Controller**: `LimitController::index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Limit](/screens/admin/agents_limit.jpg)

## Purpose

This page lives at `/agents/limit` in the live admin. It belongs to the **Agents** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Агент |
| 2 | Продукты по категориями |
| 3 | Количество |
| 4 | Тип |
| 5 | Изменить |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Текущий статус лимита
- Создать ограничения
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/agents/controllers/LimitController.php` (line 34)
- **Action kind**: inline
- **View rendered**: `index`

## See also

- Module reference: [/modules/agents](/docs/modules/agents)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
