---
title: "Sales Doctor - Excretion"
audience: All sd-main developers, QA
summary: Live admin page at /stock/excretion
topics: [stock, page, ui]
---

# Sales Doctor - Excretion

**URL**: `/stock/excretion` · **Module**: `stock` · **Controller**: `ExcretionController::index` · **RBAC**: `operation.stock.excretion` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Excretion](/screens/admin/stock_excretion.jpg)

## Purpose

This page lives at `/stock/excretion` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Дата списания |
| 2 | Дата создания |
| 3 | Количество |
| 4 | Склад |
| 5 | Сумма (Оценка) |
| 6 | Комментарии |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Добавить
- Отчет за период
- Склад
- Выбрать все
- Убрать все
- Выберите тип цены для оценки
- май 1 - май 31
- По 20
- Показ./Скр. столбцы
- Excel
- Блокировать
- Разрешить
- OK
- Отменить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/ExcretionController.php` (line 72)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.excretion`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
