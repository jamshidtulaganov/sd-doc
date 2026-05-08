---
sidebar_position: 6
title: Masshtablash
---

# Masshtablash

## Avval vertikal

Yii 1 yumshoq; bitta 8-yadroli / 16 GB quti o'rta darajadagi tenantlar
uchun qulay ishlaydi. Gorizontalga o'tishdan oldin bir qutidan ko'proq
foyda oling:

- php-fpm uchun `pm = dynamic`, `pm.max_children` ≈ `(memory_avail /
  avg_php_mem)`.
- `innodb_buffer_pool_size` ni DB host RAM ning ~70 % ga sozlang.
- Kesh db uchun (db2) `redis maxmemory-policy = allkeys-lru`.

## Gorizontal

App qatlami stateless → LB ortida N nusxa ishga tushiring. Sticky
sessiyalar **kerak emas** (sessiyalar Redis da).

Workerlar: alohida nusxa to'plamini ishga tushiring; har bir nusxa
db1 dan oladi.

Ma'lumotlar bazasi: avval vertikal (read replicas variant, lekin
tenant DB lari bo'ylab join lar kam).

## Issiq jadvallar

| Jadval | Yumshatish |
|--------|-----------|
| `gps_track` | Kunlik partition; 90 kundan eskini truncate qilish |
| `integration_log` | Kunlik partition; 30 kundan keyin arxivlash |
| `audit_*` | Tenant bo'yicha partitsiyalash |
| `order` (katta tenantlar) | Indeks ko'rib chiqish; `(STATUS, DATE)` ni ko'rib chiqing |

## CDN

CDN ni (Cloudfront, Bunny) `static/`, `assets/`, `js/`, `css/` oldiga
uzun max-age bilan qo'ying. Hash-ga asoslangan `assets/` papkasi kesh
invalidatsiyani avtomatik qiladi.
