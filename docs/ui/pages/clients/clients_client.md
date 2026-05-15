---
title: "Sales Doctor - Client"
audience: All sd-main developers, QA
summary: Live admin page at /clients/client
topics: [clients, page, ui]
---

# Sales Doctor - Client

**URL**: `/clients/client` · **Module**: `clients` · **Controller**: `ClientController::index` · **RBAC**: `operation.clients.list` · **Role harvested**: `admin`

![Screenshot of Sales Doctor - Client](/screens/admin/clients_client.jpg)

## Purpose

This page lives at `/clients/client` in the live admin. It belongs to the **Clients** subsystem. Captured via the live harvester on the demo tenant; the screenshot above shows the page as it renders for the `admin` role on a 1440×900 viewport.

## Fields

| Label | Name | Type | Required |
|---|---|---|---|
| Ставка НсП | `nsp-bulk` | select | — |
| Максимальное кол-во заказов в день | `order[maxOrderQtyPerDay]` | text | — |
| Минимальная сумма заказа | `order[minSumma]` | text | — |
| Максимальная сумма заказа | `order[maxSumma]` | text | — |
| Максимальная сумма долга | `order[maxDebt]` | text | — |
| Максимальный срок просрочки (день) | `order[maxDebtDay]` | text | — |
| Срок консигнации по умолчанию (день) | `payment[consignmentPeriod]` | text | — |
| Направление торговли | `bot_order[tradeDirection][]` | select | — |
| Максимальное кол-во заказов в день | `trade[2][maxOrderQtyPerDay]` | text | — |
| Минимальная сумма заказа | `trade[2][minSumma]` | text | — |
| Максимальная сумма заказа | `trade[2][maxSumma]` | text | — |
| Максимальная сумма долга | `trade[2][maxDebt]` | text | — |
| Максимальный срок просрочки (день) | `trade[2][maxDebtDay]` | text | — |
| Максимальное кол-во заказов в день | `trade[11][maxOrderQtyPerDay]` | text | — |
| Минимальная сумма заказа | `trade[11][minSumma]` | text | — |
| Максимальная сумма заказа | `trade[11][maxSumma]` | text | — |
| Максимальная сумма долга | `trade[11][maxDebt]` | text | — |
| Максимальный срок просрочки (день) | `trade[11][maxDebtDay]` | text | — |
| Максимальное кол-во заказов в день | `trade[14][maxOrderQtyPerDay]` | text | — |
| Минимальная сумма заказа | `trade[14][minSumma]` | text | — |
| Максимальная сумма заказа | `trade[14][maxSumma]` | text | — |
| Максимальная сумма долга | `trade[14][maxDebt]` | text | — |
| Максимальный срок просрочки (день) | `trade[14][maxDebtDay]` | text | — |
| Максимальное кол-во заказов в день | `trade[15][maxOrderQtyPerDay]` | text | — |
| Минимальная сумма заказа | `trade[15][minSumma]` | text | — |
| Максимальная сумма заказа | `trade[15][maxSumma]` | text | — |
| Максимальная сумма долга | `trade[15][maxDebt]` | text | — |
| Максимальный срок просрочки (день) | `trade[15][maxDebtDay]` | text | — |
| Максимальное кол-во заказов в день | `trade[16][maxOrderQtyPerDay]` | text | — |
| Минимальная сумма заказа | `trade[16][minSumma]` | text | — |
| Максимальная сумма заказа | `trade[16][maxSumma]` | text | — |
| Максимальная сумма долга | `trade[16][maxDebt]` | text | — |
| Максимальный срок просрочки (день) | `trade[16][maxDebtDay]` | text | — |

## Actions

- Найти страницы
- Сохранить
- Отмена
- Закрыть
- Неподтвержденные клиенты
- История изменения визитов
- QR-kod
- Общая конфигурация
- Экспорт в файл Google Earth
- Групповая обработка
- Toggle Dropdown
- Импортировать из 2GIS ссылок
- Добавить клиента
- Мерчендайзер
- Выбрать все
- Убрать все
- Агент
- Территория
- Категории клиентов
- Тип цены
- День
- Экспедитор
- Активный
- Локация
- май 12 - май 15
- Тип ТТ
- Канал сбыта
- Класс клиента
- Все недели
- ИНН

## Backend route

- **Controller file**: `protected/modules/clients/controllers/ClientController.php` (line 154)
- **Action kind**: inline
- **View rendered**: `index`
- **Required permission**: `operation.clients.list`

## See also

- Module reference: [/modules/clients](/docs/modules/clients)
- Routes inventory: [`static/data/routes.json`](/data/routes.json)
- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)
