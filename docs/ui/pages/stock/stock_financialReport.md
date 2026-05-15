---
title: "Sales Doctor - FinancialReport"
audience: All sd-main developers, QA
summary: Live admin page at /stock/financialReport
topics: [stock, page, ui]
---

# Sales Doctor - FinancialReport

**URL**: `/stock/financialReport` · **Module**: `stock` · **Controller**: `FinancialReportController::index` · **RBAC**: `operation.stock.profit` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - FinancialReport](/screens/admin/stock_financialReport.jpg)

## Purpose

This page lives at `/stock/financialReport` in the live admin. It belongs to the **Stock** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Категории продуктов
- Выбрать все
- Убрать все
- Группа товаров
- Продукты
- Типы цен
- Тип операции
- Склад
- май 9 - май 15
- Нет
- Да
- ×
- Начальный отчет
- Отменить
- Блокировать
- Разрешить
- OK

## Backend route

- **Controller file**: `protected/modules/stock/controllers/FinancialReportController.php` (line 93)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.stock.profit`

## See also

- Module reference: [/modules/stock](/docs/modules/stock)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
