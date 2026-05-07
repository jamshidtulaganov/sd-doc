---
sidebar_position: 7
title: Firebase FCM
---

# Firebase Cloud Messaging

Push notifications to the mobile agent app.

## Server credentials

Stored at `protected/config/stock_manager_service_account.json` (service
account JSON). The `FcmV1` component
(`protected/components/FcmV1.php`) signs requests using the v1 HTTP API.

## Sending

```php
Yii::app()->fcm->send([
  'token' => $deviceToken,
  'title' => Yii::t('push', 'Order delivered'),
  'body'  => "#{$order->ORDER_ID}",
  'data'  => ['order_id' => $order->ORDER_ID],
]);
```

Or, more typically, dispatch a `SendPushJob` rather than sending inline.

## Topics

- `tenant_<db>` — broadcast to everyone in a tenant.
- `agent_<id>` — single agent.
- `role_<n>` — role-wide (e.g. all cashiers).

Subscriptions managed at login / role change.
