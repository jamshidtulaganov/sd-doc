---
sidebar_position: 1
title: Testlash
---

# Testlash

## Holat umumiy ko'rinishi

- **sd-main**: nol loyiha testlari. PHPUnit yo'q. `tests/` katalogi yo'q. CI yo'q.
- **sd-billing**: nol loyiha testlari. PHPUnit o'rnatilmagan. `doc/TESTING_PLAN.md`
  da batafsil rollout rejasi mavjud, lekin Phase 0 boshlanmagan. CI yo'q.
- **sd-cs**: nol loyiha testlari. PHPUnit yo'q. CI yo'q.

Boshqacha aytganda: har bir loyihadagi har bir o'zgarish staging yoki
tenant nusxasiga qarshi qo'lda tekshiriladi. Hech qaerda
avtomatlashtirilgan test darvozasi yo'q.

## sd-main

### Nima mavjud

- `composer.json` bitta runtime dep ni e'lon qiladi (`minishlink/web-push`).
  `require-dev` yo'q, `phpunit` yo'q.
- `phpunit.xml` yo'q va `tests/` katalogi yo'q.
- `framework/test/` Yii 1.1 ning built-in `CTestCase`,
  `CDbTestCase`, `CWebTestCase`, `CDbFixtureManager` ni o'z ichiga oladi —
  ishlatilmaydi.
- `protected/extensions/image2/test/ImageResizeTest.php` va
  `ImageResizeExceptionTest.php` mavjud, lekin ular upstream
  `Gumlet\ImageResize` kutubxonasidan vendor qilingan va bu repo da
  hech narsa tomonidan ishga tushirilmaydi.
- `protected/vendor/vendor`
  `/var/www/novus/.../protected/vendor` ga ko'rsatadigan symlink — bu
  production hosti bo'lmagan har bir mashinada buzilgan. Eski wiki
  parchasi `./protected/vendor/bin/phpunit` shu sababli mahalliy
  ishlamaydi.

### Qanday ishga tushirish

Ishga tushirishga hech narsa yo'q.

### Qamrov bo'shliqlari

Hammasi. Service-qatlam testlari yo'q, controller testlari yo'q, model
testlari yo'q, api3 / api4 ga qarshi smoke testlari yo'q.

## sd-billing

### Nima mavjud

- Repo ildizida `composer.json` **siz** `composer.lock` mavjud (qarang:
  security-landmines element #7). Yangi clone vendored PHPUnit ga ega
  emas; production hostidagi binary takrorlanadigan emas.
- `phpunit.xml` yo'q, `tests/` katalogi yo'q.
- `framework/test/` Yii 1.1 ning `CTestCase` / `CDbTestCase` /
  `CDbFixtureManager` ni jo'natadi — ishlatilmaydi.
- Mock qilinadigan service classlari allaqachon mavjud:
  `protected/components/TariffService.php`, `SystemLogService.php`,
  `SystemService.php`, `PartnerAccessService.php`.
- `doc/TESTING_PLAN.md` testlarni kiritish uchun kanonik reja. U
  ikki-tarafli piramidani (unit + integration), `billing_test`
  ma'lumotlar bazasini, `CDbFixtureManager` orqali fixturalarni va pul
  yo'llari uchun characterization testlarini (Click webhook oqimi,
  to'lov triggerlari, settlement command) belgilaydi. Ularning hech
  biri hali amalga oshirilmagan.

### Qanday ishga tushirish

Ishga tushirishga hech narsa yo'q.

### Qamrov bo'shliqlari

Hammasi, eng yuqori xavfli sinovsiz yo'llar:

- `Diler::getBalans()` va `Diler::getTranBalans()`.
- `Payment` insert/update DB triggerlari
  (`m221114_070346_create_triggers_to_payment.php`).
- Click / Payme / Paynet / P2P / MBANK webhook oqimlari.
- `settlement` console command.

Rejalashtirilgan characterization tartibi uchun
`sd-billing/doc/TESTING_PLAN.md` Phase 4 ga qarang.

## sd-cs

### Nima mavjud

- `composer.json` `phpoffice/phpspreadsheet` va `yiisoft/yii` ni e'lon
  qiladi. `require-dev` yo'q, `phpunit` yo'q.
- `phpunit.xml` yo'q va `tests/` katalogi yo'q.
- Fixtura yo'q.

### Qanday ishga tushirish

Ishga tushirishga hech narsa yo'q.

### Qamrov bo'shliqlari

Hammasi. HQ hisobot yo'llari va Excel eksport kodida hech qanday
turdagi regression qamrovi yo'q.

## CI

Uchta loyihadan birortasida ham CI yo'q. `.github/workflows/`,
`.gitlab-ci.yml`, Bitbucket pipeline lari yoki `Makefile` ga asoslangan
test maqsadlari yo'q. Har qanday daraxtdagi yagona `Makefile` fayllari
vendor qilingan frontend kutubxonalariga tegishli
(`vendors/bootstrap-datetimepicker`, `vendors/flot-chart`).

## Yangi testlarni yozishda konventsiyalar

Hozircha kuzatib boriladigan in-tree konventsiya yo'q. Agar siz
**sd-billing** da testlarni boshlayotgan bo'lsangiz, aynan
`doc/TESTING_PLAN.md` ga rioya qiling — u katalog tartibini
(`tests/unit/`, `tests/integration/`,
`tests/fixtures/`, `tests/support/`), bootstrap fayllarini,
`phpunit.xml.dist` shaklini, `composer test*` script nomlarini, AAA
pattern ni va
`test<MethodName><ExpectedBehavior>When<Condition>` nomlash qoidasini
belgilaydi.

**sd-main** va **sd-cs** uchun ekvivalent reja yo'q — testlarni
qo'shishdan oldin design hujjatida mos tartibni taklif qiling.

Loyiha bootstrap i kelmaguncha, `protected/` ostiga adashgan
`*Test.php` fayllarni qo'shmang: ularni olib oladigan runner yo'q va
ular jimgina chirib ketadi.

## Shuningdek qarang

- `sd-billing/doc/TESTING_PLAN.md` — yagona aniq reja-rekord.
- [`sd-billing/security-landmines.md`](../sd-billing/security-landmines.md)
  elementlar #7 (yetishmayotgan `composer.json`) va #10 (test qamrovi
  qurilmoqda).
- Kengroq PR oqimi uchun [`quality/contribution.md`](./contribution.md).
