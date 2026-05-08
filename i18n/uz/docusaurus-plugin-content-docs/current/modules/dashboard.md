---
sidebar_position: 16
title: dashboard
---

# `dashboard` moduli

Super-admin / admin / menejer / nazoratchi uchun KPI dashboardlari. Birlashmalar bilan og'ir — agressiv keshlang (60s TTL odatda).

## Kontrollerlar

`DefaultController` (qo'nish sahifasi), `BillingController`, `CategoryController`,
`CsController` (mijozlar xizmati), `AlisherController` (eski nomli dashboard).

## Plitkalar

Odatiy plitka avval `redis_app` dan o'qiydi, SQL birlashmasiga qaytadi. Plitka ma'lumotlarining shakli:

```php
[
  'title' => 'Today\'s orders',
  'value' => 1247,
  'delta' => '+12%',
  'spark' => [/* 14 daily values */],
]
```
