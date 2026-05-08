---
sidebar_position: 100
title: Changelog
---

# Changelog

SalesDoctor platformasidagi barcha muhim o'zgarishlar shu yerda
qayd etiladi.

## [Unreleased]

- Hujjatlash sayti (`sd-docs`) ishga tushirildi.

## v25.04 — 2026-04-21

### New
- Online Order moduli: rejalashtirilgan hisobotlar.
- Markirovka belgilash integratsiyasi.

### Improved
- Buyurtmalar ro'yxati (v2) — katta tenantlar uchun virtuallashtirilgan
  rendering.
- KPI: agent / supervayzer ko'rinishini qayta yozish (`KpiNewController`).

### Fixed
- Og'ir yuk ostida stock zaxiralashda concurrency xatosi.
- Kassa ko'chirishida kasr valyutalar uchun off-by-one yaxlitlash.

## v25.02 — 2026-02-12

### New
- API v4 katalog ko'rib chiqish endpointlari.
- Telegram WebApp host.

### Breaking
- Legacy `api2` controllerlari olib tashlandi (faqat `MigrateController`
  saqlandi).
