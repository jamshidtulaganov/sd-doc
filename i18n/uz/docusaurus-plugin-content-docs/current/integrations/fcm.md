---
sidebar_position: 7
title: Firebase FCM
---

# Firebase Cloud Messaging

Mobil agent ilovasiga push bildirishnomalar.

## Server hisob ma'lumotlari

`protected/config/stock_manager_service_account.json` da saqlanadi
(xizmat hisobi JSON). `FcmV1` komponenti
(`protected/components/FcmV1.php`) v1 HTTP API yordamida so'rovlarni
imzolaydi.

## Yuborish

```php
Yii::app()->fcm->send([
  'token' => $deviceToken,
  'title' => Yii::t('push', 'Order delivered'),
  'body'  => "#{$order->ORDER_ID}",
  'data'  => ['order_id' => $order->ORDER_ID],
]);
```

Yoki, ko'proq odatiy ravishda, ichida yuborish o'rniga `SendPushJob` ni
yuboring.

## Mavzular

- `tenant_<db>` — ijaradagi hammaga eshittirish.
- `agent_<id>` — yagona agent.
- `role_<n>` — rol bo'yicha (masalan, barcha kassirlar).

Obunalar kirish / rolni o'zgartirishda boshqariladi.
