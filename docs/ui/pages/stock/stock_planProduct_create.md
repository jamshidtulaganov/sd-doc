---
title: "Установка плана по товарам"
audience: All sd-main developers, QA
summary: Live admin page at /stock/planProduct/create
topics: [stock, page, ui]
---

# Установка плана по товарам

**URL**: `/stock/planProduct/create` · **Module**: `stock` · **Controller**: `PlanProductController::create` · **RBAC**: `operation.planning.byproductCreate` · **Role harvested**: `admin`

![Screenshot of Установка плана по товарам](/screens/admin/stock_planProduct_create.jpg)

## Purpose

This page lives at `/stock/planProduct/create` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Тип продукта | `—` | text | — |
| Агенты | `—` | text | — |
| Категория продукта | `—` | text | — |
| Товары | `—` | text | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Продукты |
| 2 | 11111 |
| 3 | Agent Javoxir |
| 4 | Agent007 |
| 5 | Anvar Rashidowv |
| 6 | Avazhon |
| 7 | Bobz |
| 8 | Dmitriy M VS |
| 9 | Dmitry Agent |
| 10 | Feruzov Anvar |
| 11 | Gleb agent |
| 12 | Sotuvchi |
| 13 | TP-22 |
| 14 | Usmon |
| 15 | Van selling |
| 16 | Vansell Max |
| 17 | beck |
| 18 | dimaprod |
| 19 | Авдеев Севдар |
| 20 | Азизбек Азизбеков |
| 21 | Александр Кузнецcкий |
| 22 | Мадаминбек |
| 23 | Михаил Леонтьев |
| 24 | №3 Van-Sell Jack |
| 25 | №5 Мадаминбек VS |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Образец
- Импортировать с Excel
- Фильтр
- +
- −
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PlanProductController.php` (line 38)
- **Action kind**: inline
- **View rendered**: `create`
- **PageTitle()**: "Установка плана по товарам"
- **Required permission**: `operation.planning.byproductCreate`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
