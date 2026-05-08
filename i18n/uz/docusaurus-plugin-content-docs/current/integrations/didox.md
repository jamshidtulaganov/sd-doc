---
sidebar_position: 3
title: Didox
---

# Didox EDI

Didox — ko'plab O'zbekiston B2B mijozlari foydalanadigan e-hujjat
operatori. SalesDoctor Didox ga e-hisobvaraqlar, shartnomalar va aktlarni
yuboradi; kontragent Didox da imzolaydi / rad etadi va biz holatni
aks ettiramiz.

## Biz nimani yuboramiz

| Hujjat turi | Ishga tushiruvchi |
|-------------|-------------------|
| e-hisobvaraq | Buyurtma `Loaded` ga yetadi |
| Bajarilgan ishlar dalolatnomasi | Buyurtma `Delivered` ga yetadi |
| Shartnoma | Shartnoma modulidan qo'lda |

## Auth

OAuth2 mijoz hisob ma'lumotlari. Tokenlar `redis_app` da 1 soatga
keshlanadi.

## Kuzatish

Har bir yuborilgan hujjat buyurtma / shartnomada saqlanadigan Didox
tomonidagi ID ni oladi. `IntegrationLog` simdagi yuklarni saqlaydi.

## Xato rejimlari

- Kontragent INN `Client.INN` da yo'q → `MAPPING_MISSING`.
- Didox HTTP 5xx → backoff bilan qayta urinish.
- Kontragent Didox da rad etadi → holat SD ga aks ettiriladi; operatorga
  bildirishnoma sifatida ko'rsatiladi.
