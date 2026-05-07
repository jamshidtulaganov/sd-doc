---
sidebar_position: 5
title: API v3 — Mobile
---

# API v3 — mobile agent app

The active surface used by the field sales agent mobile app. Token-based
auth with FCM/APNS device registration.

## Endpoint map

| Path | Controller | Purpose |
|------|------------|---------|
| `POST /api3/login/index` | `LoginController` | Login with login/password/deviceToken |
| `POST /api3/logout/index` | `LogoutController` | Logout, clears device token |
| `GET /api3/config/index` | `ConfigController` | Server config (feature flags, currencies) |
| `GET /api3/client/list` | `ClientController` | Sync clients on the agent's route |
| `POST /api3/client/create` | `ClientController` | Field-created client (pending) |
| `GET /api3/product/list` | `ProductController` | Catalog sync |
| `GET /api3/product2/list` | `Product2Controller` | v2 catalog sync (current) |
| `GET /api3/productCategory/index` | `ProductCategoryController` | Category tree |
| `GET /api3/priceType/index` | `PriceTypeController` | Price types |
| `POST /api3/order/create` | `OrderController` | Submit a new order |
| `GET /api3/order/list` | `OrderController` | Agent's orders |
| `POST /api3/photo/index` | `PhotoController` | Upload visit photos |
| `POST /api3/visit/index` | `VisitController` | Check-in / check-out |
| `GET /api3/gps/index` | `GpsController` | Push GPS samples |
| `POST /api3/auditor/index` | `AuditorController` | Submit audit forms |
| `POST /api3/defect/index` | `DefectController` | Report defects |
| `POST /api3/reject/index` | `RejectController` | Reject delivery |
| `POST /api3/inventory/index` | `InventoryController` | Inventory scan |
| `GET /api3/stock/index` | `StockController` | Available stock per warehouse |
| `POST /api3/store/index` | `StoreController` | Store-side ops |
| `POST /api3/expeditor/index` | `ExpeditorController` | Delivery confirmation |
| `POST /api3/expeditor2/index` | `Expeditor2Controller` | v2 expeditor flow |
| `POST /api3/finans/index` | `FinansController` | Cash collection |
| `GET /api3/history/index` | `HistoryController` | Agent activity history |
| `GET /api3/kpi/index` | `KpiController` | KPI for the agent |
| `POST /api3/task/index` | `TaskController` | Task assignment |
| `POST /api3/contract/index` | `ContractController` | Contract submission |
| `POST /api3/tara/index` | `TaraController` | Returnable packaging |
| `POST /api3/photo/index` | `PhotoController` | Photo upload |

## Login {#login}

See the full request/response on [Authentication](./authentication.md).

## Visits {#visits}

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

`type`: `checkin` | `checkout`. Server validates geofence against
`client.LAT/LNG` and the configured radius (`gps` settings).

## Order create

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

Response:

```json
{
  "success": true,
  "order_id": "O-2026-000123",
  "status": 1
}
```

Errors include `INSUFFICIENT_STOCK`, `OVER_CREDIT_LIMIT`, `INVALID_CLIENT`,
`PRICE_MISMATCH`. See [Error codes](./error-codes.md).

## GPS sampling

The mobile app posts batches of GPS samples to `POST /api3/gps/index` —
typically every 30 s while the app is foregrounded. Samples are written
to `gps_track` and consumed by the `gps3` monitoring UI.
