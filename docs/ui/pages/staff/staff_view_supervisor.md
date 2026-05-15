---
title: "Супервайзеры"
audience: All sd-main developers, QA
summary: Live admin page at /staff/view/supervisor
topics: [staff, page, ui]
---

# Супервайзеры

**URL**: `/staff/view/supervisor` · **Module**: `staff` · **Controller**: `ViewController::supervisor` · **RBAC**: `operation.supervayzer.list` · **Role harvested**: `admin`

![Screenshot of Супервайзеры](/screens/admin/staff_view_supervisor.jpg)

## Purpose

This page lives at `/staff/view/supervisor` in the live admin. It belongs to the **Staff** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | # |
| 2 | Ф.И.О. |
| 3 | Агент |
| 4 | Логин |
| 5 | Активность |
| 6 | Доступ к приложению |
| 7 | Действия |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Добавить супервайзера
- Показать по
- Удалить доступ
- Добавить доступ
- 1
- 2
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/staff/controllers/ViewController.php` (line 23)
- **Action kind**: inline
- **View rendered**: `supervisor/index`
- **PageTitle()**: "Супервайзеры"
- **Required permission**: `operation.supervayzer.list`

## See also

- Module reference: [/modules/settings-access-staff](/docs/modules/settings-access-staff)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
