---
sidebar_position: 13
title: API ma'lumotnomasi (kiruvchi)
audience: Backend muhandislari, integratsiya hamkorlari, ops
summary: sd-billing/protected/modules/api ostidagi har bir kontroller va amalning to'liq ro'yxati — har bir endpoint uchun auth sxemasi, payload shakli, javob shakli va chaqiruv joyi. Click, Payme, Paynet, License, Sms, Host, Info, Quest, App, Api1C kiritilgan.
topics: [api, license, click, payme, paynet, sms, host, info, quest, 1c, sd-billing]
---

# API ma'lumotnomasi (kiruvchi)

`sd-billing/protected/modules/api/` ostidagi har bir endpoint. Bu **kiruvchi**
yuza — boshqa tizimlar (dilerlarning `sd-main`, to'lov shlyuzlari, 1C,
hamkor vositalari) sd-billing'ga qarshi nimani chaqiradi.

> Chiquvchi chaqiruvlar (sd-billing → diler `sd-main`, sd-billing → sd-cs)
> [Loyihalararo integratsiya](../architecture/cross-project-integration.md) sahifasida hujjatlashtirilgan.

## Auth sxemalariga umumiy nazar

api moduli **beshta turli auth sxemasidan** foydalanadi, har bir kontroller
(yoki ba'zan har bir amal) uchun bittadan. Endpoint qo'shganingizda,
ichida bo'lgan kontrollerning mavjud sxemasiga moslang — aralashtirmang.

| Sxema | Qayerda | Nimani anglatadi |
|-------|---------|------------------|
| **Umumiy statik `TOKEN`** | `LicenseController` | `$_POST['token']` `LicenseController::TOKEN` konstantasiga teng bo'lishi kerak |
| **Psevdo-foydalanuvchi `sd/sd`** | `SmsController::init` | Avtomatik `User(LOGIN='sd')` sifatida kiradi; undan keyingi hamma narsa "tasdiqlangan" |
| **Body-ichida login** | `Api1CController::checkAuth` | JSON tanasida `auth: {login, password}` bor; `password` MD5 |
| **Bearer token** | `HostController`, `AppController` qismlari | Birinchi `actionAuth` almashinuvidan keyin `Authorization: Bearer <User.TOKEN>` |
| **Shlyuz imzosi** | `ClickController`, `PaymeController`, `PaynetController` | Har bir shlyuz uchun HMAC / sign tekshiruvi |
| **HTTP Basic** | `QuestController` | `Authorization: Basic …` |

> ⚠️ Umumiy `LicenseController::TOKEN` **manba kodida qattiq kodlangan**.
> [Xavfsizlik landminalari](./security-landmines.md) sahifasiga qarang.
> Har qanday `new UserIdentity("sd","sd")` ishlatilishi uchun ham xuddi shu ogohlantirish.

## Modul konfiguratsiyasi

`api` boshqa modullar singari `protected/config/main.php`da ro'yxatga olingan.
Yo'nalishlar `/api/<controller>/<action>` shaklida hal qilinadi (masalan,
`/api/license/buyPackages`, `/api/click`, `/api/payme`).

---

## 1. `LicenseController` — `/api/license/*`

Auth: `$_POST['token']` sifatida tekshiriladigan qattiq kodlangan `const TOKEN = "...";`.
Bu chaqiruvlar uchun kirgan umumiy foydalanuvchi odatda `UserIdentity("sd","sd")`.

Butun api modulidagi eng ko'p ishlatiladigan kontroller. Diler paketlar yoki
balans bilan o'zaro aloqada bo'lganda har bir dilerning `sd-main` tomonidan chaqiriladi.

