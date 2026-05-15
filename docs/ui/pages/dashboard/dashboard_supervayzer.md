---
title: "Общая сумма заявок на 15 мая."
audience: All sd-main developers, QA
summary: Live admin page at /dashboard/supervayzer
topics: [dashboard, page, ui]
---

# Общая сумма заявок на 15 мая.

**URL**: `/dashboard/supervayzer` · **Module**: `dashboard` · **Controller**: `SupervayzerController::index` · **RBAC**: `operation.dashboard.supervayzer` · **Role harvested**: `admin`

![Screenshot of Общая сумма заявок на 15 мая.](/screens/admin/dashboard_supervayzer.jpg)

## Purpose

This page lives at `/dashboard/supervayzer` in the live admin. It belongs to the **Dashboard** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Название задачи * | `NAME` | text | — |
| Дата выполнения * | `—` | div | — |
| Комментарий | `COMMENT` | textarea | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Категория |
| 2 | Доля |
| 3 | Сумма |
| 4 | Объем |
| 5 | Блок |
| 6 | Количество |
| 7 | АКБ |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Новый, Отгружен, Доставлен
- Выбрать все
- Убрать все
- Категории продуктов
- Территория
- Категория клиентов
- 15 мая.
- По 10
- Excel
- По 20
- Показ./Скр. столбцы
- Скрыть категории без продаж
- ×
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

- **Controller file**: `protected/modules/dashboard/controllers/SupervayzerController.php` (line 122)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Дашборд"
- **Required permission**: `operation.dashboard.supervayzer`

## See also

- Module reference: [/modules/dashboard](/docs/modules/dashboard)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
