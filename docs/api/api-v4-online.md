---
sidebar_position: 6
title: API v4 — Online / B2B
---

# API v4 — online order portal & new mobile clients

The newer surface. Cleaner separation of concerns:

| Concern | Controller |
|---------|------------|
| Authentication | `LoginController` |
| Device registration | `DeviceController` |
| Configuration | `ConfigController` |
| Catalog browsing | `CatalogController` |
| Clients | `ClientController` / `ClientsController` |
| Order create / edit / list | `CreateController`, `EditController`, `OrderController`, `ListController`, `GetController` |
| Stock | `StockController`, `StockmanController` |
| Defects | `DefectController` |
| Inventory | `InventoryController` |
| Visits | `VisitsController` |
| Payments | `PaymentController`, `OnlinePaymentController` |
| Tara (packaging) | `TaraController` |
| Recommendations | `RecommendedSaleController`, `MustBuyRuleController` |
| KPI | `KpiController` |
| Agent ops | `AgentController` |

## Auth

Bearer token (`Authorization: Bearer <token>`). Tokens are obtained from
`POST /api4/login/index` and stored alongside a `device_id`.

## Schema conventions

- `application/json` request and response.
- `snake_case` field names everywhere.
- Money fields are integer minor units (sums in UZS are sometimes huge —
  use `bigint` on the client).
- IDs are strings (UUID-ish or legacy `<filial>_<seq>`).
- Pagination: `?page` / `?limit`, response envelope includes `total`.

## Online payment redirect

```
POST /api4/onlinePayment/start
↓ returns
{
  "success": true,
  "redirect_url": "https://provider.example.com/pay?token=..."
}
```

After the provider redirects back to a configured callback,
`OnlinePaymentController::actionCallback()` validates the signature and
updates the order's `PAY_STATUS`.

## When to call v3 vs v4

| Use case | Surface |
|----------|---------|
| Field agent app (existing) | v3 |
| New B2B web/mobile portal | v4 |
| Telegram WebApp | v4 |
| Partner backend (server-to-server) | v4 |
| One-off legacy connector | v1 |
