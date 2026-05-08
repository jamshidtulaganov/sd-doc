---
sidebar_position: 2
title: Mahsulot Boshqaruvi — jarayon va bilim bazasi
audience: Mahsulot jamoasi
summary: PRD shablonlari, RICE prioritizatsiyasi, reliz eslatmalari (EN/RU/UZ) va SalesDoctor ga xos PM konteksti. PM larga yangi xususiyatlar miqyosini aniqlash va uchta loyihaga ta'sirini baholashda yordam beradi.
topics: [pm, prd, rice, release-notes, prioritisation]
---

# Mahsulot Boshqaruvi — jarayon va bilim bazasi

Ushbu sahifa **Mahsulot Menejerlari** uchun. U PM hayotiy davrini,
shablonlarni va xususiyatlarni loyihalashtirish yoki tartiblashda
o'lchashingiz kerak bo'lgan SalesDoctor ga xos omillarni qamrab oladi.

Mos FigJam diagrammalari [Workflow · PM](https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk)
va Workflow · Release train (xuddi shu fayl).

## Bosqich sikli

1. **Topish** — intervyular, support ticketlari, sotuvlar fikri,
   analitika → imkoniyat daraxti.
2. **Aniqlash** — muammo, gipoteza, metrika, PRD, wireframelar (Figma),
   tech spike, RICE.
3. **Yetkazib berish** — backlog, sprint, build, QA, UAT.
4. **Ishga tushirish** — feature flag, reliz eslatmalari, supportni
   o'rgatish, kuzatish.
5. **O'rganish** — natija vs gipoteza, takrorlash / o'ldirish /
   masshtablash.

## PRD / bir varaqlik shabloni

```md
# PRD — <feature>

## Problem
What's broken / missing today, for whom.

## Hypothesis
If we ship X, we expect Y, measured by Z within N weeks.

## Goals & non-goals
- In scope
- Out of scope

## Success metrics
- Primary KPI
- Guard-rail metrics

## User stories
- As a <role>, I want <goal>, so that <benefit>.

## Solution sketch
- Wireframes link
- Key flows

## Edge cases & risks
## Rollout
- Target tenants
- Feature flag name
- Stages: 5 % → 25 % → 100 %
- Rollback plan

## Timeline & owners
```

## RICE skoringi

| Maydon | Ma'no |
|--------|-------|
| Reach | Chorakda ta'sirlangan tenantlar / agentlar # |
| Impact | 0.25 / 0.5 / 1 / 2 / 3 |
| Confidence | 50 % / 80 % / 100 % |
| Effort | inson-haftalari |
| Score | (R × I × C) / E |

## Reliz eslatmalari (ko'p tilli)

Har bir reliz uchun **EN / RU / UZ** ga tarjima qiling. Shablon:

```md
## v<sem>.<minor> — <date>

### New
- ...

### Improved
- ...

### Fixed
- ...

### Breaking
- ...

### Migration
- DB: yes / no, see `m<id>_<name>.php`
- Config: ...
```

## SalesDoctor ga xos PM konteksti

Har bir PRD tasdiqlanishidan oldin quyidagi savollarga javob berishi
kerak.

### Qaysi loyihalar tegiladi?

| Loyiha | Qachon jalb qilish kerak |
|--------|--------------------------|
| **sd-main** | Sukut bo'yicha — ko'p xususiyatlar sd-main ga tegadi |
| **sd-cs** | Xususiyat birlashtirilgan HQ hisobotini talab qilsa (dilerlar bo'ylab) |
| **sd-billing** | Xususiyat obuna, litsenziya yoki to'lov oqimiga ta'sir qilsa |

Agar xususiyat **ikkita** loyihaga tegsa, shartnoma yuzasini (API
endpoint, DB ustun, integration log) aniqlang va uni tashqi
integratsiya kabi loyihalashtiring.

### Qaysi rollar ta'sirlanadi?

Deyarli har bir xususiyat uchun muhim rollar:

`Agent` (4) · `Operator` (5) · `Kassir` (6) · `Supervayzer` (8) ·
`Menejer` (9) · `Admin Filial` (2) · `Super Admin` (1) · `Ekspeditor`
(10) · `Hamkor` (7).

Xususiyat ta'sirlangan rollar uning mavjudligini bilmaguncha va
ta'sirlangan ekranlar [wireframes
bo'limi](../ui/wireframes.md) da hujjatlashtirilmaguncha "yetkazib
berilgan" emas.

### Mobil hamroh?

sd-main uchun **mobil tajriba (api3) ko'pincha qabul qilishning
uzligi**. Mobil hamroh hujjatlashtirilmaguncha (yoki aniq doiradan
tashqarida bo'lmaguncha) hech qanday xususiyat "yetkazib berilgan"
emas.

### Muvofiqlik integratsiyalari?

O'zbekistonda **1C, Didox va Faktura.uz integratsiyalari hal qiluvchi
omillar**. Agar xususiyat buyurtma ma'lumotlarini o'zgartirsa,
integratsiya ta'sirini P0 bog'liqligi sifatida rejalashtiring.

### Multi-tenancy sukut bo'yicha

Feature flaglar sukut bo'yicha **OFF** bo'lishi va tenant boshiga opt-in
bo'lishi kerak. Maxsus shartnomaga ega tenantlar oldinroq rollout
qilishi mumkin; sukut bo'yicha tenantlar xususiyatni faqat
tekshirishdan keyin oladi.

### Tillar

UI stringlari `ru / en / uz / tr` (va qisman `fa`) da. Faqat ingliz
tilidagi stringlar bilan xususiyatni jo'natmang.

## Foydali ichki havolalar

- [Modullar umumiy ko'rinishi](../modules/overview.md) — nimaga
  ta'sir qilishini aniqlash uchun
- [Ekosistema](../ecosystem.md) — 3-loyiha xaritasi
- [API ma'lumotnomasi](../api/overview.md) — endpoint yuza dizayni
  uchun
- [Wireframelar](../ui/wireframes.md) — joriy UI patternlari
- [sd-billing xavfsizlik tuzoqlari](../sd-billing/security-landmines.md) —
  PM ga ko'rinadigan qarz elementlari
