---
sidebar_position: 1
title: Xususiyat ish oqimlari · indeks
slug: /sd-billing/workflows
---

# Xususiyat ish oqimlari — katalog

Bu **sd-billing** dagi har bir xususiyat (bitta shlyuz integratsiyasi, bitta
admin ekrani, bitta operatsiya formasi, bitta hisobot, bitta cron buyrug'i)
indeksi. Har bir qator bitta kontroller; **qalin** bog'langan qatorlar
[uslublar qo'llanmasi](./style.md) ga amal qiluvchi to'liq ish oqimi
sahifasiga ega. Bog'lanmagan qatorlar — stublar — ularning xususiyati kodda
mavjud, lekin ish oqimi sahifasi hali yozilmagan.

Agar siz yangi xodim bo'lsangiz, bu yerdan boshlang:

1. Bitta-DB, har-tenant-litsenziya modelini tushunish uchun
   [sd-billing umumiy ko'rinish](../overview.md) va
   [auth va kirish](../auth-and-access.md) ni o'qing.
2. Ish oqimi sahifalari nimani anglatishini bilishingiz uchun [uslublar qo'llanmasi](./style.md)
   ni o'qing.
3. Quyida ish oqimi sahifasini tanlang — yoki, agar tayinlangan xususiyatingiz
   faqat stubga ega bo'lsa, `sd-billing-workflow-author` skili yordamida uni
   loyihalang (`sd-docs/skills/sd-billing-workflow-author/SKILL.md`da yashaydi).

> **Manba**: har bir kirish `sd-billing/protected/modules/<module>/controllers/`
> ostidagi bitta kontroller fayliga moslanadi.

## Uslub va skill

| Sahifa | Qachon o'qish |
|--------|---------------|
| [Uslublar qo'llanmasi](./style.md) | Har qanday xususiyat sahifasini yozishdan yoki ko'rib chiqishdan oldin |
| `sd-docs/skills/sd-billing-workflow-author/SKILL.md` | Stubni to'liq sahifaga loyihalashda (fayl yo'li, hujjatlar saytida emas) |

---

## api · shlyuz veb-hooklar

To'lov shlyuzlari, tashqi tizimlar va admin vositalardan kiruvchi HTTP
chaqiruvlarini qabul qiladi. Auth har kontroller uchun farq qiladi —
tafsilotlar uchun [modullar](../modules.md) ga qarang.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| [Click shlyuzi](./api-click.md) | `ClickController` | Click prepare/confirm callbacklarini boshqaradi; `ClickTransaction::checkSign()` bilan signni tasdiqlaydi |
| Payme shlyuzi | `PaymeController` | Payme JSON-RPC endpoint; to'lovlarni hisoblashdan oldin HMACni tasdiqlaydi |
| Paynet shlyuzi | `PaynetController` | `extensions/paynetuz` orqali Paynet SOAP integratsiyasi; to'lov tasdiqlarini qayta ishlaydi |
| 1C integratsiya | `Api1CController` | 1C buxgalteriyasidan naqd-bo'lmagan to'lov yozuvlarini va balans sinxronlashni qabul qiladi |
| App API | `AppController` | Mobil/ilova auth endpoint — billing app klienti uchun sessiya tokenlarini beradi |
| Host status | `HostController` | `sd-main` instansiyalaridan faol-host pinglar va token auth chaqiruvlarini qabul qiladi |
| Litsenziya endpointlari | `LicenseController` | Diler litsenziyalarini so'rash va yangilash uchun TOKEN-himoyalangan endpointlar (loginda `sd-main` tomonidan o'qiladi) |
| SMS veb-hook | `SmsController` | Eskiz / Mobizon dan kiruvchi SMS yetkazib berish-kvitansiya (DLR) callbacklari |
| Info / health | `InfoController` | Ochiq health-check va billing-ma'lumot endpointi; auth talab qilinmaydi |
| Quest | `QuestController` | Maxsus quest-metrika endpoint; basic auth orqali hisoblangan KPI larni qaytaradi (price, churn, NPS, …) |

---

## operation · obunalar va to'lovlar

Yozuv trafigining ko'pchiligi sodir bo'ladigan joy. Obuna hayot tsikliga,
to'lov yozishga, paket boshqaruviga, tariflarga va qora ro'yxatga ega.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| [Obuna hayot tsikli](./operation-subscription.md) | `SubscriptionController` | Diler obunalari uchun CRUD; amallar: list, create, update, delete, exchange, calculate-bonus |
| [To'lov yozish](./operation-payment.md) | `PaymentController` | Dilerga qarshi kiruvchi to'lovlarni yozadi; cashbox, distribyutor va shlyuz manbalarini qo'llab-quvvatlaydi |
| Paket boshqaruvi | `PackageController` | Billing paketlari uchun CRUD (narx va davomiyligi bilan xususiyat to'plamlari) |
| Paket SMPro | `PackageSMProController` | SMPro mahsulot liniyasiga ko'lamlangan paket boshqaruvi varianti |
| Obuna SMPro | `SubscriptionSMProController` | SMPro dilerlariga ko'lamlangan obuna boshqaruvi |
| Diler-paket aloqasi | `RelationController` | Dilerlarni paketlarga moslaydi; diler qaysi xususiyat to'plamlarini faollashtira olishini boshqaradi |
| Tarif boshqaruvi | `TariffController` | Paketlarga bog'langan tarif rejalari uchun CRUD |
| Qora ro'yxat | `BlacklistController` | Dilerlarni to'lov/kirish qora ro'yxatiga qo'shadi yoki olib tashlaydi |
| Bildirishnomalar | `NotificationController` | Chiquvchi bildirishnoma qoidalarini boshqaradi (muddat ogohlantirishlari, to'lov kvitansiyalari) |
| Ko'rinish hub | `ViewController` | Operation modul sahifalari uchun umumiy ko'rinish kirish nuqtasi |

---

## dashboard · admin UI

Operatsion jamoaning asosiy ekrani. Dilerlar, distribyutorlar,
to'lovlar, obunalar, jadvallar va qotib qolgan yozuvlarni tuzatishni ro'yxatlaydi.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Boshqaruv paneli boshi | `DashboardController` | Asosiy admin landing sahifasi — KPI plitalari, diler hisoblari, oxirgi to'lovlar |
| Diler administratsiyasi | `DealerController` | Qidiruv, holat filtri, tarif va qora ro'yxat boshqaruvi bilan Vue-quvvatli diler ro'yxati |
| Diler (eski) | `DilerController` | Eski AJAX-CRUD diler ekrani; `DealerController`ning oldingisi |
| Distribyutor | `DistrController` | Distribyutor yozuvlarini AJAX-CRUD boshqaruvi |
| Distribyutor hisoblash | `DistrComputationController` | Har-distribyutor settlement hisoblash ko'rinishi (faqat-admin) |
| Hisoblash (settlement) | `ComputationController` | Diler↔distribyutor balans settlement bajarishlarini ishga tushiradi va ko'rib chiqadi |
| Distribyutor to'lovlari | `DistrPaymentController` | Distribyutor va sd-billing o'rtasidagi to'lovlar AJAX-CRUD jurnali |
| Boshqaruv paneli to'lov | `PaymentController` | Barcha kiruvchi to'lovlarning faqat-o'qish dashbord ko'rinishi |
| Jadvallar | `ChartController` | Boshqaruv paneli jadvallari uchun yig'ilgan vaqt-qator ma'lumotlarini xizmat qiladi |
| Davlat sotuvi | `CountrysaleController` | Har-davlat daromad maqsadlari uchun AJAX-CRUD |
| Server monitor | `ServerController` | Ro'yxatga olingan `sd-main` serverlarini va ularning oxirgi-ko'rinish holatini ro'yxatlaydi |
| Xizmat (boshqaruv paneli) | `ServiceController` | Admin UIda ko'rsatilgan xizmat-bildirishnoma fayllarini yuklash va boshqarish |
| Sozlamalar | `SettingController` | Admin-UI ilova sozlamalari (xususiyat flaglari, chegaralar, ko'rsatish opsiyalari) |
| Obuna ko'rinishi | `SubscripController` | Diler bo'yicha faol obunalarning faqat-o'qish boshqaruv paneli ko'rinishi |
| Tuzatish quti | `FixController` | Ad-hoc ma'lumotlar-tuzatish buyruqlari (chegirma berish, holat qayta o'rnatish, ommaviy tuzatishlar) |
| Qayta o'rnatish | `ResetController` | Diler-maxsus ma'lumotlarni yoki obuna holatini qayta o'rnatadi (faqat-admin buzg'unchi amallar) |
| Bildirishnoma | `NotificationController` | Ilova ichidagi bildirishnoma boshqaruvi uchun boshqaruv paneli ko'rinishi |

---

## partner · o'z-o'ziga xizmat ko'rsatish portali

Hamkorlar (`ROLE_PARTNER`) o'z dilerlarini va daromadlarini ko'rish uchun
bu yerda kiradi. Kirish `PartnerAccessService::checkAccess` orqali cheklangan
(hozirda kommentdan o'chirilgan — xavfsizlik landminalariga qarang).

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Hamkor ko'rinish hub | `ViewController` | Kirish nuqtasi; hamkor foydalanuvchilarni ruxsat berilgan ekranlariga yo'naltiradi |
| Hamkor dilerlari | `DealerController` | Hamkor-ko'lamli diler ro'yxati — faqat hamkorning o'z diler hisoblarini ko'rsatadi |
| Hamkor obunalar | `SubscriptionController` | Hamkor dilerlari uchun faqat-o'qish obuna holati |
| Hamkor to'lovlari | `PaymentController` | Hamkor to'lov tarixi — kiruvchi va chiquvchi |
| Hamkor hisoboti | `ReportController` | Hamkor uchun daromad va komissiya hisoboti |

---

## cashbox · kassa stollari va oqim

Oflayn kassa stollari, oqim turlari, stollar o'rtasidagi o'tkazmalar va
iste'mol yozuvlarini kuzatadi.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Cashbox ro'yxati | `CashboxController` | Kassa stoli yozuvlari uchun AJAX-CRUD (nomi, egasi foydalanuvchi, balansi) |
| Kassa stoli | `CashDeskController` | Bitta kassa stoli uchun batafsil ko'rinish va amallar |
| Oqim turi | `FlowTypeController` | Pul-oqim kategoriyalari ma'lumotnoma ro'yxati (daromad, xarajat, o'tkazma, …) |
| Kelish turi | `ComingTypeController` | Kiruvchi-to'lov manba turlari ma'lumotnoma ro'yxati |
| O'tkazma | `TransferController` | Stollar o'rtasidagi naqd o'tkazmalarni yozadi |
| Iste'mol | `ConsumptionController` | Naqd chiqib ketishlarni (iste'mol/xarajat yozuvlarini) yozadi |

---

## report · yig'ilgan hisobotlar

Sekinroq yig'iluvchi ekranlar, ko'pincha PHPExcel eksport bilan.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Faol mijozlar | `ActiveCustomersController` | Davr davomida davlat / valyuta bo'yicha faol dilerlar soni |
| Tutuvchilar | `CatchersController` | Sotuvchi bo'yicha yangi-diler sotib olish hisoboti |
| Churn | `ChurnController` | Sotuvchi yoki davlat bo'yicha oydan-oyga churn stavkasi |
| Mijoz hisoboti | `ClientReportController` | Har-mijoz (diler) foydalanish va to'lov xulosasi |
| Diler hisoboti | `DilerReportController` | Barcha dilerlar bo'ylab yig'ilgan hisobot |
| Fikr-mulohaza | `FeedbackController` | NPS / fikr-mulohaza yozuvlari uchun AJAX-CRUD |
| Asosiy hisob | `KeyAccountController` | Sotuvchi bo'yicha asosiy-hisob diler ishlashi |
| Asosiy hisob davri | `KeyAccountReriodController` | Maxsus davr bo'yicha asosiy-hisob hisoboti |
| P&L | `PLController` | Davr uchun foyda-zarar hisoboti |
| Pivot | `PivotController` | Billing metrikalarining ko'p-o'lchamli pivoti |
| Reja sotuvlari | `PlanSalesController` | Billing sotuv jamoasi uchun rejaga qarshi haqiqiy sotuvlar |
| So'rov hisoboti | `PollReportController` | Ilova ichidagi diler so'rovlari natijalari |
| Quest hisoboti | `QuestController` | Quest-metrika hisobot ko'rinishi (api/Quest ma'lumotlarini aks ettiradi) |
| Mintaqa | `RegionController` | Mintaqa bo'yicha diler va daromad taqsimoti |
| Umumiy hisobot | `ReportController` | Yuqori darajadagi hisobot landing / hub sahifasi |
| Daromad | `RevenueController` | Valyuta taqsimoti bilan davlat darajasidagi daromad jadvali |
| Statistika | `StatisticController` | Amal-asosli statistika — hozirda `potential-churn` endpointini ochadi |
| Telegram bot statistikasi | `TgBotController` | Billing Telegram bot uchun oylik foydalanish statistikasi |
| Ko'rinish hub | `ViewController` | Hisobot modul sahifalari uchun umumiy ko'rinish kirish nuqtasi |

---

## bonus · bonus va KPI tizimi

Choraklik xulosalar, KPI kuzatuv, mentor bonuslari va billing sotuv jamoasi
uchun rejaga qarshi haqiqiy.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Bonus 5-darja | `Bonus5Controller` | 5-darja sotuvchilar uchun Vue-asosli bonus hisoblash boshqaruv paneli |
| Bonus 6-darja | `Bonus6Controller` | 6-darja sotuvchilar uchun bonus hisoblash varianti |
| KPI | `KpiController` | Berilgan davr uchun sotuvchi bo'yicha Vue KPI ball ko'rinishi |
| KPI lider | `KpiLeaderController` | Sotuvchi KPI ballarining tartiblangan liderlar jadvali |
| Mentor | `MentorController` | Oylik mentor bonus hisoblash va ko'rib chiqish |
| Mentor KPI | `MentorKpiController` | Katta sotuvchilar uchun birlashtirilgan mentor + KPI hisoboti |
| Reja sotuvlari | `PlanSalesController` | Sotuvchi bo'yicha sotuv reja CRUD va taraqqiyot kuzatuvi |
| Choraklar | `QuartersController` | Bonus hisoblashda ishlatiladigan choraklik davr ta'riflari uchun AJAX-CRUD |
| Bonus hisoboti | `ReportController` | Barcha xodimlar bo'ylab yig'ilgan bonus to'lov xulosasi |
| Jamoa | `TeamController` | Bonus hisoblash uchun jamoa tarkibi va tayinlash |

---

## setting · ilova sozlamalari va ma'lumotnoma ma'lumotlari

Ilova konfiguratsiyasi va tizim ma'lumotnoma jadvallari.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Ko'rinish hub | `ViewController` | Sozlamalar moduli uchun kirish nuqtasi |
| Foydalanuvchi boshqaruvi | `UserController` | Admin foydalanuvchi CRUD — yaratish, faollashtirish, rollarni tayinlash |
| Tizim logi | `SystemLogController` | `d0_system_log` audit izi uchun filtrlangan ko'ruvchi |
| Tasniflash | `ClassificationController` | Diler tasniflash darajalari uchun CRUD |
| Shahar | `CityController` | Shahar yozuvlari uchun ma'lumotnoma CRUD |
| Davlat | `CountryController` | Davlat yozuvlari uchun ma'lumotnoma CRUD |
| Valyuta | `CurrencyController` | Qo'llab-quvvatlanadigan valyutalar uchun ma'lumotnoma CRUD |

---

## notification · ilova ichidagi bildirishnomalar

Ilova ichidagi bildirishnoma qo'ng'irog'i. Boshqaruv paneli foydalanuvchilariga
bildirishnomalar yaratish, ko'rish va yuborish uchun API va UI ni taqdim etadi.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Bildirishnoma API | `ApiController` | JSON amallar: bildirishnomalarni olish, yaratish, tahrirlash, yuborish, o'chirish |
| Bildirishnoma ko'rinishi | `ViewController` | Bildirishnoma kirish quti va hisoblash ekranlarini render qiladi |

---

## sms · SMS paketlari

Dilerlar sotib olishi mumkin bo'lgan SMS kredit paketlari; sotib olingan
paketlarni va mavjud SMS paket ta'riflarini kuzatadi.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Sotib olingan SMS paketlari | `BoughtController` | Dilerlar tomonidan sotib olingan SMS paketlarining admin ro'yxati |
| SMS paket katalogi | `PackageController` | SMS paket ta'riflari uchun CRUD (kredit soni, narx) |

---

## access · har-foydalanuvchi ruxsat to'ri

Billing foydalanuvchilari uchun bit-flag ruxsat to'rini (`CREATE=1, UPDATE=2,
SHOW=4, DELETE=8`) boshqaradi.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Foydalanuvchi kirishi | `UserController` | Har-foydalanuvchi amal ruxsatlarini ko'rish va tahrirlash |

---

## directory · ma'lumotnoma ma'lumotlar API

Boshqa modullar tomonidan qidiruv jadvallarini olish uchun ishlatiladigan
ichki JSON API (dilerlar, distribyutorlar, valyutalar, davlatlar, shaharlar, …).

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| Directory API | `ApiController` | `get-dealers`, `get-distributors`, `get-currencies`, `get-countries`, `get-cities` endpointlarini ochadi |

---

## dbservice · DB texnik xizmat utilitalar

Operatsion jamoa uchun ad-hoc diagnostika so'rovlari, ommaviy ma'lumotlar
tuzatishlari va migratsiya yordamchilari.

| Xususiyat | Kontroller | Stub qatori |
|-----------|------------|-------------|
| DB xizmati | `ServiceController` | Ro'yxatga olingan DB xizmat operatsiyalarini ishga tushirish uchun indeks + amal-ro'yxat ko'rinishi |

---

## Bu indeks qanday saqlanadi

Ish oqimi sahifasini yozganingizda yoki yangilaganingizda:

1. Ushbu katalogdagi stub qatorini xuddi shu qatordagi `[**Xususiyat**](./<slug>.md)`
   havolasi va bir qator xulosa bilan almashtiring.
2. Yangi sahifa sidebar da paydo bo'lishi uchun `sidebars.js` (*Xususiyat ish oqimlari* kategoriyasi) ni yangilang.
3. Sahifaga diagramma qo'shgan bo'lsangiz, `python3 scripts/render-diagram-gallery.py` ni qayta ishga tushiring.
