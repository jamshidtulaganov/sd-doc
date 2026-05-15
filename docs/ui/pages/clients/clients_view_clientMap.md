---
title: "Агенты"
audience: All sd-main developers, QA
summary: Live admin page at /clients/view/clientMap
topics: [clients, page, ui]
---

# Агенты

**URL**: `/clients/view/clientMap` · **Module**: `clients` · **Controller**: `ViewController::clientMap` · **RBAC**: `operation.clients.update` · **Role harvested**: `admin`

![Screenshot of Агенты](/screens/admin/clients_view_clientMap.jpg)

## Purpose

This page lives at `/clients/view/clientMap` in the live admin. It belongs to the **Clients** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Дни недели | `—` | text | — |
| Агенты | `—` | text | — |
| Территория | `—` | text | — |
| Категория клиента | `—` | text | — |
| Тип клиента | `—` | text | — |
| Активность клиентов | `—` | text | — |
| Тип визита | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Категория клиента |
| 2 | Кол.клиентов |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Печать
- Фильтр
- Сбросить фильтр
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/clients/controllers/ViewController.php` (line 89)
- **Action kind**: inline
- **View rendered**: `clientMap/index`
- **Required permission**: `operation.clients.update`

## See also

- Module reference: [/modules/clients](/docs/modules/clients)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
