---
title: "Результат выполнения плана"
audience: All sd-main developers, QA
summary: Live admin page at /stock/planProduct
topics: [stock, page, ui]
---

# Результат выполнения плана

**URL**: `/stock/planProduct` · **Module**: `stock` · **Controller**: `PlanProductController::index` · **RBAC**: `operation.planning.byproduct` · **Role harvested**: `admin`

![Screenshot of Результат выполнения плана](/screens/admin/stock_planProduct.jpg)

## Purpose

This page lives at `/stock/planProduct` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Показано в | `—` | text | — |
| Супервайзеры | `—` | text | — |
| Агенты | `—` | text | — |
| Категория | `—` | text | — |
| Сегмент | `—` | text | — |
| Товары | `—` | text | — |
| Только с планом | `—` | checkbox | — |

## Grid columns

| # | Column |
|---|---|
| 1 | Продукты |
| 2 | 11111 |
| 3 | Agent Javoxir |
| 4 | Agent007 |
| 5 | Anvar Rashidowv |
| 6 | Avazhon |
| 7 | beck |
| 8 | Bobz |
| 9 | dimaprod |
| 10 | Dmitriy M VS |
| 11 | Dmitry Agent |
| 12 | Feruzov Anvar |
| 13 | Gleb agent |
| 14 | Sotuvchi |
| 15 | TP-22 |
| 16 | Usmon |
| 17 | Van selling |
| 18 | Vansell Max |
| 19 | Авдеев Севдар |
| 20 | Азизбек Азизбеков |
| 21 | Александр Кузнецcкий |
| 22 | Мадаминбек |
| 23 | Михаил Леонтьев |
| 24 | №3 Van-Sell Jack |
| 25 | №5 Мадаминбек VS |
| 26 | План |
| 27 | Факт |
| 28 | План |
| 29 | Факт |
| 30 | План |
| 31 | Факт |
| 32 | План |
| 33 | Факт |
| 34 | План |
| 35 | Факт |
| 36 | План |
| 37 | Факт |
| 38 | План |
| 39 | Факт |
| 40 | План |
| 41 | Факт |
| 42 | План |
| 43 | Факт |
| 44 | План |
| 45 | Факт |
| 46 | План |
| 47 | Факт |
| 48 | План |
| 49 | Факт |
| 50 | План |
| 51 | Факт |
| 52 | План |
| 53 | Факт |
| 54 | План |
| 55 | Факт |
| 56 | План |
| 57 | Факт |
| 58 | План |
| 59 | Факт |
| 60 | План |
| 61 | Факт |
| 62 | План |
| 63 | Факт |
| 64 | План |
| 65 | Факт |
| 66 | План |
| 67 | Факт |
| 68 | План |
| 69 | Факт |
| 70 | План |
| 71 | Факт |
| 72 | План |
| 73 | Факт |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Экспорт
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/PlanProductController.php` (line 86)
- **Action kind**: inline
- **View rendered**: `index`
- **PageTitle()**: "Результат выполнения плана"
- **Required permission**: `operation.planning.byproduct`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
