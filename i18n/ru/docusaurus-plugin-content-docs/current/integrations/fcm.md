---
sidebar_position: 7
title: Firebase FCM
---

# Firebase Cloud Messaging

Push-уведомления в мобильное приложение агента.

## Серверные учётные данные

Хранятся в `protected/config/stock_manager_service_account.json` (JSON
сервисного аккаунта). Компонент `FcmV1`
(`protected/components/FcmV1.php`) подписывает запросы через v1 HTTP API.

## Отправка

```php
Yii::app()->fcm->send([
  'token' => $deviceToken,
  'title' => Yii::t('push', 'Order delivered'),
  'body'  => "#{$order->ORDER_ID}",
  'data'  => ['order_id' => $order->ORDER_ID],
]);
```

Или, как обычно, диспатчите `SendPushJob`, а не отправляйте inline.

## Топики

- `tenant_<db>` — broadcast всем в тенанте.
- `agent_<id>` — отдельный агент.
- `role_<n>` — на роль (например, всем кассирам).

Подписки управляются при входе / смене роли.
