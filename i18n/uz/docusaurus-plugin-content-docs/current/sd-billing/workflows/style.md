---
sidebar_position: 0
title: Xususiyat sahifasini qanday yozish
---

# Xususiyat ish oqimi sahifasini qanday yozish

Ushbu qo'llanma sd-billing'ning bitta xususiyatini (bitta shlyuz integratsiyasi,
bitta admin ekrani, bitta API endpoint, bitta cron buyrug'i) qanday hujjatlashtirishni
aytadi, shunda yangi xodim uni bir marta o'qishi va xususiyatdan ishonchli
foydalanishi mumkin.

Bu platforma bo'yicha [Ish oqimini loyihalash standartlari](/docs/team/workflow-design)
ning yozish hamrohi — o'sha sahifa ish oqimini *loyihalashni* qamrab oladi;
bu sahifa mavjud ish oqimi haqida *sahifa yozishni* qamrab oladi.

## Auditoriya va maqsad

O'quvchi profili:

- **Birinchi oyida** yangi xodim.
- [sd-billing umumiy ko'rinish](../overview.md) va [auth va kirish](../auth-and-access.md)
  ni o'qigan, shuning uchun ular tizim har-tenant litsenziya/obuna ko'lami
  bilan **bitta billing DB** (`d0_*` prefiks) ni ishlatishini va
  `Access::check()` har bir ekranni boshqarishini biladi.
- Yii eksperti **emas**.
- Ikki savoldan biriga javob berishni xohlaydi:
  1. *"Bu xususiyat nima qiladi va qanday foydalanaman?"*
  2. *"Agar mijoz uning buzilganini aytsa, qayerga qarayman?"*

Agar sahifa ikkalasini ham qilsa, siz yaxshi sahifa yozdingiz.

## Biz nimani yozmaymiz

- **Darslik** ("bu yerga bosing, keyin bu yerga") har bir relizda eskiradigan.
- Kontroller tanasi **kod uyumlari** — fayl havolasini bering.
- Qurilmagan xususiyatlar uchun **spec / loyiha hujjatlari** — bu PRD hududi.
- **Ma'lumotnoma takrorlash** — jadval ro'yxati [data scheme](../data-scheme.md)
  da yashaydi. Havola bering, qayta aytmang.

## Talab qilinadigan bo'limlar

Har bir xususiyat sahifasida bu sakkiz bo'lim shu tartibda bo'ladi.
**Yangi yuqori darajadagi bo'limlarni qo'shmang** — agar biror narsa mos kelmasa,
u ehtimol boshqa hujjatga tegishli va bog'lanishi kerak.

| # | Bo'lim | Nima boradi |
|---|--------|-------------|
| 1 | **Maqsad** | Bir xatboshi. Bu xususiyat javob beradigan biznes savoli. Kod yo'q, UI yo'q. |
| 2 | **Kim ishlatadi** | Rollar + uni boshqaradigan kirish kalitlari (`module.controller.action`) |
| 3 | **Qayerda yashaydi** | URL, kontroller yo'li, asosiy ko'rinish fayllari, tegishli model sinflari |
| 4 | **Ish oqimi** | Raqamlangan ro'yxat. Foydalanuvchining "sahifa ochish"dan "javob olish"gacha bo'lgan yo'li. Agar 3+ ishtirokchi bo'lsa, Mermaid ketma-ketlik diagrammasi |
| 5 | **Qoidalar** | Bullet ro'yxati. Tasdiqlash, ko'lamlash, chekka holatlar. Har bir qoida fe'l bilan boshlanadi (*"Filtrlaydi …"*, *"Rad etadi agar …"*) |
| 6 | **Ma'lumotlar manbalari** | Ikki ustun jadvali: *Jadval* / *Maqsad*. Barcha jadvallar bitta billing DB (`d0_*` prefiks) da yashaydi; tegishli bo'lganda tenant ko'lamini (DILER_ID, DISTR_ID yoki davlat bo'yicha) qayd eting |
| 7 | **Gotchalar** | Yangi xodimlarni hayron qoldiradigan ikki yoki uchta narsa (shlyuz sign tasdiqlash, NULL semantikasi, qattiq kodlangan tokenlar, …) |
| 8 | **Yana qarang** | 2–4 havola — tegishli arxitektura sahifasi, qo'shni xususiyatlar, manba fayli |

## Ovoz va uslub

- **Mavzu xususiyat, foydalanuvchi emas.** *"Endpoint tranzaksiyani qayd
  qilishdan oldin Click imzosini tasdiqlaydi"* deb yozing, *"Siz Click
  imzosini tasdiqlay olasiz"* emas.
- **Hozirgi ko'rsatma fe'llari.** *"Yuklaydi", "rad etadi", "yozadi"* —
  *"yuklaydi", "rad etishi kerak"* emas.
- **Har bir bullet uchun bitta jumla.** Agar sizga vergul-keyin-lekin kerak
  bo'lsa, ajrating.
- **Raqamlar va to'g'ri nomlar aniq.** *"demo tenantda 3 faol shlyuz"*,
  *"bir nechta shlyuzlar"* emas. Bilmasangiz so'rovni ishga tushiring.
- **O'zaro havola, qayta aytmang.** Bitta-DB / har-tenant mexanikasi uchun
  umumiy ko'rinishni bir marta bog'lang; ularni qayta tushuntirmang.
- **Bitta skrinshot yaxshi, uchtasi ko'p.** Sahifalar qidiriladigan va
  tarjima qilinadigan bo'lib qolishi kerak; raqamlangan ish oqimi ro'yxatiga tayaning.

## Vizual taksonomiya

Agar sahifada diagramma bo'lsa, [Diagramma galereyasi](/docs/diagrams) standartining
platforma-standart ranglarini ishlating:

| Rang | Sinf | Ma'no |
|------|------|-------|
| Ko'k | `action` | Standart bosqich |
| Sariq | `approval` | Ko'rib chiqish / tasdiqlash talab qiladi |
| Yashil | `success` | Yakuniy OK / yopilgan holat |
| Qizil | `reject` | Muvaffaqiyatsiz / bekor qilingan holat |
| Kulrang | `external` | Tashqi tizim (Click, Payme, Paynet, Telegram, SMS, 1C, …) |
| Binafsha | `cron` | Rejalashtirilgan / vaqt-asosli |

## Qoidalar bo'limi — sifat darajasi

**Qoidalar** bo'limi — bu eng ko'p onboarding qiymati yashaydigan joy.
Yaxshi qoida **falsifikatsiya qilinadigan**: o'quvchi uni kod yoki ma'lumotlarga
qarshi tekshira oladi va bugun haqiqatmi yo'qmi degan haqida ayta oladi.
Yomon qoidalar mavhum.

| Yomon | Yaxshi |
|-------|--------|
| *"Imzo tekshiruvi kutilganidek ishlaydi."* | *"`ClickTransaction::checkSign()` `sign_string` ni `md5(service_id + amount + transaction_id + SECRET_KEY)` bilan taqqoslaydi; nomuvofiqlikda `false` qaytaradi va endpoint xato kodi `-1` bilan javob beradi."* |
| *"Faqat adminlar barcha dilerlarni ko'radi."* | *"`Access::check('operation.dealer.payment', Access::SHOW)` bitsiz har qanday foydalanuvchi uchun `CHttpException(403)` tashlaydi; `IS_ADMIN` va `ROLE_ADMIN` `Access::has()` orqali ruxsat berishga qisqa-tutashadi."* |

Agar siz falsifikatsiya qilinadigan qoidani yoza olmasangiz, **ko'proq kod
o'qing** — qoida allaqachon manbada, siz uni hali topmagansiz.

## Ish oqimi bo'limi — sifat darajasi

Ish oqimi bosqichi **funksiyadan tashqari ko'zga ko'rinadigan**: u UI ni
o'zgartiradi, HTTP so'rovini yuboradi, DB ga yozadi yoki natijani ko'rsatadi.
Implementatsiya bosqichlari ("SQL shartini quradi") **Qoidalar**ga yoki
**Gotchalar**ga tegishli, ish oqimiga emas.

```
Yomon ish oqimi bosqichi:  "Sana diapazoni uchun QueryBuilder shartini quradi."
Yaxshi ish oqimi bosqichi: "Foydalanuvchi sana diapazonini tanlaydi va Apply ni bosadi."
                          "Sahifa /report/revenue/getData ga filtrlarni POST qiladi."
                          "Server JSONni qaytaradi, har dileri uchun bitta qator."
                          "Sahifa daromad gridini klient tomonida render qiladi."
```

## Ma'lumotlar manbalari bo'limi — nimani kiritish kerak

Xususiyat tomonidan havola qilingan har bir jadval uchun ro'yxatlang:

- **Jadval** — `d0_<name>` (barcha jadvallar bitta billing DB ni baham ko'radi).
- **Tenant ko'lami** — so'rov bitta tenantga qanday cheklangan (masalan,
  `DILER_ID`, `DISTR_ID`, `COUNTRY_ID`).
- **Nima uchun o'qiladi** — bir qator.

Ustunlarni qayta hujjatlashtirmang; o'rniga [data scheme](../data-scheme.md) ni
bog'lang.

## Frontmatter

Har bir sahifa quyidagidan foydalanadi:

```yaml
---
sidebar_position: <butun son, workflows/ ichida noyob>
title: <module> · <feature> # masalan, "api · Click shlyuzi"
---
```

`<module> · <feature>` sarlavhasi sidebar va qidiruvda ko'rinadigan narsa.
Qisqa va mashina-tartiblanuvchi tutib turing.

## O'z sahifangizni ko'rib chiqish

PR ochishdan oldin, ushbu to'rtta tekshiruvni bajaring:

1. **Haqiqiy yangi xodimni toping** (yoki simulatsiya qiling). Sahifani ularga bering.
   Ular sahifani 10 daqiqa ichida sahna muhitida xususiyatdan foydalana olishlari kerak.
2. **Har bir qoida falsifikatsiya qilinadigan.** **Qoidalar** bo'limini qayta
   o'qing va so'rang *"Buni kod yoki DBdan noto'g'ri ekanligini isbotlay olamanmi?"* —
   agar yo'q bo'lsa, qayta yozing yoki o'chiring.
3. **Hech qanday bo'lim yo'q emas.** Barcha sakkizta talab qilinadigan bo'lim
   tartibda mavjud.
4. **O'zaro havolalar ishlaydi.** Lokal `npm run build` ni ishga tushiring;
   buzilgan-havola ogohlantirishlari CI muvaffaqiyatsizliklari.

## Yana qarang

- [Ish oqimini loyihalash standartlari](/docs/team/workflow-design) — ish
  oqimlarini *qanday loyihalaymiz* (ularni qanday hujjatlashtiramiz emas).
- `sd-docs/skills/sd-billing-workflow-author/SKILL.md` — kontroller yo'lidan
  xususiyat sahifasini loyihalash uchun *bu* uslublar qo'llanmasiga amal
  qiluvchi skill.
