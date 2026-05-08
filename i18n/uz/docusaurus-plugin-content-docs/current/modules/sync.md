---
sidebar_position: 19
title: sync
---

# `sync` moduli

Ikki tomonlama ma'lumot sinxronizatsiyasi, asosan SalesDoctor va tenantning buxgalteriya tizimi (odatda 1C) o'rtasida. Asosan job tomonidan boshqariladi.

## Yo'nalish

| Tur | Qayerdan o'qish |
|------|---------------|
| Tashqi (SalesDoctor → 1C) | `integration` da buyurtma eksport job'lari |
| Ichki (1C → SalesDoctor) | `sync` da katalog/narx/mijoz sinxron job'lari |

## Loglash

Har bir sinxron ishga tushishi `IntegrationLog` ga status, payload va har qanday xato bilan loglanadi. `integration` UI bu jadvaldan o'qiydi.
