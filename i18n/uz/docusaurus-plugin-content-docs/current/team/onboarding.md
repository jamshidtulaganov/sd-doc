---
sidebar_position: 3
title: Yangi dasturchini onboarding
audience: Yangi backend / frontend / mobil / DevOps muhandislari
summary: SalesDoctor platformasida (sd-cs · sd-main · sd-billing) samarali ishlash uchun birinchi-kun, birinchi-hafta va birinchi-oy rejasi. O'qish tartibi, muhitni sozlash, boshlang'ich ticketlar, kimdan so'rash kerak.
topics: [onboarding, first-day, first-week, ramp-up]
---

# Yangi dasturchini onboarding

Xush kelibsiz. Ushbu sahifa SalesDoctor platformasida "birinchi kun"
dan "birinchi PR ni jo'natish" gacha bo'lgan yo'l. Reja sizni umumiy
web tajribasi bilan va Yii 1.x ga oldindan ta'siri bo'lmagan
backend / frontend / mobil / DevOps muhandisi deb taxmin qiladi.

Platforma **uchta qarindosh loyiha** ga ega — sho'ng'ishdan oldin
katta rasmni ko'rish uchun [Ekosistema sahifasi](../ecosystem.md) ga
qarang.

## 1-kun

Maqsad: hujjatlar + kodni laptopingizda olish va bitta lokal muhitni
ishga tushirish.

- [ ] `sd-main`, `sd-cs`, `sd-billing`, `sd-docs`, `sd-components` ga
      **GitHub kirish huquqini** oling.
- [ ] Dev MySQL replikalariga **VPN / tarmoq kirish huquqini** oling.
- [ ] To'rt repo ni `~/projects/salesdoctor/` ostida clone qiling.
- [ ] **Docker Desktop** ni (≥ 4 GB RAM ajratilgan) va **Node 18+** ni
      o'rnating.
- [ ] Hujjatlar saytini lokal ishga tushiring:
      ```bash
      cd sd-docs && npm install && npm run start
      ```
