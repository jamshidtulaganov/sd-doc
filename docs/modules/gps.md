---
sidebar_position: 12
title: gps / gps2 / gps3
audience: Backend engineers, QA, PM, Field ops, Supervisors
summary: GPS tracking — three generations exist; gps3 is the active one. Live monitoring, trip playback, geofencing, ingest from mobile + external providers.
topics: [gps, geofence, monitoring, tracking, route]
---

# `gps`, `gps2`, `gps3` modules

GPS tracking. Three generations exist; new development should target
the latest (`gps3`).

| Module | Status | Notes |
|--------|--------|-------|
| `gps` | Maintenance | First-gen; used by older clients |
| `gps2` | Frozen | Legacy |
| `gps3` | **Current** | New features go here |

## Key features

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Live monitoring | Real-time map of all agents in a filial | 8 / 9 |
| Trip playback | Replay an agent's day on the map | 8 / 9 |
| Geofence per visit | Validate agent's check-in is inside the client's radius | system |
| GPS ingest from mobile | Mobile app posts samples every ~30 s | system |
| External provider ingest | Generic JSON / Wialon-style endpoints | system |
| Out-of-zone flag | Visits outside radius are flagged for review | 8 / 9 |
| KPI: GPS coverage | What % of plan visits had a real GPS check-in | 8 / 9 |

## Capabilities

- Live agent tracking on a map (`MonitoringController`)
- Per-visit geofence verification (`OrdersGpsController`)
- Trip playback (`TrackingController`)
- Background ingest from mobile clients (`BackendController`,
  `GetController`)
- Dashboard for supervisors (`FrontendController`)

## Angular module

A modern map UI lives in `ng-modules/gps/` — a stand-alone Angular
module loaded into a Yii view. Build it separately and copy `dist/`
into `ng-modules/gps/`.

## Key feature flow — Visit & GPS

See **Feature · Visit & GPS geofence** in
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).
