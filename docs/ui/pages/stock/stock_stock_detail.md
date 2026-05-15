---
title: "Sales Doctor - Detail Stock"
audience: All sd-main developers, QA
summary: Live admin page at /stock/stock/detail
topics: [stock, page, ui]
---

# Sales Doctor - Detail Stock

**URL**: `/stock/stock/detail` · **Module**: `stock` · **Controller**: `StockController::detail` · **RBAC**: `operation.stock.detail` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Detail Stock](/screens/admin/stock_stock_detail.jpg)

## Purpose

This page lives at `/stock/stock/detail` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Склад реализации
- Склад возврата
- Склад резерва
- Склад
- Выбрать все
- Убрать все
- Категории продуктов
- Группа продуктов
- Подкатегории продуктов
- Все продукты
- Количество
- Все
- По сорт. номеру продукта и категории
- Бренд
- Показать все
- Все данные
- Основные данные
- Сбросить фильтр
- Excel
- Движения товаров на складе
- Движение одного товара
- ×
- ЗАКРЫТЬ
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/StockController.php` (line 243)
- **Action kind**: inline
- **View rendered**: `detail`
- **Required permission**: `operation.stock.detail`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
