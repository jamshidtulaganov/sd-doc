---
sidebar_position: 3
title: Multi-tenancy
---

# Multi-tenancy

SalesDoctor **subdomenga marshrutlash** bilan **mijoz boshiga DB**
multi-tenancy dan foydalanadi.

## Tenantni hal qilish

```
https://{tenant}.salesdoc.io/orders/list
                ↑
                HTTP_HOST → TenantContext.resolveByHost()
                          → returns { db: "sd_acme", filialId: 7 }
```

Ikki granularlik:

- **Tenant** — bitta **MySQL ma'lumotlar bazasi**ga (`sd_<tenant>`) mos
  keladi.
- **Filial** (filial / branch) — tenant DB ichidagi qator. Bir nechta filial
  bitta tenant ma'lumotlar bazasini bo'lishishi mumkin; ma'lumotlar
  `FILIAL_ID` bilan teglanadi.

`TenantContext` quyidagilarni ochib beradi:

```php
Yii::app()->tenantContext->db            // 'sd_acme'
Yii::app()->tenantContext->filialId      // 7
Yii::app()->tenantContext->scoped()      // ScopedCache for tenant
Yii::app()->tenantContext->scopedFilial()// ScopedCache for filial
```

## Keshlash strategiyasi

Redis db2 — bu ilova keshi. Kalitlar nom maydoniga ajratilgan, shuning
uchun invalidatsiya to'g'ri granularlik bo'yicha amalga oshiriladi:

| Qamrov | Kalit shakli | Invalidatsiya qiladi |
|-------|-----------|-------------|
| Tenant | `t:{db}:filial-list` | Ushbu tenantning har bir filiali |
| Filial | `t:{db}:f:{id}:authitem` | Faqat shu filial |
| Foydalanuvchi | `t:{db}:f:{id}:u:{uid}:perms` | Faqat shu foydalanuvchi |

**Qoida**: hech qachon `Yii::app()->cache` ga to'g'ridan-to'g'ri yozmang.
Har doim `ScopedCache` orqali o'ting, shunda to'g'ri prefiks qo'llaniladi.

## Sessiyalar

Redis db0 ustida `CCacheHttpSession`. `keyPrefix` — bu `HTTP_HOST` bo'lib,
har bir subdomenga to'liq izolyatsiyalangan sessiya pulini beradi.

## Yangi tenant qo'shish

1. MySQL DB ni provisioning qiling:
   ```sql
   CREATE DATABASE sd_newcustomer DEFAULT CHARSET utf8;
   ```
2. Sxemani qo'llang (eng so'nggi dump ni yuklang yoki migratsiyalarni ishga
   tushiring).
3. Registry jadvaliga tenant qatorini kiriting.
4. Subdomen DNS + Nginx vhost ni qo'shing (yoki wildcard sertifikatdan
   foydalaning).
5. Smoke test: tizimga kiring, bitta buyurtma yarating, kesh kalitlarining
   scope qilinganligini tekshiring.

## Anti-patternlar

- ❌ Hech qaerda `sd_main` ni qattiq kodlash. Har doim `tenantContext->db`
  orqali o'ting.
- ❌ Prefikssiz tenantlar bo'ylab Redis kalitlarini bo'lishish.
- ❌ Tenant lar bo'ylab loop qilmaydigan cron ishlari — to'g'ri pattern uchun
  [Ishlar va rejalashtirish](./jobs-and-scheduling.md) ga qarang.