| Amal | Metod | Tana | Qaytaradi | Eslatmalar |
|------|-------|------|-----------|------------|
| `actionIndex` | `POST /api/license` | `{token, dealer}` | `{balance, minAmount, currency, credit_limit, credit_date, …}` | Eski — fayl-izoh `// old, we should delete it` |
| `actionIndexBatch` | `POST /api/license/indexBatch` | `{token, dealers[]}` | yuqoridagi kabi, batchda | |
| `actionPackages` | `POST /api/license/packages` | `{token, dealer}` | `[{package_id, name, type, price, currency, …}]` | `Diler.COUNTRY_ID`, `CURRENCY_ID`, demo flag bo'yicha filtrlanadi |
| `actionBotPackages` | `POST /api/license/botPackages` | shu kabi | faqat-bot paketlar (`bot_order`, `bot_report`) | |
| `actionHalfPackages` | `POST /api/license/halfPackages` | shu kabi | yarim oylik/qisman paketlar | |
| `actionBuyPackages` | `POST /api/license/buyPackages` | `{token, dealer, packages[], date?}` | `{success, balance, subscriptions[]}` | **Pul-harakat chaqiruvi.** `Subscription` qatorlarini va manfiy `Payment(TYPE=license)` qo'shadi. [Obuna oqimi](./subscription-flow.md) sahifasiga qarang. |
| `actionChangePackage` | `POST /api/license/changePackage` | `{token, dealer, sub_id, new_package_id}` | `{success, …}` | Kunlarni proporsional taqsimlaydi |
| `actionRevise` | `POST /api/license/revise` | `{token, dealer, from, to}` | hisob-kitob snimkasi | |
| `actionDistrRevise` | `POST /api/license/distrRevise` | `{token, distr, from, to}` | distribyutor darajasidagi hisob-kitob | |
| `actionPayments` | `POST /api/license/payments` | `{token, dealer}` | so'nggi `Payment` qatorlari | |
| `actionCheckMin` | `POST /api/license/checkMin` | `{token, dealer}` | `{ok\|fail, min_summa}` | `BALANS ≥ MIN_SUMMA` ni tekshiradi |
| `actionBonusPackages` | `POST /api/license/bonusPackages` | `{token, dealer}` | bonus katalog qatorlari | |
| `actionExchangeable` | `POST /api/license/exchangeable` | `{token, dealer}` | almashish uchun yaroqli obunalar | |
| `actionExchange` | `POST /api/license/exchange` | `{token, dealer, src_sub_id, dst_package_id}` | yangi `Subscription` qatorlari | Bir paketdan boshqasiga ishlatilmagan kunlarni almashtiradi |
| `actionDeleteOne` | `POST /api/license/deleteOne` | `{token, dealer, sub_id}` | `{success}` | Bitta obunani yumshoq o'chiradi |

### `init` xatti-harakati

```php
public function init() {
    $this->date = date("Y-m-d");
    if (DateHelper::validateDate($_POST["date"], "Y-m-d")) {
        $this->date = $_POST["date"];
    }
}
```

Diler soati boshqa vaqt zonasida bo'lganda (Qozog'iston va O'zbekiston va h.k.)
tanada `date` ni o'tkazing.

### Token tekshiruvi

Har bir amal `auth()` ni chaqiradi, bu `self::TOKEN != $_POST['token']` ni
baholaydi va o'tib ketmagan holda qisqa-tutashuvga olib keladi. Bugungi kunda
har-token uchun rotatsiya yo'q.

---

## 2. `ClickController` — `/api/click`

Auth: Click tomonidagi `ClickTransaction::checkSign` orqali tasdiqlanadigan **HMAC sign**.

Click prepare/confirm ni boshqaradigan `action` maydoni bilan bitta endpointga uradi.

| `action` | Bosqich | Effekt |
|----------|---------|--------|
| `0` (prepare) | rezervatsiya | `ClickTransaction` qo'shadi (state = prepared) |
| `1` (confirm) | hisob-kitob | state = confirmed o'rnatadi, `Payment(TYPE_CLICKONLINE)`, `Diler::deleteLicense()`, `Diler::refresh()` qo'shadi |

