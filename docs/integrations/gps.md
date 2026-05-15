---
sidebar_position: 9
title: GPS providers
---

# GPS providers

The mobile app posts GPS samples to api3 (`POST /api3/gps/index`). For
vehicle tracking, external providers can post directly.

## Controller endpoints in sd-main

### Mobile-side ingest — `api3/GpsController`

File: `protected/modules/api3/controllers/GpsController.php`. Live routes:

| Action | Route | Purpose |
|--------|-------|---------|
| `index` | `POST /api3/gps/index` | Online sample ingest (single or batch) |
| `offline` | `POST /api3/gps/offline` | Bulk offline-cached sample flush |

Both are `noRbac` — auth via mobile API token (see
[API v3 mobile](../api/api-v3-mobile/)).

### `gps3` module — admin / reporting

Files under `protected/modules/gps3/controllers/`:

| Controller | Action | Route |
|-----------|--------|-------|
| `ClientController` | `index`, `fetchClients`, `fetchAgents`, `fetchCategories`, `fetchRegions`, `fetchSummary`, `fetchVisits`, `print` | `/gps3/client/...` |
| `DirectiveController` | `directiveModal`, `directivePreloader` | `/gps3/directive/...` |

All actions are `noRbac` in the routes harvest — gating is via the
session-authenticated admin context, not the RBAC layer. See
[security/sd-main-landmines L11](../security/sd-main-landmines.md#l11--2281-of-2788-routes-have-no-rbac-tag)
for the broader pattern.

### Legacy `gps` and `gps2` modules

`protected/modules/gps/` and `protected/modules/gps2/` predate `gps3`
and are still loaded (see `main_static.php:45-48`). Earlier provider
ingests (e.g. Wialon-style) lived under those module prefixes. Verify
the active surface against `routes.json` before claiming a specific
endpoint URL — the previously documented `POST /gps3/backend/ingest`
and `POST /gps3/backend/wialon` do **not** appear in the current
routes table.

Samples are written to the GPS track tables and consumed by the
Angular map UI under `clients/view/clientMap`, `orders/view/onMap`,
and the `gps3` module's admin pages.

## See also

- [`gps3` module](../modules/gps3.md)
- [`gps2` module](../modules/gps2.md)
- [`gps` module](../modules/gps.md)
- [API v3 mobile](../api/api-v3-mobile/) — mobile-side GPS sample sender.
