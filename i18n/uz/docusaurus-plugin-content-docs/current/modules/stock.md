---
sidebar_position: 7
title: stock
audience: Backend engineers, QA, PM
summary: Miqdor darajasidagi zaxira operatsiyalari — qaytarishlar, almashishlar, hisobdan chiqarishlar, xaridlar. Warehouse'ni to'ldiradi (warehouse hujjatlarni saqlaydi).
topics: [stock, return, exchange, writeoff, purchase, reservation]
---

# `stock` moduli

Ombor qatlami ustidagi miqdor darajasidagi operatsiyalar: qaytarishlar, do'konlar o'rtasida almashish, hisobdan chiqarish, xarid. [`warehouse`](./warehouse.md) ni to'ldiradi (u hujjat sarlavhalarini saqlaydi).

## Asosiy xususiyatlar

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Qaytarish qo'shish | Defekt / rad'dan zaxiraga qaytarishni qayd etish | 1 / 9 / ombor |
| Sotib olish / xarid | Yetkazib beruvchidan kiruvchi xarid | 1 / 9 |
| Do'konlar o'rtasida almashish | Chakana do'konlar o'rtasida zaxira ko'chirish | 1 / 9 |
| Olib tashlash / hisobdan chiqarish | Doimiy olib tashlash (shikast, o'g'irlik) | 1 |
| Moliyaviy hisobot | Zaxira qiymati, yoshi, o'lik zaxira | 1 / 9 |
| Do'kon hisoboti | Do'kon bo'yicha zaxira holati | 1 / 9 |
| Atomik rezervatsiya operatsiyasi | `Stock::reserveForOrder()` tranzaksiyada ishga tushadi | tizim |

## Papka

```
protected/modules/stock/
├── controllers/
│   ├── AddReturnController.php
│   ├── BuyController.php
│   ├── ExchangeStoresController.php
│   ├── ExcretionController.php
│   ├── FinancialReportController.php
│   └── …
└── views/
```

## Zaxira xizmatlari

Umumiy `StockService` (`protected/components/` da) `stock` qatorlarini o'zgartiruvchi **yagona nuqta**. Qo'lda yozilgan SQL'dan saqlaning — u yerda parallellik xatolari yashirin.

## Rezervatsiyalar

Buyurtma `Reserved` ga o'tganda, `Stock::reserveForOrder()` `available` miqdorni kamaytiradi va `reserved` miqdorni oshiradi — bularning hammasi bitta tranzaksiyada **atomik** tarzda.

## Asosiy xususiyat oqimi — Defekt va Qaytarish

[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU) ichida **Feature · Online order + Defect/Return** ga qarang.

```mermaid
flowchart LR
  D(["Delivery"]) --> CHK{"All lines accepted (no defect)?"}
  CHK -->|yes| OK["STATUS=Delivered"]
  CHK -->|no| DEF["Defect rows"]
  DEF --> RTS["Return-to-stock job"]
  RTS --> RPT["Defect KPI"]
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class D,DEF,RTS,RPT action
class OK success
```

## Ruxsatlar

| Amal | Rollar |
|--------|-------|
| Qaytarish / hisobdan chiqarish | 1 / 9 |
| Xarid | 1 / 9 |
| Do'konlar o'rtasida almashish | 1 / 9 |
