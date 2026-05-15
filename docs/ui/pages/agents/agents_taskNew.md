---
title: "Список задач"
audience: All sd-main developers, QA
summary: Live admin page at /agents/taskNew
topics: [agents, page, ui]
---

# Список задач

**URL**: `/agents/taskNew` · **Module**: `agents` · **Controller**: `TaskNewController::index` · **RBAC**: `operation.task.list` · **Role harvested**: `admin`

![Screenshot of Список задач](/screens/admin/agents_taskNew.jpg)

## Purpose

This page lives at `/agents/taskNew` in the live admin. It belongs to the **Agents** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Назначающий | `—` | text | — |
| Исполнитель | `—` | text | — |
| Статус | `—` | text | — |
| Тип | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Задание |
| 2 | Клиент |
| 3 | Назначающий |
| 4 | Исполнитель |
| 5 | Дата создания |
| 6 | Срок выполнения |
| 7 | Фото задачи |
| 8 | Фото результата |
| 9 | Тип задачи |
| 10 | Статус |
| 11 | Комментарий назначающего |
| 12 | Комментарий исполнителя |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Загрузить
- Сбросить фильтр
- Добавить
- Показать по
- Excel
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/agents/controllers/TaskNewController.php` (line 6)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Список задач"
- **Required permission**: `operation.task.list`

## See also

- Module reference: [/modules/agents](/docs/modules/agents)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
