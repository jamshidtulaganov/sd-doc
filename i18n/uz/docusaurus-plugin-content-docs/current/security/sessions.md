---
sidebar_position: 4
title: Sessiyalar
---

# Sessiyalar

## Saqlash

Redis db0 ustida `CCacheHttpSession`. `keyPrefix = HTTP_HOST` bilan
sozlangan. Ikki ta'sir:

1. Har bir subdomen alohida sessiya hovuziga ega.
2. Redis dagi `FLUSHDB 0` har bir sessiyani o'chiradi (ehtiyotkorlik bilan
   ishlatiling).

## TTL

Sukut bo'yicha 7200 s (2 soat). Kerak bo'lsa `main_local.php` da
oshiring:

```php
'session' => [ 'class' => 'CCacheHttpSession', 'cacheID' => 'redis_session', 'timeout' => 14400 ],
```

## Cookie lar

- HttpOnly = ha
- Secure = ha (production)
- SameSite = Lax

## Tizimdan chiqish

`Site/logout` sessiyani o'chiradi va auth bilan bog'liq cookie larni
tozalaydi. Mobil uchun, `POST /api3/logout/index` device token qatorini
tozalaydi, lekin mijoz ham o'zining bearer tokenini tashlab yuborishi
kerak.
