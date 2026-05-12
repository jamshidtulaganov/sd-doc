---
sidebar_position: 5
title: Lokal sozlash
---

# sd-cs lokal sozlash

sd-cs eski uslubdagi host-PHP Yii 1.1 ilovasi. Repoda Dockerfile yoki
compose stack mavjud emas — siz `index.php` ni lokal webroot'dan
xizmat qilasiz (nginx/Apache + PHP-FPM yoki tezkor tekshirish uchun
`php -S`). Real qiyinchiliklar — bu **ikkita MySQL ulanishi** va
**Redis kesh**.

## Talablar

- PHP 7.3+ va `pdo_mysql`, `mbstring`, `gd`, `bcmath`, `redis` kengaytmalari
- Composer
- Lokal MySQL 5.7/8.x
- Erishiladigan Redis (birga keladigan konfiguratsiya `10.0.0.11:6379` ga
  ishora qiladi — quyidagi gotcha'ga qarang)
- Klonlashtirilgan repo katalogidan xizmat ko'rsatiluvchi webroot
- `sd-main` allaqachon lokal ishlab turgan (Variant A seed quyida unga bog'liq)

## Ko'tarish

```bash
git clone <repo> sd-cs
cd sd-cs

# 1. Framework + phpspreadsheet ni vendor/ ga yuklash
composer install

# 2. runtime / assets / uploads papkalarini yaratish (bir martalik)
php default_folders.php

# 3. DB hisob ma'lumotlarini taqdim etish (gitignored)
cp protected/config/db_sample.php protected/config/db.php
$EDITOR protected/config/db.php
```

So'ng webserver hujjat ildizini repo katalogiga yo'naltiring. Tezkor
smoke test uchun `php -S` bilan:

```bash
php -S 127.0.0.1:8090 index.php
```

nginx uchun loyiha `$_SERVER['DOCUMENT_ROOT']` ning repo ildiziga
hal bo'lishiga tayanadi (`protected/config/main.php` ga qarang) —
server blokidagi `root` ko'rsatkichi pastki katalogga emas, o'sha
joyga yo'nalganligini tasdiqlang.

## Ikki ma'lumotlar bazasi ulanishini sozlash

`db_sample.php` ikkita stub ulanish bilan keladi. Joy egallovchi
hostlar (`localhost1`, `localhost2`) ataylab eslatma sifatida
qo'yilgan: bu ikki ulanish — productionda ham — turli MySQL hostlarida
yashashi mumkin va shunday yashaydi.

### `db` — o'z `cs_*` sxemasi

sd-cs ning o'z ma'lumotlar bazasi. Lokal yarating:

```sql
CREATE DATABASE cs_dev CHARACTER SET utf8mb4;
```

`cs_*` jadvallar uchun dump yoki migratsiya manbasi kerak bo'ladi;
agar dumps SharePoint da joriy sanitsiyalangan dump bo'lmasa,
`#sd-cs` da so'rang.

### `dealer` — almashinadigan `d0_*` ulanish

Bu dilerning sd-main ma'lumotlar bazasi. `dealer` komponentining DSN'i
sd-cs boshqa dilerdan o'qiyotganda **runtime'da almashtiriladi**
(`docs/sd-cs/multi-db.md` ga qarang); `db.php` dagi qiymat shunchaki
default.

Lokal dev uchun ishlaydigan `db.php`:

```php
return [
    'db' => [
        'connectionString' => 'mysql:host=127.0.0.1;dbname=cs_dev',
        'emulatePrepare'   => true,
        'username'         => 'root',
        'password'         => 'secret',
        'charset'          => 'utf8',
        'tablePrefix'      => 'cs_',
    ],
    'dealer' => [
        'class'            => 'CDbConnection',
        'connectionString' => 'mysql:host=127.0.0.1;dbname=sd_main',
        'emulatePrepare'   => true,
        'username'         => 'root',
        'password'         => 'secret',
        'charset'          => 'utf8',
        'tablePrefix'      => 'd0_',
    ],
];
```

## Seed ma'lumotlari

### Variant A — `dealer` ni sd-main lokal DB'siga yo'naltirish (tavsiya etiladi)

Agar `docs/project/local-setup.md` ga muvofiq sd-main ni lokal ishga
tushirgan bo'lsangiz, sizda allaqachon `d0_` jadvallari bilan
`sd_main` sxemasi bor. Shunchaki `dealer` ni unga yo'naltiring
(yuqoridagi DSN). Qo'shimcha dump ishlari kerak emas.

Agar sd-main Docker'da bo'lsa, 3306 ni hostga ochib qo'ying (default
compose fayli shunday qiladi) va sd-cs dan `127.0.0.1:3306` ni
ishlating.

### Variant B — ikkita MySQL instansi

Cross-host holatini sinab ko'rish (haqiqiy production shakli) uchun
boshqa portda ikkinchi MySQL ishga tushiring (masalan, 3307) va
`dealer` ni unga yo'naltiring. Sizga haqiqiy dilerdan `d0_` dump kerak
bo'ladi — sintetik seed mavjud emas.

### Variant C — read-only staging replika

Agar kirish huquqingiz bo'lsa, `dealer` ni staging replika DSN'iga
yo'naltiring. Read-only sifatida muomala qiling; sd-cs asosan
hisobotchi va hech qanday holatda yozmasligi kerak.

## Test login

`cs_*` foydalanuvchilari `cs_users` da yashaydi (yoki ekvivalent —
seed dump'ni tekshiring). Repoda belgilangan default hisob ma'lumotlari
yo'q; sizga dump beradigan kishi login ham beradi.

## Multi-DB almashinuvini smoke check qilish

Ikkala ulanish ishlayotganini isbotlovchi minimal kontroller:

```php
public function actionPing() {
    $cs = Yii::app()->db->createCommand('SELECT 1')->queryScalar();
    $dl = Yii::app()->dealer->createCommand(
        'SELECT COUNT(*) FROM d0_users'
    )->queryScalar();
    echo "cs={$cs}, dealer_users={$dl}";
}
```

`/site/ping` ni urib ko'ring (yoki uni qayerga ulagan bo'lsangiz). Agar
`cs=1` bo'lsa-yu, `dealer_users` xato bersa, sizning `dealer` DSN/hisob
ma'lumotlaringiz noto'g'ri.

## Keng tarqalgan gotcha'lar

- **Redis hostnomi hardcoded.** `protected/config/main.php` da
  `redis_cache.hostname = '10.0.0.11'`. Lokal sharoitda deyarli
  aniq `127.0.0.1` xohlaysiz. O'zgarishni commit qilmang — uni faqat
  lokal-only edit sifatida saqlang yoki gitignored `params.php`-uslubidagi
  include orqali override qiling.
- **Sessiyalar Redis orqali o'tadi.** Redis erishilmas bo'lsa, login
  jimgina muvaffaqiyatsiz tugaydi (`CCacheHttpSession` saqlay olmaydi).
  Login buzilgandek ko'rinsa, avval `protected/runtime` log'larini
  tekshiring.
- **`themes/classic/` override'lari yutadi.** Agar view'dagi tahrir
  ko'rinmasa, `themes/classic/views/<...>` siz tahrirlagan faylni
  soyalantirayotganini tekshiring.
- **`assets/` ruxsatlari.** `default_folders.php` uni 0777 yaratadi,
  lekin agar webserver foydalanuvchisi sizning CLI foydalanuvchingizdan
  farq qilsa, bootstrap'dan keyin qayta yarating yoki `chown` qiling.
- **Cross-DB JOIN'lar taqiqlangan.** `db` va `dealer` productionda
  turli hostlarda bo'lishi mumkin, shuning uchun ular orasidagi JOIN'lar
  lokal ishlasa ham, real muhitda buziladi. PHP'da agregatsiya qiling.
- **`YII_DEBUG` sentinel fayl orqali yoqiladi.** Repo ildizida
  `touch DEBUG` debug rejimini yoqadi (`index.php` ga qarang).

## Shuningdek qarang

- [Multi-DB ulanish](./multi-db.md) — `dealer` almashinuvi runtime'da qanday ishlaydi
- [`docs/project/local-setup.md`](../project/local-setup.md) — sd-main sozlamasi, sd-cs Variant A da undan o'qiydi
