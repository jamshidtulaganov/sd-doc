---
title: "Рассылки СМС"
audience: All sd-main developers, QA
summary: Live admin page at /sms/view/list
topics: [sms, page, ui]
---

# Рассылки СМС

**URL**: `/sms/view/list` · **Module**: `sms` · **Controller**: `ViewController::list` · **RBAC**: `operation.sms.list` · **Role harvested**: `admin`

![Screenshot of Рассылки СМС](/screens/admin/sms_view_list.jpg)

## Purpose

This page lives at `/sms/view/list` in the live admin. It belongs to the **SMS** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | # |
| 2 | Шаблон сообщения |
| 3 | Получатели |
| 4 | Дата отправки |
| 5 | Создано |
| 6 | Действие |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- СМС рассылка
- Шаблоны сообщений
- Новая рассылка
- Купить CMC пакет
- Перезагрузить
- Загрузить
- Блокировать
- Разрешить
- ×
- OK
- No
- Cancel

## Backend route

- **Controller file**: `protected/modules/sms/controllers/ViewController.php` (line 5)
- **Action kind**: inline
- **View rendered**: `pages/list/index`
- **PageTitle()**: "Рассылки СМС"
- **Required permission**: `operation.sms.list`

## See also

- Module reference: [/modules/sms](/docs/modules/sms)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
