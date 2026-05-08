---
sidebar_position: 2
title: 1C / Esale
---

# 1C / Esale

Aksariyat ijaralar buxgalteriya tizimi sifatida **1C: Enterprise** ni
ishlatadi. Integratsiya quyidagilarni sinxronlashtiradi:

| Yo'nalish | Obyektlar |
|-----------|-----------|
| 1C → SD | Katalog (mahsulotlar, kategoriyalar, narxlar, birliklar), mijozlar (master), omborlar, to'lovlar |
| SD → 1C | Buyurtmalar (sarlavha + qatorlar), nuqsonlar, qaytarishlar, agentlar tomonidan yig'ilgan to'lovlar |

## Endpointlar

- `POST /api/json1c/<action>` — JSON, yaqinda.
- Eski XML: `/api/xml1c/...` — muzlatilgan.

Operatsiyalar:

```
POST /api/json1c/import?type=products
POST /api/json1c/import?type=clients
POST /api/json1c/export?type=orders
POST /api/json1c/ack?type=order&id=O-2026-0123
```

Auth: umumiy maxfiy kalit (`Authorization: SDocSecret <token>`).

## Xaritalash

`Product`, `Client`, `Order` va boshqalardagi `XML_ID` 1C havolasini saqlaydi.
`integration_log` har bir so'rov/javobni saqlaydi.

## Xatoliklarni boshqarish

Agar 1C paketi o'rtasida xatolik qaytarsa:

1. Butun paket **SD tomonida** orqaga qaytariladi.
2. `integration_log` qatori `status=ERROR` ni oladi.
3. Vazifa backoff bilan qayta navbatga qo'yiladi (maksimal 6 ta qayta urinish).
4. 6 ta muvaffaqiyatsizlikdan so'ng `adminEmail` ga ogohlantirish yuboriladi.

## Shuningdek qarang

- [`integration` moduli](../modules/integration.md)
- [`sync` moduli](../modules/sync.md)
