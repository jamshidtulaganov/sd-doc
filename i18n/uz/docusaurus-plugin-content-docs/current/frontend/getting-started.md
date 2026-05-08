---
sidebar_position: 2
title: Boshlash (frontend)
audience: New frontend engineers
summary: Frontend uchun maxsus mahalliy sozlash — nimani o'rnatish kerak, qanday ishga tushirish, JS/CSS aslida qayerdan keladi, qanday qilib refresh majburlash, va birinchi sessiya uchun smoke-test ro'yxati.
topics: [frontend, onboarding, local-setup]
---

# Boshlash (frontend)

Bu sahifa umumiy [Local setup](../project/local-setup.md) sahifasiga frontend uchun maxsus hamrohdir. Avval o'shanaqa o'qing; bu sahifa frontend dasturchiga kerak bo'lgan qismlarni va umumiy sahifa yetishmayotgan qismlarni to'ldiradi (o'sha sahifadagi "Hot reload?" savoliga javob shunchaki "yo'q" — davom eting).

## Sizga aslida kerak bo'lgan dastlabki shartlar

- **Docker Desktop** — butun backend (web, MySQL, Redis) ni ishga tushiradi. `protected/views/*.php`, `js/*.js`, `js_plugins/*`, `css/*` ni tahrirlash uchun bu yagona zarur narsa.
- **Node 18+** — faqat agar siz quyidagilarga tegmoqchi bo'lsangiz kerak:
  - docs sayti (`sd-docs`) — `npm install && npm run start`
  - Angular oroli (`ng-modules/gps`, `ng-modules/neakb`) — `npm install && npm run build`. Qarang [ng-modules](./ng-modules.md).
- **Zamonaviy Chromium** — dev workflow DevTools ga tayanadi. Firefox ham ishlaydi, lekin jamoa misollari Chrome dan foydalanadi.

Sizga mahalliy PHP o'rnatish **kerak emas**. Hamma PHP konteynerda ishlaydi.

## Ishga tushirish

```bash
git clone git@github.com:salesdoctor/sd-main.git
cd sd-main
cp protected/config/main_sample.php protected/config/main_local.php
docker compose up -d --build
```

Web ilova **http://localhost:8080** da ([Local setup](../project/local-setup.md) ga ko'ra). `admin / admin` bilan login qiling.

## Frontend kodi aslida qayerdan keladi

Frontend build pipeline yo'q (qarang [Assets pipeline](./assets-pipeline.md)). Fayllar o'zgartirilmagan holda xizmat qiladi. Tushunish modeli:

| Siz tahrirlaysiz | Brauzer ko'radi |
|----------|--------------|
| `protected/views/<ctl>/<action>.php` | Keyingi so'rovda qayta render qilinadi |
| `js/<file>.js`, `js_plugins/<...>.js` | Brauzerni qayta yuklashda olinadi |
| `css/<file>.css` | Brauzerni qayta yuklashda olinadi |
| `ng-modules/<feature>/src/...` | **Faqat** `npm run build` `dist/` ni qayta chiqargandan **keyin** |
| `assets/<hash>/` ichidagi har narsa | Tahrirlamang — avtomatik tarzda yaratilgan nusxalar |

Yii ning `CAssetManager` "asset bundle" sifatida ro'yxatdan o'tgan har narsani `assets/<hash>/` ga nusxalaydi va hash qilingan URL ni xizmatga taqdim etadi. Bunday bundle ichidagi faylni tahrirlasangiz, hash o'zgaradi va brauzer yangi nusxani avtomatik tarzda oladi.

`clientScript->registerScriptFile` orqali to'g'ridan-to'g'ri ro'yxatdan o'tgan fayllar uchun (`js/`, `js_plugins/` ko'pchiligi), URL barqaror va brauzer eski nusxani cache qilishi mumkin. Ikki himoya:

1. **DevTools → Network → Disable cache** DevTools ochiq paytda. Bu standart frontend dev workflow.
2. **View ga versiya so'rovi qo'shish** orqali release-da hard refresh majburlash:

   ```php
   Yii::app()->clientScript
     ->registerScriptFile('/js/orders.js?v=' . VERSION);
   ```

## Brauzer DevTools sozlamalari

- **Disable cache** (Network tab) — DevTools ochiq paytda har doim yoqilgan.
- **Preserve log** (Console + Network) — ilova full-page-redirect oqimlarini bajaradi, aks holda loglar tozalanadi.
- **Source maps** — yo'q. Aksariyat fayllar allaqachon minify qilinmagan; ularni o'zgartirilmagan holda debug qiling.

## Smoke-test ro'yxati (birinchi sessiya)

Kod yozishdan oldin shu narsalarni bosib chiqing. Agar biror narsa buzilsa, bu sozlash muammosi, kodingizga aloqasi yo'q.

- [ ] http://localhost:8080 da `admin / admin` sifatida login qiling.
- [ ] Bitta **list sahifasini** oching (masalan, orders) — filtrlar render bo'lishini va jadval chizilishini tasdiqlang.
- [ ] Bitta **forma sahifasini** oching (yaratish / tahrirlash) — Chosen dropdownlar va sana tanlovchilar ishlashini tasdiqlang.
- [ ] Bitta **modal** oqimini oching — fancybox modallari ochilib-yopilishini tasdiqlang.
- [ ] **GPS xarita** sahifasini oching (`ng-modules/gps` Angular orolidan foydalanadi) — xarita plitkalari yuklanishini tasdiqlang.
- [ ] Tilni (yuqori panel) RU va EN o'rtasida almashtiring — qatorlar o'zgarishini tasdiqlang.
- [ ] DevTools → Network — `js/`, `js_plugins/`, `css/`, yoki `assets/<hash>/` URL-larida 404-lar yo'qligini tasdiqlang.
- [ ] DevTools → Console — har qanday tutilmagan xatoliklarni qayd qiling. Ba'zi legacy shovqin kutiladi; uni regress qilmasligingiz kerak bo'lgan asosiy chiziq sifatida ko'ring.

## Hot reload?

Yo'q. Umumiy [Local setup](../project/local-setup.md) sahifasi buni allaqachon ko'rsatib o'tgan. Frontend workflow:

- `protected/views/`, `js/`, yoki `css/` da faylni tahrirlang.
- Brauzerga o'ting.
- **Hard refresh**: `Cmd-Shift-R` (mac) / `Ctrl-Shift-R` (win/linux).
- DevTools → Network da **Disable cache** belgilanmagan bo'lsa, hard refresh `js_plugins/` o'zgarishlarini izchil olmaydi.

Angular orollari uchun (`ng-modules/gps`, `ng-modules/neakb`), bugungi default oqim build-keyin-refresh:

```bash
cd ng-modules/gps
npm run build
# keyin brauzerni hard-refresh qiling
```

Jonli `ng serve` jonli Yii backend ga qarshi nazariy jihatdan mumkin, ammo bugun hujjatlashtirilmagan — pastdagi ochiq savollarga qarang.

## Runtime log-ni kuzatish

Aksariyat "sahifa bo'sh" yoki "modal yuborilmaydi" muvaffaqiyatsizliklari **server tomonidagi xatoliklar** bo'lib, frontend ularni shunchaki bo'sh ko'rsatadi. Logni kuzating:

```bash
docker compose exec web tail -f protected/runtime/application.log
```

[Conventions](../project/conventions.md) ga ko'ra, AJAX oqimini debug qilayotganda bu narsani terminalda ochiq saqlang.

## Umumiy muammolar

- **`assets/` diskni to'ldirayapti** — vaqti-vaqti bilan eskirgan nashr qilingan bundlelar uchun `rm -rf assets/<hash>` ishlating.
- **`runtime/` va `assets/` ruxsatlari** — konteynerdagi `www-data` tomonidan yozilishi mumkin bo'lishi kerak; host bind mount buni buzishi mumkin.
- **PHP ogohlantirishlari logni to'ldirmoqda** — ko'plab fayllar PHP 7.3-davriga tegishli. Nimadan kelib chiqayotganingizni bilmasangiz 7.3 da qoling.
- **`protected/runtime/cache/` dagi eski cache-lar** — kamdan-kam, ammo agar view partial tahrirlashdan keyin ham qotib qolgan ko'rinsa, o'sha papkani tozalang.

## Keyin qayerga o'tish kerak

1. [Conventions](./conventions.md) — fayl tartibi, nomlash, qachon jQuery vs Angular vs Yii dan foydalanish.
2. [Adding a screen](./adding-a-screen.md) — birinchi end-to-end o'zgarishingiz uchun retsept.
3. [Yii views](./yii-views.md), [JS plagins](./js-plugins.md), [ng-modules](./ng-modules.md), [Asset pipeline](./assets-pipeline.md) — havola tafsilotlari.

## Ochiq savollar / TODO

Yozish vaqtida hal qilinmagan — jamoaga tasdiqlatib, bu sahifani bilingan paytdan keyin yangilang:

- **Yii ga qarshi jonli `ng serve`** — har bir o'zgarishda `npm run build` qadamidan qochadigan hujjatlashtirilgan dev-loop bormi?
- **Console-error asosiy chizig'i** — qabul qilinadigan legacy console xatolarining ma'lum ro'yxati bormi, yoki asosiy chiziq bo'sh bo'lishi kerakmi?
- **`?v=` qiymati manbasi** — bugun versiya so'rovi qaysi global / konstantaga havola qilishi kerak? `VERSION` yuqorida placeholder sifatida ko'rsatilgan; haqiqiy belgi har bir repo bo'yicha farq qilishi mumkin.
