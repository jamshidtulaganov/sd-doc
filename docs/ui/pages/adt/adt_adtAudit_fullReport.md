---
title: "Ритейл аудит"
audience: All sd-main developers, QA
summary: Live admin page at /adt/adtAudit/fullReport
topics: [adt, page, ui]
---

# Ритейл аудит

**URL**: `/adt/adtAudit/fullReport` · **Module**: `adt` · **Controller**: `AdtAuditController::fullReport` · **Role harvested**: `admin`

![Screenshot of Ритейл аудит](/screens/admin/adt_adtAudit_fullReport.jpg)

## Purpose

This page lives at `/adt/adtAudit/fullReport` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Категория товара | `—` | text | — |
| Категория клиентов | `—` | text | — |
| Территория | `—` | text | — |
| Канал сбыта | `—` | text | — |
| Тип торговой точки | `—` | text | — |
| Выбор аудитора | `—` | text | — |
| Аудит | `—` | text | — |
| Конкурентный анализ | `—` | text | — |
| Выбор опроса | `—` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Фильтр
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/AdtAuditController.php` (line 73)
- **Action kind**: inline
- **View rendered**: `full-report`
- **PageTitle()**: "Ритейл аудит"

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
