---
sidebar_position: 5
title: API v3 — Mobil
---

# API v3 — mobil agent ilovasi

Maydon savdo agenti mobil ilovasi tomonidan foydalaniladigan faol yuza.
FCM/APNS qurilmasini ro'yxatga olish bilan token asosidagi auth.

## Endpoint xaritasi

| Yo'l | Kontroller | Maqsad |
|------|------------|--------|
| `POST /api3/login/index` | `LoginController` | login/parol/deviceToken bilan kirish |
| `POST /api3/logout/index` | `LogoutController` | Chiqish, qurilma tokenini tozalaydi |
| `GET /api3/config/index` | `ConfigController` | Server konfiguratsiyasi (feature flaglar, valyutalar) |
| `GET /api3/client/list` | `ClientController` | Agent yo'nalishidagi mijozlarni sinxronlash |
| `POST /api3/client/create` | `ClientController` | Maydonda yaratilgan mijoz (kutilmoqda) |
| `GET /api3/product/list` | `ProductController` | Katalogni sinxronlash |
| `GET /api3/product2/list` | `Product2Controller` | v2 katalog sinxronizatsiyasi (joriy) |
| `GET /api3/productCategory/index` | `ProductCategoryController` | Kategoriya daraxti |
| `GET /api3/priceType/index` | `PriceTypeController` | Narx turlari |
| `POST /api3/order/create` | `OrderController` | Yangi buyurtma yuborish |
| `GET /api3/order/list` | `OrderController` | Agentning buyurtmalari |
| `POST /api3/photo/index` | `PhotoController` | Tashrif fotosuratlarini yuklash |
| `POST /api3/visit/index` | `VisitController` | Check-in / check-out |
| `GET /api3/gps/index` | `GpsController` | GPS namunalarini yuborish |
| `POST /api3/auditor/index` | `AuditorController` | Audit shakllarini yuborish |
| `POST /api3/defect/index` | `DefectController` | Nuqsonlarni xabar qilish |
| `POST /api3/reject/index` | `RejectController` | Yetkazib berishni rad etish |
| `POST /api3/inventory/index` | `InventoryController` | Inventarizatsiya skani |
| `GET /api3/stock/index` | `StockController` | Har bir ombor bo'yicha mavjud zaxira |
| `POST /api3/store/index` | `StoreController` | Do'kon tomonidagi operatsiyalar |
| `POST /api3/expeditor/index` | `ExpeditorController` | Yetkazib berish tasdiqlash |
| `POST /api3/expeditor2/index` | `Expeditor2Controller` | v2 ekspeditor oqimi |
| `POST /api3/finans/index` | `FinansController` | Naqd pul yig'ish |
| `GET /api3/history/index` | `HistoryController` | Agent faoliyati tarixi |
| `GET /api3/kpi/index` | `KpiController` | Agent uchun KPI |
| `POST /api3/task/index` | `TaskController` | Vazifa tayinlash |
| `POST /api3/contract/index` | `ContractController` | Shartnoma yuborish |
| `POST /api3/tara/index` | `TaraController` | Qaytariladigan qadoqlash |
| `POST /api3/photo/index` | `PhotoController` | Foto yuklash |

## Kirish {#login}

To'liq so'rov/javobni [Autentifikatsiya](./authentication.md) bo'limida ko'ring.

## Tashriflar {#visits}

```http
POST /api3/visit/index
{
  "client_id": "C123",
  "type": "checkin",
  "lat": 41.31,
  "lng": 69.28,
  "ts": "2026-05-07T08:14:22Z"
}
```

`type`: `checkin` | `checkout`. Server `client.LAT/LNG` ga nisbatan
geofence ni va sozlangan radiusni (`gps` sozlamalari) tekshiradi.

## Buyurtma yaratish

```http
POST /api3/order/create
{
  "client_id": "C123",
  "price_type": "wholesale",
  "lines": [
    { "product_id": "P77", "count": 12, "price": 9500 },
    { "product_id": "P88", "count": 4, "price": 22000 }
  ],
  "comment": "Delivery tomorrow",
  "currency": "UZS"
}
```

Javob:

```json
{
  "success": true,
  "order_id": "O-2026-000123",
  "status": 1
}
```

Xatoliklar `INSUFFICIENT_STOCK`, `OVER_CREDIT_LIMIT`, `INVALID_CLIENT`,
`PRICE_MISMATCH` ni o'z ichiga oladi. [Xatolik kodlari](./error-codes.md) ga qarang.

## GPS namuna olish

Mobil ilova GPS namunalari paketini `POST /api3/gps/index` ga yuboradi —
odatda ilova oldingi planda bo'lganda har 30 soniyada. Namunalar
`gps_track` ga yoziladi va `gps3` monitoring UI tomonidan iste'mol qilinadi.
