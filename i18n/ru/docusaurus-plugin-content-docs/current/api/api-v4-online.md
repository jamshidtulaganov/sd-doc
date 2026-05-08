---
sidebar_position: 6
title: API v4 — Онлайн / B2B
---

# API v4 — портал онлайн-заказов и новые мобильные клиенты

Более новая поверхность. Более чистое разделение ответственности:

| Область | Контроллер |
|---------|------------|
| Аутентификация | `LoginController` |
| Регистрация устройства | `DeviceController` |
| Конфигурация | `ConfigController` |
| Просмотр каталога | `CatalogController` |
| Клиенты | `ClientController` / `ClientsController` |
| Создание / редактирование / список заказов | `CreateController`, `EditController`, `OrderController`, `ListController`, `GetController` |
| Сток | `StockController`, `StockmanController` |
| Дефекты | `DefectController` |
| Инвентаризация | `InventoryController` |
| Визиты | `VisitsController` |
| Платежи | `PaymentController`, `OnlinePaymentController` |
| Тара (упаковка) | `TaraController` |
| Рекомендации | `RecommendedSaleController`, `MustBuyRuleController` |
| KPI | `KpiController` |
| Операции агента | `AgentController` |

## Аутентификация

Bearer-токен (`Authorization: Bearer <token>`). Токены получаются из
`POST /api4/login/index` и хранятся вместе с `device_id`.

## Соглашения схемы

- `application/json` в запросе и ответе.
- Имена полей в `snake_case` везде.
- Денежные поля — целочисленные минорные единицы (суммы в UZS иногда
  огромны — используйте `bigint` на клиенте).
- ID — строки (UUID-подобные или legacy-формат `<filial>_<seq>`).
- Пагинация: `?page` / `?limit`, в обёртке ответа есть `total`.

## Редирект онлайн-платежа

```
POST /api4/onlinePayment/start
↓ возвращает
{
  "success": true,
  "redirect_url": "https://provider.example.com/pay?token=..."
}
```

После того как провайдер перенаправляет обратно на настроенный колбэк,
`OnlinePaymentController::actionCallback()` валидирует подпись и
обновляет `PAY_STATUS` заказа.

## Когда вызывать v3 vs v4

| Кейс | Поверхность |
|------|-------------|
| Приложение полевого агента (существующее) | v3 |
| Новый B2B веб/мобильный портал | v4 |
| Telegram WebApp | v4 |
| Партнёрский бэкенд (server-to-server) | v4 |
| Одноразовый legacy-коннектор | v1 |
