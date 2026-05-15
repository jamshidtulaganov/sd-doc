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

## Controller endpoints in sd-main

### Server component

`FcmV1` — `protected/components/FcmV1.php`. Configured via the
service-account JSON at
`protected/config/stock_manager_service_account.json`. Signs requests
using the FCM v1 HTTP API.

### Push admin / device-registration routes

`api/PushController` — `protected/modules/api/controllers/PushController.php`.
Live routes (from `routes.json`, all `noRbac` — auth via the api token):

| Action | Route | Purpose |
|--------|-------|---------|
| `save` | `POST /api/push/save` | Register a device token |
| `update` | `POST /api/push/update` | Update a device token / topic subscription |
| `delete` | `POST /api/push/delete` | Unregister a token |
| `send` | `POST /api/push/send` | Send a one-off push (admin / internal use) |
| `serviceworker` | `GET /api/push/serviceworker` | Serve the web-push service worker JS |

The mobile-app side uses the same component via `SendNotificationJob`
(see `protected/components/jobs/SendNotificationJob.php`).

## See also

- [Jobs and scheduling](../architecture/jobs-and-scheduling.md) —
  `SendNotificationJob` runs FCM dispatch off the request thread.
- [API v3 mobile](../api/api-v3-mobile/) — the mobile app registers
  device tokens at login.