- [ ] Quyidagi sahifalarni tartib bilan o'qing:
      1. [Kirish](/docs/intro)
      2. [Ekosistema](../ecosystem.md)
      3. [Arxitektura umumiy ko'rinishi](../architecture/overview.md)
      4. [Tech stack](../architecture/tech-stack.md)
- [ ] **Faqat frontend yo'nalishi** — shuningdek o'qing:
      [Frontend umumiy ko'rinishi](../frontend/overview.md) →
      [Boshlash (frontend)](../frontend/getting-started.md).

## 1-hafta

Maqsad: tizimni ishga tushira olish, uning ma'lumotlarini o'qiy olish
va bitta to'liq so'rovni kuzatib borish.

**Majburiy o'qish** (hamma uchun, tartib bilan):

- [ ] [Kirish](/docs/intro)
- [ ] [Ekosistema](../ecosystem.md)
- [ ] [Arxitektura umumiy ko'rinishi](../architecture/overview.md)
- [ ] [Lokal sozlash](../project/local-setup.md) — sd-main ni lokal
      ko'taring va loginni smoke-test qiling.
- [ ] [Loyiha tuzilishi](../project/structure.md)
- [ ] [Konventsiyalar](../project/conventions.md)
- [ ] [Modullar umumiy ko'rinishi](../modules/overview.md)

**Birinchi ticketingiz uchun zarur bo'lganda o'qing** (oldindan
o'qimang; ticket ularga teganida tortib oling):

- Arxitektura chuqur sho'ng'ishlari:
  [Multi-tenancy](../architecture/multi-tenancy.md),
  [Keshlash](../architecture/caching.md),
  [Fonda ishlar](../architecture/jobs-and-scheduling.md).
- sd-billing lokal sozlash:
  [sd-billing lokal sozlash](../sd-billing/local-setup.md).
- Frontend yo'nalishi:
  [Frontend konventsiyalari](../frontend/conventions.md),
  [Ekran qo'shish](../frontend/adding-a-screen.md),
  [Yii views](../frontend/yii-views.md),
  [JS plaginlari](../frontend/js-plugins.md),
  [ng-modules](../frontend/ng-modules.md),
  [Asset pipeline](../frontend/assets-pipeline.md).
- UI patternlari:
  [Sahifa tartibi](../ui/page-layout.md),
  [jadvallar](../ui/tables.md),
  [filtrlar](../ui/filters.md),
  [formalar](../ui/forms.md),
  [modallar](../ui/modals.md).

**Keyin:**

- [ ] Bitta foydalanuvchiga ko'rinadigan oqimni tanlang va uchidan
      uchigacha kuzating:
      Tavsiya etilgan oqim: *agent mobil buyurtmani jo'natadi*.
      - Mobil so'rov: [API v3 — `POST /api3/order/create`](../api/api-v3-mobile.md)
      - `protected/modules/api3/controllers/OrderController.php` dagi
        controller handler
      - `OrderService` / `Order` modelidagi validatsiya + insert
      - Stock zaxirasi navbat ishi
      - `Reserved` ga status o'tishi
      - [Buyurtma hayotiy davri](../architecture/diagrams.md) ketma-ketligini
        o'qing
- [ ] Bitta **boshlang'ich ticket** oching (menejeringiz tayinlaydi).
      Tavsiya etilgan boshlang'ichlar:

      *Backen-ish:*
      - `protected/messages/uz/...` ga tarjima qatori qo'shing.
      - `Distr::getFilter()` ishlatuvchini `QueryBuilder` ga
        o'tkazing.
      - Mavjud service metodi uchun unit test yozing.

      *Frontend-ish:*
      - Mavjud ro'yxat ko'rinishiga yangi ustun qo'shing (masalan,
        buyurtmalar jadvalidagi `Agent` ustuni) — Yii view, DataTables
        konfigi va `protected/messages/<locale>/orders.php` dagi i18n
        kalitlariga tegadi. Tekshirish ro'yxati sifatida
        [Ekran qo'shish](../frontend/adding-a-screen.md) dan
        foydalaning.
      - Ko'rinishdagi bitta inline `style="..."` ni nomlangan CSS
        klassiga o'tkazing.
      - Bitta qator-amallar `⋮` menyusiga yetishmayotgan
        `aria-label` qo'shing va uni
        [UI · Jadvallar](../ui/tables.md) da hujjatlashtiring.
      - View dan o'tib ketgan literal RU stringi joyiga yetishmayotgan
        `Yii::t()` chaqiruvini qo'shing; mos `en` va `uz` kalitlarini
        qo'shing.
- [ ] Birinchi PR ingizni jo'nating. [Kodlash
      standartlari](../quality/coding-standards.md) va [Hissa
      qo'shish](../quality/contribution.md) ga rioya qiling.

## 1-oy

Maqsad: mijozga ko'rinadigan o'zgarishni jo'natish va ikkinchi loyihani
tushunish.

- [ ] Kichik xususiyat (≤ 1-haftalik miqyos) ni uchidan uchigacha
      jo'nating, shu jumladan testlar, hujjat yangilanishi, reliz
      eslatmasi yozuvi.
- [ ] **Bittasini** o'qing:
      - HQ hisobotida ishlasangiz [sd-cs umumiy ko'rinishi](../sd-cs/overview.md) +
        [sd-cs ↔ sd-main integratsiya](../sd-cs/sd-main-integration.md).
      - Obunalar / to'lovlarda ishlasangiz [sd-billing umumiy ko'rinishi](../sd-billing/overview.md) +
        [Obuna oqimi](../sd-billing/subscription-flow.md).
- [ ] Loyiha trekeringizdagi 5 ta haqiqiy production ticket bo'yicha
      o'ting va tashxisni hal qilishdan oldin bashorat qiling.
- [ ] QA dan birov bilan regression test sikli bo'yicha pair qiling
      ([Jamoa · QA](./qa.md) ga qarang) — sizga buzilish rejimlari
      katalogini beradi.

## Biz qanday ishlaymiz

| Mavzu | Qaerda o'qish |
|-------|---------------|
| Branching, PR | [Kodlash standartlari](../quality/coding-standards.md), [Hissa qo'shish](../quality/contribution.md) |
| Reliz jarayoni | [Reliz jarayoni](../quality/release-process.md) |
| Testlar | [Testlash](../quality/testing.md) |
| ADR lar | [ADR indeksi](../adr/index.md) |
| Diagrammalar | [Diagrammalar (FigJam)](../architecture/diagrams.md) |

## Kimdan so'rash kerak

| Mavzu | Kanal |
|-------|-------|
| Repo kirish / VPN | `#it-helpdesk` |
| sd-main domen savollari | `#sd-main-eng` |
| sd-cs / HQ hisoboti | `#sd-cs-eng` |
| Billing va to'lovlar | `#sd-billing-eng` |
| QA jarayoni | `#qa` |
| Boshqa har qanday narsa | tech lead ingiz |

## Birinchi oyingizda oldini olish kerak bo'lgan tuzoqlar

- ❌ `framework/` ga tegish (vendored Yii 1.x). Tegmang.
- ❌ Legacy fayllarga `declare(strict_types=1)` qo'shish.
- ❌ Tenant DB nomini qattiq kodlash.
- ❌ `Yii::app()->cache` ni to'g'ridan-to'g'ri chaqirish — `ScopedCache`
  dan foydalaning.
- ❌ `api` yoki `api2` ga yangi endpointlar qo'shish. `api3` (mobil)
  yoki `api4` (onlayn) dan foydalaning.
- ❌ Legacy jadvallarda ustunlarni qayta nomlash. Mavjud chaqiruv
  joylari `UPPER_SNAKE_CASE` ga bog'liq.

## Ma'lumot: foydali bir qatorli buyruqlar

```bash
# sd-main da har qanday eskirgan faylni topish:
find protected -name "*.obsolete"

# Modullarni hisoblash:
ls protected/modules | wc -l

# Yangi RU sahifa uchun tarjima skeleti:
mkdir -p i18n/ru/docusaurus-plugin-content-docs/current/<path>
cp docs/<path>/<page>.md i18n/ru/docusaurus-plugin-content-docs/current/<path>/<page>.md

# sd-main runtime log ni tail qilish:
docker compose exec web tail -f protected/runtime/application.log
```

## Xush kelibsiz

Birinchi PR ingiz ta'sirli bo'lishi shart emas — u o'zgarishni uchidan
uchigacha bajara olishingizni ko'rsatishi kerak. Hajmga emas, sikliga
e'tibor qarating. Erta so'rang, tez-tez so'rang.
