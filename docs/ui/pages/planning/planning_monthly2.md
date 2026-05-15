---
title: "Результаты выполнения плана"
audience: All sd-main developers, QA
summary: Live admin page at /planning/monthly2
topics: [planning, page, ui]
---

# Результаты выполнения плана

**URL**: `/planning/monthly2` · **Module**: `planning` · **Controller**: `Monthly2Controller::index` · **RBAC**: `operation.planning.results` · **Role harvested**: `admin`

![Screenshot of Результаты выполнения плана](/screens/admin/planning_monthly2.jpg)

## Purpose

This page lives at `/planning/monthly2` in the live admin. It belongs to the **Planning** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Кол-во рабочих дней: 26
- Отработано: 13
- Осталось: 13
- Категория товара
- Выбрать все
- Убрать все
- Супервайзер
- 2026
- Май
- Дата отгрузки
- ×
- Последний месяц
- Получить рекомендацию
- Факт
- Факт (общий)
- Прогноз
- Развернуть все
- Excel
- Все категории Категория с планом Категория без плана
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/planning/controllers/Monthly2Controller.php` (line 8)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Результаты выполнения плана"
- **Required permission**: `operation.planning.results`

## See also

- Module reference: [/modules/planning](/docs/modules/planning)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
