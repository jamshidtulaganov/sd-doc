---
sidebar_position: 5
title: API v3 — Мобильный
---

# API v3 — мобильное приложение агента

Активная поверхность, используемая мобильным приложением полевого
торгового агента. Аутентификация на основе токенов с регистрацией
устройства FCM/APNS.

## Карта эндпоинтов

| Путь | Контроллер | Назначение |
|------|------------|------------|
| `POST /api3/login/index` | `LoginController` | Вход по login/password/deviceToken |
| `POST /api3/logout/index` | `LogoutController` | Выход, очищает device token |
| `GET /api3/config/index` | `ConfigController` | Конфигурация сервера (feature flags, валюты) |
| `GET /api3/client/list` | `ClientController` | Синхронизация клиентов на маршруте агента |
| `POST /api3/client/create` | `ClientController` | Клиент, созданный в полях (pending) |
| `GET /api3/product/list` | `ProductController` | Синхронизация каталога |
| `GET /api3/product2/list` | `Product2Controller` | Синхронизация каталога v2 (текущая) |
| `GET /api3/productCategory/index` | `ProductCategoryController` | Дерево категорий |
| `GET /api3/priceType/index` | `PriceTypeController` | Типы цен |
| `POST /api3/order/create` | `OrderController` | Отправка нового заказа |
| `GET /api3/order/list` | `OrderController` | Заказы агента |
| `POST /api3/photo/index` | `PhotoController` | Загрузка фото визита |
| `POST /api3/visit/index` | `VisitController` | Check-in / check-out |
| `GET /api3/gps/index` | `GpsController` | Отправка GPS-сэмплов |
| `POST /api3/auditor/index` | `AuditorController` | Отправка форм аудита |
| `POST /api3/defect/index` | `DefectController` | Сообщение о дефектах |
| `POST /api3/reject/index` | `RejectController` | Отказ от доставки |
| `POST /api3/inventory/index` | `InventoryController` | Сканирование инвентаризации |
| `GET /api3/stock/index` | `StockController` | Доступный сток на складе |
| `POST /api3/store/index` | `StoreController` | Операции на стороне магазина |
| `POST /api3/expeditor/index` | `ExpeditorController` | Подтверждение доставки |
| `POST /api3/expeditor2/index` | `Expeditor2Controller` | Поток экспедитора v2 |
| `POST /api3/finans/index` | `FinansController` | Сбор наличных |
| `GET /api3/history/index` | `HistoryController` | История активности агента |
| `GET /api3/kpi/index` | `KpiController` | KPI агента |
| `POST /api3/task/index` | `TaskController` | Назначение задач |
| `POST /api3/contract/index` | `ContractController` | Отправка договора |
| `POST /api3/tara/index` | `TaraController` | Возвратная тара |
| `POST /api3/photo/index` | `PhotoController` | Загрузка фото |

## Вход {#login}

Полный запрос/ответ см. в разделе [Аутентификация](./authentication.md).

## Визиты {#visits}

```http
POST /api3/visit/index
{
  "client_id": "C123",
  "type": "checkin",
  "lat": 41.31,
  "lng": 69.28,
  "ts": "2026-05-07T08:14:22Z"
}
```

`type`: `checkin` | `checkout`. Сервер проверяет геозону относительно
`client.LAT/LNG` и настроенного радиуса (настройки `gps`).

## Создание заказа

```http
POST /api3/order/create
{
  "client_id": "C123",
  "price_type": "wholesale",
  "lines": [
    { "product_id": "P77", "count": 12, "price": 9500 },
    { "product_id": "P88", "count": 4, "price": 22000 }
  ],
  "comment": "Delivery tomorrow",
  "currency": "UZS"
}
```

Ответ:

```json
{
  "success": true,
  "order_id": "O-2026-000123",
  "status": 1
}
```

Ошибки включают `INSUFFICIENT_STOCK`, `OVER_CREDIT_LIMIT`, `INVALID_CLIENT`,
`PRICE_MISMATCH`. См. [Коды ошибок](./error-codes.md).

## Сэмплирование GPS

Мобильное приложение отправляет батчи GPS-сэмплов на `POST /api3/gps/index` —
обычно каждые 30 с, пока приложение в foreground. Сэмплы пишутся в
`gps_track` и потребляются интерфейсом мониторинга `gps3`.
