---
title: "Экспедиторы"
audience: All sd-main developers, QA
summary: Live admin page at /staff/view/expeditor
topics: [staff, page, ui]
---

# Экспедиторы

**URL**: `/staff/view/expeditor` · **Module**: `staff` · **Controller**: `ViewController::expeditor` · **RBAC**: `operation.expeditor.list` · **Role harvested**: `admin`

![Screenshot of Экспедиторы](/screens/admin/staff_view_expeditor.jpg)

## Purpose

This page lives at `/staff/view/expeditor` in the live admin. It belongs to the **Staff** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Ф.И.О. |
| 2 | Логин |
| 3 | Телефон |
| 4 | Версия приложения |
| 5 | Адрес |
| 6 | Доступ к приложению |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Конфигурация
- Добавить экспедитора
- Групповая обработка
- Показать по
- Excel
- Удалить доступ
- Добавить доступ
- 1
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/staff/controllers/ViewController.php` (line 17)
- **Action kind**: inline
- **View rendered**: `expeditor/index`
- **PageTitle()**: "Экспедиторы"
- **Required permission**: `operation.expeditor.list`

## See also

- Module reference: [/modules/settings-access-staff](/docs/modules/settings-access-staff)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
