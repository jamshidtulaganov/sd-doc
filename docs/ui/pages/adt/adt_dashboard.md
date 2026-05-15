---
title: "Sales Doctor - Dashboard"
audience: All sd-main developers, QA
summary: Live admin page at /adt/dashboard
topics: [adt, page, ui]
---

# Sales Doctor - Dashboard

**URL**: `/adt/dashboard` · **Module**: `adt` · **Controller**: `DashboardController::index` · **RBAC**: `operation.adtReports.daily` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Dashboard](/screens/admin/adt_dashboard.jpg)

## Purpose

This page lives at `/adt/dashboard` in the live admin. It belongs to the **ADT audit** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Название задачи * | `NAME` | text | — |
| Дата выполнения * | `—` | div | — |
| Комментарий | `COMMENT` | textarea | — |

## Grid columns

| # | Column |
|---|---|
| 1 | # |
| 2 | Имя |
| 3 | По плану |
| 4 | Вне плана |
| 5 | Начало |
| 6 | Конец |
| 7 | План |
| 8 | Посещено |
| 9 | Не посещено |
| 10 | Посещение |
| 11 | Посещено |
| 12 | Посещение |
| 13 | Опрос |
| 14 | Аудит |
| 15 | Фото |
| 16 | Коммент |
| 17 | Опрос |
| 18 | Аудит |
| 19 | Фото |
| 20 | Коммент |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Все картинки
- 📥Экспорт
- Все картинки (0)
- Открепить
- Сбросить
- Вернуться назад
- Текущее фото
- Все фото
- Выбрать
- angela (Мерчендайзер)
- Полка
- Загрузить еще
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/adt/controllers/DashboardController.php` (line 16)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.adtReports.daily`

## See also

- Module reference: [/modules/audit-adt](/docs/modules/audit-adt)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
