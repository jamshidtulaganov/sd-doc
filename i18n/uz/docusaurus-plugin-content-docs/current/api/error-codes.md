---
sidebar_position: 7
title: Xatolik kodlari
---

# Xatolik kodlari

Standart xatolik konverti:

```json
{
  "success": false,
  "code": "INSUFFICIENT_STOCK",
  "error": "Stock for product P77 is insufficient (requested 12, available 4)",
  "details": { "product_id": "P77", "available": 4, "requested": 12 }
}
```

`code` mashinada o'qiladigan enum. `error` so'rov tilidagi inson xabari.

## Auth

| Kod | Ma'nosi |
|-----|---------|
| `INVALID_CREDENTIALS` | Login yoki parol noto'g'ri |
| `INVALID_TOKEN` | Token noma'lum / muddati o'tgan |
| `LICENSE_EXPIRED` | Ijara litsenziyasi muddati o'tgan |
| `DEVICE_LIMIT` | Ushbu foydalanuvchi uchun juda ko'p qurilma |
| `TENANT_INACTIVE` | Subdomen o'chirilgan |

## Katalog

| Kod | Ma'nosi |
|-----|---------|
| `PRICE_MISMATCH` | Yuborilgan narx katalogdan farqlanadi |
| `PRODUCT_INACTIVE` | Mahsulot o'chirilgan |
| `CATEGORY_NOT_FOUND` | Yomon kategoriya id |

## Zaxira

| Kod | Ma'nosi |
|-----|---------|
| `INSUFFICIENT_STOCK` | Mavjud miqdori so'ralganidan kam |
| `WAREHOUSE_INACTIVE` | Ombor o'chirilgan |
| `RESERVATION_FAILED` | Zaxirani atomik holda band qilib bo'lmadi |

## Buyurtma

| Kod | Ma'nosi |
|-----|---------|
| `INVALID_CLIENT` | Mijoz noma'lum / agent yo'nalishida emas |
| `OVER_CREDIT_LIMIT` | Kredit chegarasi oshib ketadi |
| `OVER_DISCOUNT_LIMIT` | Chegirma agentga ruxsat etilgan chegaradan yuqori |
| `INVALID_TRANSITION` | Status o'tishiga ruxsat berilmagan |
| `DUPLICATE_ORDER` | Idempotentlik kaliti to'qnashuvi |

## Integratsiya

| Kod | Ma'nosi |
|-----|---------|
| `EXTERNAL_TIMEOUT` | 1C / Didox / Faktura.uz ga chiquvchi chaqiruv vaqti tugadi |
| `EXTERNAL_4XX` | Tashqi tizim so'rovni rad etdi |
| `EXTERNAL_5XX` | Tashqi tizim xato qildi |
| `MAPPING_MISSING` | Ushbu obyekt uchun `XML_ID` xaritalashi yo'q |

## Umumiy

| Kod | Ma'nosi |
|-----|---------|
| `VALIDATION_FAILED` | So'rov yuki tekshiruvdan o'tmadi |
| `NOT_FOUND` | Obyekt mavjud emas |
| `FORBIDDEN` | Rolda ruxsat yo'q |
| `RATE_LIMITED` | Juda ko'p so'rov |
| `INTERNAL_ERROR` | Server tomonida ishlanmagan xato |

## HTTP statusiga xaritalash

- `200` — muvaffaqiyat
- `400` — `VALIDATION_FAILED`, `INVALID_TRANSITION`
- `401` — `INVALID_CREDENTIALS`, `INVALID_TOKEN`
- `402` — `LICENSE_EXPIRED`
- `403` — `FORBIDDEN`, `OVER_CREDIT_LIMIT`, `OVER_DISCOUNT_LIMIT`
- `404` — `NOT_FOUND`, `INVALID_CLIENT`, `CATEGORY_NOT_FOUND`
- `409` — `INSUFFICIENT_STOCK`, `RESERVATION_FAILED`, `DUPLICATE_ORDER`
- `429` — `RATE_LIMITED`
- `500` — `INTERNAL_ERROR`, `EXTERNAL_5XX`
- `504` — `EXTERNAL_TIMEOUT`
