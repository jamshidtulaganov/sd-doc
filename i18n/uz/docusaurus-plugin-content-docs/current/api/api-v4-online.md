---
sidebar_position: 6
title: API v4 — Onlayn / B2B
---

# API v4 — onlayn buyurtma portali va yangi mobil mijozlar

Yangiroq yuza. Vazifalarning tozaroq ajratilishi:

| Vazifa | Kontroller |
|--------|------------|
| Autentifikatsiya | `LoginController` |
| Qurilmani ro'yxatga olish | `DeviceController` |
| Konfiguratsiya | `ConfigController` |
| Katalogni ko'rish | `CatalogController` |
| Mijozlar | `ClientController` / `ClientsController` |
| Buyurtma yaratish / tahrirlash / ro'yxat | `CreateController`, `EditController`, `OrderController`, `ListController`, `GetController` |
| Zaxira | `StockController`, `StockmanController` |
| Nuqsonlar | `DefectController` |
| Inventarizatsiya | `InventoryController` |
| Tashriflar | `VisitsController` |
| To'lovlar | `PaymentController`, `OnlinePaymentController` |
| Tara (qadoqlash) | `TaraController` |
| Tavsiyalar | `RecommendedSaleController`, `MustBuyRuleController` |
| KPI | `KpiController` |
| Agent operatsiyalari | `AgentController` |

## Auth

Bearer token (`Authorization: Bearer <token>`). Tokenlar
`POST /api4/login/index` dan olinadi va `device_id` bilan birga saqlanadi.

## Sxema konvensiyalari

- `application/json` so'rov va javob.
- Hamma joyda `snake_case` maydon nomlari.
- Pul maydonlari butun son kichik birliklar (UZS dagi summalar ba'zan
  juda katta — mijozda `bigint` dan foydalaning).
- ID'lar satrlar (UUID-ga o'xshash yoki eski `<filial>_<seq>`).
- Sahifalash: `?page` / `?limit`, javob konverti `total` ni o'z ichiga oladi.

## Onlayn to'lov yo'naltirishi

```
POST /api4/onlinePayment/start
↓ qaytaradi
{
  "success": true,
  "redirect_url": "https://provider.example.com/pay?token=..."
}
```

Provayder sozlangan callbackga qaytarilgandan so'ng,
`OnlinePaymentController::actionCallback()` imzoni tasdiqlaydi va
buyurtmaning `PAY_STATUS` ni yangilaydi.

## v3 yoki v4 ni qachon chaqirish kerak

| Foydalanish holati | Yuza |
|--------------------|------|
| Maydon agent ilovasi (mavjud) | v3 |
| Yangi B2B web/mobil portal | v4 |
| Telegram WebApp | v4 |
| Hamkor backend (server-server) | v4 |
| Bir martalik eski konnektor | v1 |
