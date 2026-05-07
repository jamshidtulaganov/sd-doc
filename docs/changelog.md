---
sidebar_position: 100
title: Changelog
---

# Changelog

All notable changes to the SalesDoctor platform are recorded here.

## [Unreleased]

- Documentation site (`sd-docs`) launched.

## v25.04 — 2026-04-21

### New
- Online Order module: scheduled reports.
- Markirovka labelling integration.

### Improved
- Order list (v2) — virtualised rendering for large tenants.
- KPI: agent / supervisor view rewrite (`KpiNewController`).

### Fixed
- Concurrency bug in stock reservation under heavy load.
- Cashbox displacement off-by-one rounding for fractional currencies.

## v25.02 — 2026-02-12

### New
- API v4 catalog browsing endpoints.
- Telegram WebApp host.

### Breaking
- Removed `api2` legacy controllers (kept `MigrateController` only).
