---
title: "Sales Doctor - Report"
audience: All sd-main developers, QA
summary: Live admin page at /stock/report
topics: [stock, page, ui]
---

# Sales Doctor - Report

**URL**: `/stock/report` · **Module**: `stock` · **Controller**: `ReportController::index` · **RBAC**: `operation.stock.recommend` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Report](/screens/admin/stock_report.jpg)

## Purpose

This page lives at `/stock/report` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Категория
- Выбрать все
- Убрать все
- Группа товаров
- Бренд
- Склад
- Продукт
- Количество
- 6 дней, 10 дней, 30 дней
- Количество дней продаж
- Продажи + Бонус
- Все товары
- Блокировать
- Разрешить

## Backend route

- **Controller file**: `protected/modules/stock/controllers/ReportController.php` (line 29)
- **Action kind**: inline
- **Required permission**: `operation.stock.recommend`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
