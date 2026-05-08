---
sidebar_position: 4
title: Keshlash
---

# Keshlash

## Uchta Redis ma'lumotlar bazasi, har biri bitta vazifa bilan

| Redis DB | Komponent | Maqsadi |
|----------|-----------|---------|
| **db0** | `redis_session` (`CRedisCache`) | HTTP sessiya saqlash. Prefiks: `HTTP_HOST:` |
| **db1** | `queueRedis` (`RedisConnection`) | Background ish navbati (`BaseJob` payload lari) |
| **db2** | `redis_app` (`CRedisCache`) | Ilova keshi, `TenantContext` orqali scope qilingan |

Bittasiga `FLUSHDB` qilish boshqalariga ta'sir **qilmaydi**.

## Keshni qachon ishlatish kerak

- ✅ Yozilganidan 100× ko'p o'qiladigan qidiruvlar (narx turlari,
  kategoriya daraxti, authitem ierarxiyasi, filial ro'yxati).
- ✅ Qimmat agregatlar (dashboard KPI lari, qarz miqdorlari).
- ❌ Har bir so'rov uchun memoizatsiya — uning o'rniga statik xususiyatdan
  foydalaning.
- ❌ Tranzaksion mos kelishi kerak bo'lgan har qanday narsa — uni MySQL da
  saqlang.

## TTL lar — standart qiymatlar

| Ma'lumot | TTL | Asoslash |
|------|-----|-----------|
| Auth elementlari / RBAC | 600s | Qayta hisoblash arzon, eskirgan auth xavfli |
| Filial ro'yxati | 3600s | Juda kam o'zgaradi |
| Katalog kategoriya daraxti | 1800s | Kuniga bir necha marta o'zgaradi |
| Dashboard KPI lari | 60s | Tez UI, real vaqtga yaqin |
| Hisobotlar (og'ir SQL) | 300s | DB yukini kamaytiradi |

## Invalidatsiya

Har doim yozish vaqtida invalidatsiya qiling. Patternlar:

```php
// After saving a price
$cache = Yii::app()->tenantContext->scopedFilial();
$cache->delete('catalog:price-types');
$cache->delete("product:{$id}:prices");
```

Kesh *bump* lari uchun (versiyali kalitlar):

```php
$ver = $cache->increment('catalog:version');
$key = "catalog:tree:v{$ver}";
```

Bu bitta manbaga bog'liq bo'lgan ko'plab kalitlar mavjud bo'lganda fan-out
invalidatsiyadan qochadi.
