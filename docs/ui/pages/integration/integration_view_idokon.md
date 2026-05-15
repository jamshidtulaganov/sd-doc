---
title: "Клиенты с iDokon (POS)"
audience: All sd-main developers, QA
summary: Live admin page at /integration/view/idokon
topics: [integration, page, ui]
---

# Клиенты с iDokon (POS)

**URL**: `/integration/view/idokon` · **Module**: `integration` · **Controller**: `ViewController::idokon` · **RBAC**: `operation.idokon.incoming.request` · **Role harvested**: `admin`

![Screenshot of Клиенты с iDokon (POS)](/screens/admin/integration_view_idokon.jpg)

## Purpose

This page lives at `/integration/view/idokon` in the live admin. It belongs to the **Integration** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Статус | `—` | text | — |
| Агент | `—` | text | — |
| Территория | `—` | text | — |
| День посещения | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Клиент Идокона |
| 2 | Телефон |
| 3 | Статус |
| 4 | Название клиента |
| 5 | Агент |
| 6 | Тип цены |
| 7 | День |
| 8 | Дата создания |
| 9 | Действие |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Скачать QR для iDokon
- Рекомендованная продажа
- Показать по
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/integration/controllers/ViewController.php` (line 5)
- **Action kind**: inline
- **View rendered**: `idokon/index`
- **PageTitle()**: "Клиенты с iDokon (POS)"
- **Required permission**: `operation.idokon.incoming.request`

## See also

- Module reference: [/modules/integration](/docs/modules/integration)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
