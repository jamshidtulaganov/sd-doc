---
sidebar_position: 3
title: Основные сущности
---

# Основные сущности

Подробная справка по самым важным моделям. Списки полей ниже совпадают с
docblock'ами Yii-моделей.

## `Order`

`protected/models/Order.php`. Наследует `BaseFilial`.

| Колонка | Тип | Заметки |
|---------|-----|---------|
| `ORDER_ID` | string | Первичный ключ (UUID-подобный) |
| `DILER_ID` | string | Подразделение тенанта |
| `CLIENT_ID` | string | FK → `Client` |
| `AGENT_ID` | string | FK → `Agent` |
| `CITY_ID` | string | Географический скоуп |
| `PRICE_TYPE` | string | Активный прайс-лист |
| `STATUS` | int | См. [Order State Machine](../architecture/diagrams.md) |
| `SUB_STATUS` | int | Тонкий статус |
| `SUMMA` | float | Итог |
| `DEBT` | float | Непогашенная дебиторка |
| `DATE` | datetime | Подан |
| `DATE_LOAD` | datetime | Загружен на доставку |
| `DATE_DELIVERED` | datetime | Доставлен |
| `DATE_CANCEL` | datetime | Отменён |
| `STORE_ID` | string | Склад / магазин-источник |
| `XML_ID` | string | Внешний (1C) идентификатор |
| `SOURCE` | string | Канал (мобильный / web / online / импорт) |
| `CREATE_BY/AT`, `UPDATE_BY/AT` | – | Аудит |

Связи: `client`, `agent`, `lines (OrderProduct)`, `payments`,
`invoice`.

## `Client`

| Колонка | Тип | Заметки |
|---------|-----|---------|
| `CLIENT_ID` | string | Первичный ключ |
| `NAME` | string | Отображаемое имя |
| `INN` | string | Налоговый ID (используется для Faktura.uz / Didox) |
| `ADDRESS` | string | Адрес в свободной форме |
| `LAT`, `LNG` | decimal | Для геофенсинга |
| `CATEGORY_ID` | string | FK → `ClientCategory` |
| `CONTRACT_ID` | string | FK → `ContractClient` |
| `DEBT` | float | Срез |
| `ACTIVE` | char(1) | `Y` / `N` |
| `APPROVED` | int | 0 = на рассмотрении, 1 = одобрен |

## `Agent`

| Колонка | Заметки |
|---------|---------|
| `AGENT_ID` | PK |
| `NAME` | Полное имя |
| `TEL` | Телефон |
| `LOGIN` | Связан обратно через `User.AGENT_ID` |
| `CAR_ID` | Назначенный транспорт |
| `ACTIVE` | `Y` / `N` |
| `ROUTE_ID` | Дефолтный маршрут |

## `Product`

| Колонка | Заметки |
|---------|---------|
| `PRODUCT_ID` | PK |
| `NAME` | Отображаемое имя |
| `CODE` | Внутренний код |
| `XML_ID` | Внешний ID |
| `CATEGORY_ID` | FK → `Category` |
| `BRAND_ID` | FK → `Brand` |
| `UNIT` | Базовая единица |
| `UNIT_SYMBOL` | UI-символ |

## `Stock`

| Колонка | Заметки |
|---------|---------|
| `ID` | PK |
| `PRODUCT_ID` | FK |
| `WAREHOUSE_ID` | FK |
| `LOT` | Опционально |
| `COUNT` | Доступно |
| `RESERVED` | Зарезервировано заказами |
| `BLOCKED` | Качество / карантин |
