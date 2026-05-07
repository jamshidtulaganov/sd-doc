---
sidebar_position: 4
title: Reports & pivots
---

# Reports & pivots

sd-cs has two reporting layers:

| Module | Style |
|--------|-------|
| `report` | Single-screen reports — filters + grid + Excel export |
| `pivot` | Pivot tables — drag dimensions and measures |

## How they read dealer data

Most reports go through a **DealerReportService** pattern:

1. Pick the dealers in scope (a country, a region, all).
2. For each dealer, swap the `dealer` connection.
3. Run the dealer-side query → push rows to a temporary collector.
4. Aggregate in PHP after the loop.

For very large pivots, the service writes per-dealer intermediate rows
to `cs_*` staging tables and then aggregates in MySQL.

## Caching

`redis_cache` (one logical Redis connection) holds:

- Sessions.
- Optional report-result caches keyed by
  `report:<name>:<filters_hash>:<dealers_hash>`.

TTLs of 5–15 minutes are typical for HQ reports.

## Excel export

Same as sd-main — PHPExcel.

## Performance tips

- Always cap the dealer loop with a configurable concurrency.
- Push joins to the dealer side; pull narrow rows.
- Cache aggressively at the HQ side; HQ users are happy with 1-min
  staleness for top-level metrics.
