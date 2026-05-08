---
sidebar_position: 100
title: Changelog
---

# Changelog

Все значимые изменения платформы SalesDoctor записаны здесь.

## [Unreleased]

- Запущен сайт документации (`sd-docs`).

## v25.04 — 2026-04-21

### New
- Модуль Online Order: scheduled reports.
- Интеграция Markirovka.

### Improved
- Order list (v2) — виртуализированный рендеринг для больших тенантов.
- KPI: переписаны вьюхи agent / supervisor (`KpiNewController`).

### Fixed
- Concurrency-баг в резервировании стока под высокой нагрузкой.
- Off-by-one округление при cashbox displacement для дробных валют.

## v25.02 — 2026-02-12

### New
- Эндпоинты каталога API v4.
- Telegram WebApp host.

### Breaking
- Удалены legacy-контроллеры `api2` (оставлен только `MigrateController`).
