---
title: "Sales Doctor - Stock"
audience: All sd-main developers, QA
summary: Live admin page at /clients/stock
topics: [clients, page, ui]
---

# Sales Doctor - Stock

**URL**: `/clients/stock` · **Module**: `clients` · **Controller**: `StockController::index` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Stock](/screens/admin/clients_stock.jpg)

## Purpose

This page lives at `/clients/stock` in the live admin. It belongs to the **Clients** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Grid columns

| # | Column |
|---|---|
| 1 | Дата |
| 2 | Клиент |
| 3 | Территория |
| 4 | Агент |
| 5 | Категория продукта |
| 6 | Продукт |
| 7 | Кол-во |
| 8 | Кол-во (Продажа) |
| 9 | Объём |
| 10 | Сумма |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Базовая представленность
- Коэффициент продажи
- Агенты
- Выбрать все
- Убрать все
- Территория
- май 9 - май 15
- Категории продуктов
- Продукты
- Закуп
- По 20
- Показ./Скр. столбцы
- Excel
- Скачать шаблон
- Загрузить шаблон
- ×
- Обновить
- Блокировать
- Разрешить
- OK
- Отменить

## Backend route

- **Controller file**: `protected/modules/clients/controllers/StockController.php` (line 45)
- **Action kind**: inline
- **View rendered**: `index`

## See also

- Module reference: [/modules/clients](/docs/modules/clients)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
