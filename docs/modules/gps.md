---
sidebar_position: 12
title: gps
---

# `gps`, `gps2`, `gps3` modules

GPS tracking. Three generations exist; new development should target the
latest (`gps3`).

| Module | Status | Notes |
|--------|--------|-------|
| `gps` | Maintenance only | First-gen, used by older clients |
| `gps2` | Legacy | Frozen |
| `gps3` | **Current** | New features go here |

## Capabilities

- Live agent tracking on a map (`MonitoringController`)
- Per-visit geofence verification (`OrdersGpsController`)
- Trip playback (`TrackingController`)
- Background ingest from mobile clients (`BackendController`,
  `GetController`)
- Dashboard for supervisors (`FrontendController`)

## Angular module

A modern map UI lives in `ng-modules/gps/` — a stand-alone Angular module
loaded into a Yii view. Build it separately and copy `dist/` into
`ng-modules/gps/`.
