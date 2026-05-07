---
sidebar_position: 9
title: GPS providers
---

# GPS providers

The mobile app posts GPS samples to api3 (`POST /api3/gps/index`). For
vehicle tracking, external providers can post directly:

| Provider | Endpoint |
|----------|----------|
| Generic JSON | `POST /gps3/backend/ingest` |
| Wialon-style | `POST /gps3/backend/wialon` |

Authentication is per-provider (token in URL or header). Samples are
written to `gps_track`, then consumed by `MonitoringController` and the
Angular map UI.
