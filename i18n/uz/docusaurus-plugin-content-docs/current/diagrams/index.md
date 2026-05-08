---
sidebar_position: 0
title: Diagramma galereyasi
slug: /diagrams
audience: Jamoaning barcha a'zolari
summary: "SalesDoctor hujjatlaridagi har bir diagrammaga yagona kirish nuqtasi. Loyiha / sohaga ko'ra guruhlangan; har bir diagramma ichki ko'rinishda chiziladi."
topics: [diagrams, gallery, mermaid, index]
---

# Diagramma galereyasi

Bu hujjatlardagi har bir diagramma uchun kanonik uy. Har bir guruhning o'z
sahifasi mavjud va diagrammalar ichki tarzda chizilgan.

## Guruhlar

| # | Guruh | Sahifa | Soni |
|---|-------|------|-------|
| 01 | **Ekotizim** | [ochish](./ecosystem.md) | 3 |
| 02 | **sd-billing** | [ochish](./sd-billing.md) | 12 |
| 03 | **sd-cs (HQ)** | [ochish](./sd-cs.md) | 11 |
| 04 | **sd-main · Tizim dizayni** | [ochish](./sd-main-system.md) | 7 |
| 05 | **Ma'lumotlar · ERD lar** | [ochish](./data.md) | 2 |
| 06 | **sd-main · Xususiyat oqimlari** | [ochish](./sd-main-features.md) | 16 |
| 07 | **Jarayon ish jarayonlari** | [ochish](./workflows.md) | 3 |

## Har bir flowchart da ishlatiladigan vizual taksonomiya

| Rang | Klass | Ma'nosi |
|--------|-------|---------|
| Ko'k   | `action`   | Standart qadam |
| Sariq  | `approval` | Ko'rib chiqish / tasdiqlash talab qiladi |
| Yashil | `success`  | Yakuniy OK / yopilgan holat |
| Qizil  | `reject`   | Muvaffaqiyatsiz / bekor qilingan yakuniy holat |
| Kulrang | `external` | Tashqi tizim (1C, Didox, gateway, FCM) |
| Binafsha | `cron`     | Rejalashtirilgan / vaqt bilan boshqariladigan |

([Workflow design standards](/docs/team/workflow-design) da aniqlangan.)

## Statistika

- Jami **54** diagramma
- **6** ta `er` diagrammasi
- **31** ta `flowchart` diagrammasi
- **16** ta `sequence` diagrammasi
- **1** ta `state` diagrammasi

## Yangilash protsedurasi

Bu galereya `sd-docs/scripts/render-diagram-gallery.py` tomonidan
generatsiya qilinadi. Asl sahifadagi har qanday diagramma manbasini
tahrirlagandan keyin uni qayta ishga tushiring:

```bash
python3 sd-docs/scripts/render-diagram-gallery.py
```
