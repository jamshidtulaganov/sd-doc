---
title: "Sales Doctor - Taradoc"
audience: All sd-main developers, QA
summary: Live admin page at /clients/taradoc
topics: [clients, page, ui]
---

# Sales Doctor - Taradoc

**URL**: `/clients/taradoc` · **Module**: `clients` · **Controller**: `TaradocController::index` · **RBAC**: `operation.reports.tara` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Taradoc](/screens/admin/clients_taradoc.jpg)

## Purpose

This page lives at `/clients/taradoc` in the live admin. It belongs to the **Clients** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Тары | `—` | text | — |
| Категория клиента | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Тара |
| 2 | Остаток |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Показать по
- Excel
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/clients/controllers/TaradocController.php` (line 46)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.reports.tara`

## See also

- Module reference: [/modules/clients](/docs/modules/clients)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