Idempotentlik: takroriy `prepare` yoki `confirm` boshqa `Payment` qo'shmasdan
xuddi shu javobni qaytaradi (`ClickTransaction` holat mashinasi bunga to'sqinlik qiladi).

Xato kodlari (`ClickController::send` orqali):

| Kod | Ma'nosi |
|-----|---------|
| `0` | muvaffaqiyat |
| `-1` | imzoni tasdiqlash xatosi |
| `-2` | noto'g'ri `amount` |
| `-3` | amal topilmadi |
| `-4` | allaqachon to'langan |
| `-5` | diler topilmadi |
| `-6` | tranzaksiya topilmadi |
| `-7` | tranzaksiya muddati o'tgan |
| `-8` | DB tranzaksiyasi muvaffaqiyatsiz tugadi |
| `-9` | boshqa narsa |

Ketma-ketlik diagrammasi uchun [To'lov shlyuzlari · Click oqimi](./payment-gateways.md#click-flow-canonical) sahifasiga qarang.

---

## 3. `PaymeController` — `/api/payme`

Auth: `api/helpers/PaymeHelper` ichida tasdiqlanadigan `Authorization` sarlavhasi orqali Payme **HMAC**.

Bitta JSON-RPC endpoint `method` bo'yicha dispatch qiladi:

| Payme metodi | Effekt |
|--------------|--------|
| `CheckPerformTransaction` | Diler + miqdorni tasdiqlash, DB yozuvi yo'q |
| `CreateTransaction` | `PaymeTransaction(state=created)` qo'shadi |
| `PerformTransaction` | state = performed o'rnatadi, `Payment(TYPE_PAYMEONLINE)` qo'shadi, hisob-kitob qiladi |
| `CancelTransaction` | Bekor qilish |
| `CheckTransaction` | Holatni o'qish |
| `GetStatement` | Hisob-kitob uchun diapazon so'rovi |

Xatolar Payme JSON-RPC xato shartnomasiga amal qiladi.

Kontroller tanasi qisqa (`PaymeController.php:16`) — deyarli barcha mantiq
`PaymeHelper`da va `PaymeTransaction` modelida yashaydi.

---

## 4. `PaynetController` — `/api/paynet`

Auth: `paynetuz` kengaytmasi (`protected/extensions/paynetuz/`) orqali SOAP / WS-Security.
Hisob ma'lumotlari shabloni `_constants.php`da yashaydi.

Bu SOAP endpoint, REST emas. Paynet shlyuzi soap endpointga `Pay`, `Status`, `Cancel`
chaqiruvlari bilan uradi; kontroller har birini `PaynetTransaction`ga va
(muvaffaqiyatli bo'lganda) `Payment(TYPE_PAYNETONLINE)` qatoriga yozadi.

---

## 5. `Api1CController` — `/api/api1C/*` (1C integratsiya)

Auth: **body-ichida login** — JSON tanasida `auth: {login, password}` bo'lishi kerak.
Parol `User.PASSWORD = MD5($pwd)` ga mos keladi.

Kiruvchi 1C integratsiyasi — katta kontroller (985 qator), naqd bo'lmagan to'lov
importlariga va obuna so'rovlariga tegadi.

| Amal | Metod | Maqsad |
|------|-------|--------|
| `actionIndex` | `POST /api/api1C` | Health/auth tekshiruvi |
| `actionAddCashless` | `POST /api/api1C/addCashless` | 1C dan naqd bo'lmagan to'lovlarning ommaviy importi; idempotentlik uchun `(inn, payment_1c)` bilan kalitlangan `Payment(TYPE_CASHLESS)` qo'shadi |
| `actionGetSubscriptionsOld` | `POST /api/api1C/getSubscriptionsOld` | Eski obuna eksporti — eski 1C joylashtirishlari uchun saqlanadi |
| `actionGetSubscriptions` | `POST /api/api1C/getSubscriptions` | Joriy obuna eksporti |

`addCashless` uchun so'rov shakli:

```json
{
  "auth": {"login": "...", "password": "..."},
  "content": [
    {
      "inn": "123456789",
      "payment_1c": "PAY-2026-00001",
      "amount": 100000,
      "currency": "UZS",
      "date": "2026-05-08",
      "comment": "..."
    }
  ]
}
```

Javob har bir qator uchun `errors[]` massivini o'z ichiga oladi, shuning uchun
qisman muvaffaqiyatlar 1C tomonida ko'rinadigan bo'ladi.

---

## 6. `SmsController` — `/api/sms/*`

Auth: `init()` avtomatik ravishda `User(LOGIN='sd', PASSWORD='sd')` sifatida kiradi.

| Amal | Metod | Maqsad |
|------|-------|--------|
| `actionPackages` | `POST /api/sms/packages` | Valyuta uchun sotib olinadigan SMS paketlar ro'yxati |
| `actionBuySmsPackage` | `POST /api/sms/buySmsPackage` | `BALANS`ni hisoblash, dilerga SMS pak ulash |
| `actionBoughtSmsPackages` | `POST /api/sms/boughtSmsPackages` | Diler xaridlari tarixi |
| `actionCreateTemplate` | `POST /api/sms/createTemplate` | Eskizda shablon ro'yxatga olish |
| `actionCheckingTemplates` | `POST /api/sms/checkingTemplates` | Mahalliy ↔ Eskiz shablonlarini sinxronlash |
| `actionOne` | `POST /api/sms/one` | Bitta SMS yuborish |
| `actionSend` | `POST /api/sms/send` | `Sms::multy` orqali ommaviy yuborish |
| `actionSendingForward` | `POST /api/sms/sendingForward` | Navbatdagi yuborishlarni yo'naltirish |
| `actionCallback` | `POST /api/sms/callback?host=…` | Eskiz yetkazib berish-kvitansiya webhook |

SMS provayder tafsilotlari (Eskiz UZ, Mobizon KZ): [Bildirishnomalar · SMS](./notifications.md#7-sms--eskiz-uz-and-mobizon-kz)
sahifasiga qarang.

---

## 7. `HostController` — `/api/host/*`

Auth: oldingi `actionAuth` almashinuvidan **Bearer token** (`User.TOKEN`).

"Kim qayerda joylashtirilgan" ro'yxatini talab qiluvchi ichki monitoring vositalari /
boshqaruv panellari tomonidan ishlatiladi.

| Amal | Metod | Maqsad |
|------|-------|--------|
| `actionAuth` | `POST /api/host/auth` | `{login, password}` (MD5) → `{token}` (`User.TOKEN`ni yangilaydi) |
| `actionActiveHosts` | `GET /api/host/activeHosts` | `STATUS = ACTIVE` bo'lgan barcha `Diler` qatorlari |
| `actionActivities` | `GET /api/host/activities?date_from=&date_to=` | Faol hostlardagi faollikni olish uchun multi-curl tarqatish. |
| `actionActivityByHost` | `GET /api/host/activityByHost?host=` | Bitta host tafsiloti |

Eslatma: `actionActivities` `curl_multi_init` orqali parallel ravishda o'nlab
chiquvchi curl ochadi — hostlar qo'shganingizda ehtiyot bo'ling; sd-billing
konteyneri har bir dilerga yetib borish uchun tarmoq egress'ga muhtoj.

---

## 8. `InfoController` — `/api/info/*`

Auth: aralash. Aksariyat amallar **deyarli ochiq** (token yo'q) va
tarmoq darajasidagi kirish nazoratlariga tayanadi.

| Amal | Metod | Maqsad |
|------|-------|--------|
| `actionIndex` | `POST /api/info` | `dealer_id` yoki `host` bo'yicha dilerni qidirish; qaytaradi `{id, host, domain, is_demo, status, db_name, db_status, max_id, min_id}` |
| `actionSdToken` | `POST /api/info/sdToken` | Ba'zi quyi oqim vositalari tomonidan ishlatiladigan umumiy "sd" tokenini berish / yangilash |
| `actionChangePassword` | `POST /api/info/changePassword` | `User`ning parolini o'zgartirish — kam uchraydigan admin yo'li |

`actionIndex`ni **diler-aniqlash** sifatida ko'ring — endpointga yetib boradigan har
kim diler hostlarini sanab chiqishi mumkin. Keng tarqatishdan oldin qattiqlashtiring.

---

## 9. `QuestController` — `/api/quest/*`

Auth: `actionIndex`da **HTTP Basic** (`Authorization: Basic …`),
`actionDetail`da **`token` query parametri**.

| Amal | Metod | Maqsad |
|------|-------|--------|
| `actionIndex` | `GET /api/quest` | KPI snimkasi — price, idokon, ibox, np, churn, upSall, netSale, golden |
| `actionDetail` | `GET /api/quest/detail?token=…` | Har-foydalanuvchi tafsiloti; `User.TOKEN` query parametri |

Bu asosan ichki hamkor-portaliga yaqin yuza — odatdagi billing oqimlarida
kam tegiladi.

---

## 10. `AppController` — `/api/app/*`

Auth: `actionAuth` login qiladi va `token` qaytaradi; keyingi amallar
`User.TOKEN`ni qidiradi.

| Amal | Metod | Maqsad |
|------|-------|--------|
| `actionAuth` | `POST /api/app/auth` | Login, qaytaradi `{success, token}` |
| `actionGetPrinters` | `POST /api/app/getPrinters` | Desktop ilova uchun printerlar reestri |
| `actionExecute` | `POST /api/app/execute` | Umumiy dispatcher — desktop ilova oldindan tayyorlangan amallarni ishlatish uchun ishlatadi |

Operator desktop ilova tomonidan ishlatiladi, dilerlar tomonidan emas.

---

## 11. Umumiy javob yordamchilari

Barcha kontrollerlar oxir-oqibat shulardan biri orqali render qiladi:

| Yordamchi | Qayerda aniqlangan | Shakl |
|-----------|--------------------|-------|
| `sendSuccessResponse($data)` | `application.modules.api.components.*` | `{success: true, data: <data>}` |
| `sendFailResponse($errors[, $extra])` | shu yerda | `{success: false, errors: [...], data?: <extra>}` |
| `_sendSuccessResponse($code, $data, $errors)` (`Api1CController`) | inline | 1C-maxsus — turli shakl |
| `response($payload, $statusCode = 200)` (`HostController`) | inline | HTTP holatini o'rnatadi, JSON-kodlaydi |
| `json($data)` | controller-base | JSON, chop etilgandan keyin o'ladi |
| `send($data, $errorCode, $click=false, …)` (`ClickController`) | inline | Click-maxsus — kodga qarang |

Shakllar kontrollerlar bo'yicha **mos kelmaydi** — siz teginayotgan kontroller
tomonidan allaqachon ishlatilganiga moslang, aralashtirmang.

---

## 12. Loglash

`Logger::writeLog2($data, $is_req, $path)` har-kun har-amal JSON fayllarni
`log/<controller>/<YYYY-MM-DD>/` ostida yozadi. Shlyuz va 1C kontrollerlari
tomonidan ko'p ishlatiladi.

> ⚠️ Loglashdan oldin kirishlarni tozalang. Hech qachon karta tafsilotlarini,
> to'liq Payme/Click payloadlarini yoki diler parollarini logga yozmang.
> Joriy implementatsiya bir nechta joyda xom `$body` ni logga yozadi —
> ularga teginayotganda holat-bo'yicha tuzating.

---

## 13. Xato / holat kodi konventsiyalari

API yuzasi yagona konventsiyadan oldin paydo bo'lgan. Bugun:

| Manba | Nimani ko'rasiz |
|-------|-----------------|
| `LicenseController` | Deyarli barcha xatolar uchun `{success: false, errors: [...]}` tanasi bilan HTTP 200; 4xx kam uchraydi |
| `Api1CController` | Auth uchun `_sendFailResponse(401, [...])`, aks holda `_sendSuccessResponse(200, ...)` |
| `HostController` | Tegishli HTTP holat kodlari (`401`, `200`, `400`) |
| `Click`, `Payme`, `Paynet` | Shlyuz-maxsus xato konvertlari |

Yangi amallarni qo'shganingizda, `HostController` uslubini afzal ko'ring (haqiqiy HTTP
holat kodlari) — bu oldinga to'g'ri naqsh. Aniq tasdiqsiz boshqalarni qayta yozmang;
quyi oqim chaqiruvchilari eski shakllarga bog'liq.

---

## 14. Qattiqlashtirish ro'yxati

- [ ] `LicenseController::TOKEN`ni har-chaqiruvchi imzolangan JWT bilan almashtiring.
- [ ] `new UserIdentity("sd","sd")`ni minimal `Access` qatorlariga ega aniq
      xizmat hisoblari bilan almashtiring.
- [ ] WAF darajasida ratelimitlarni qo'shing (login, shlyuz-callback).
- [ ] `HostController` javob shaklini standartlashtiring — va chaqiruvchilarni
      reliz oynasi davomida ko'chiring.
- [ ] `Api1CController` bo'ylab `Logger::writeLog2` kirishlarini tozalang.
- [ ] Endpoint-bo'yicha tuzilgan so'rov/javob auditini qo'shing (ad-hoc har-kun
      JSON fayllarini almashtiring).

## Yana qarang

- [To'lov shlyuzlari](./payment-gateways.md) — Click/Payme/Paynet oqimlari batafsil.
- [Obuna va litsenziyalash](./subscription-flow.md) — `actionBuyPackages` aslida nima qiladi.
- [Bildirishnomalar](./notifications.md) — `SmsController` tafsilotlari + Eskiz/Mobizon.
- [Loyihalararo integratsiya](../architecture/cross-project-integration.md) — simning chiquvchi tomoni.
- [Xavfsizlik landminalari](./security-landmines.md) — qattiq kodlangan tokenlar, MD5 parollar, hamkor tekshiruvi o'chirilgan.
