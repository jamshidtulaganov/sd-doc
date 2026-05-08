---
sidebar_position: 18
title: settings / access / staff
audience: Backend engineers, QA, PM, Admins
summary: Uchta admin tomonidagi modul — settings (tenant afzalliklari), access (RBAC UI), staff (ichki xodimlar).
topics: [settings, access, staff, rbac, admin, configuration]
---

# `settings`, `access`, `staff` modullari

Admin tomonidagi platforma konfiguratsiyasi.

## Asosiy xususiyatlar

### `settings`

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Raqam formatlari | Mingliklar ajratuvchilari, kasr xonalari, valyuta belgilari | 1 |
| Valyutalar | Qo'llab-quvvatlanadigan valyutalar + ayirboshlash kurslari | 1 / Moliya |
| Bosma shablonlari | Invoys / yuk hujjati / buyurtma bosma maketlari | 1 |
| Invoys shablonlari | Tenant bo'yicha invoys formatlash | 1 |
| Feature flag'lari | Tenant bo'yicha eksperimental xususiyatlarni yoqish/o'chirish | 1 |
| Tizim log ko'rsatuvchi | Runtime loglarini ko'rib chiqish | 1 |

### `access`

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| Rol tayinlash | Foydalanuvchilarga rollarni tayinlash | 1 / 2 |
| Ruxsatlar gridi | Operatsiyalar bo'yicha rol-ruxsatlarni tahrirlash | 1 |
| Filial ko'rinishi | Foydalanuvchilarni filiallarning bir qismi bilan cheklash | 1 / 2 |
| Keshni yangilash | Authitem ierarxiyasini qayta-yuklashga majburlash | 1 |

Rol ierarxiyasining o'zi `protected/config/auth.php` da joylashgan.

### `staff`

| Xususiyat | Nima qiladi | Egasi rol(lar) |
|---------|--------------|---------------|
| User CRUD | Ichki xodimlarni yaratish / tahrirlash / o'chirish | 1 / 2 |
| Rol tayinlash | Ichki xodimlarni menejer, nazoratchi, ekspeditor kabi rollarga tayinlash | 1 / 2 |
| Foydalanuvchi tarixini ko'rish | Foydalanuvchi bo'yicha audit izi | 1 |

`CreateController`, `EditController`, `DeleteController`,
`ListController`, `ViewController`.

## Workflow'lar

> Eslatma: `access` va `staff` sub-modullari bir xil yon panel sahifasini ulashadi, lekin bu yerda qamrovdan tashqari (Faza 2). Bu bo'lim faqat `settings` modulini yoritadi.

> **Faza 1 qamrovi:** Bu Workflow'lar bo'limi narx-, parametr- va sozlamalar-konfiguratsiya oqimlarini hujjatlashtiradi. Sozlamalar moduli yana ~50 ta boshqa kontrollerlarga ham egalik qiladi (mahsulotlar, brendlar, kategoriyalar, birliklar, regionlar, valyutalar, integratsiyalar va h.k.) — ular Faza 2 ga kechiktirilgan va quyidagi kirish nuqtalarida sanalmagan.

### Kirish nuqtalari

| Trigger | Controller / Action / Job | Izohlar |
|---|---|---|
| Web (admin) | `PriceTypeController::actionIndex` | Narx turlarini ro'yxatlash / yaratish / yangilash; `operation.settings.priceType` bilan himoyalangan |
| Web (admin) | `PriceTypeController::actionCreateAjax` | Yangi `PriceType` yozuvini yaratish; `HAND_EDIT=1` bo'lganda `OldPriceType` shadow ham bootstrap qilinadi |
| Web (admin) | `PriceTypeController::actionUpdateAjax` | Mavjud `PriceType` ni yangilash; `FilialComponent::isOnlyFilial()` orqali filial-faqat himoya |
| Web (admin) | `PricesController::actionIndex` | Berilgan narx turi uchun mahsulot bo'yicha narx gridini render qilish |
| Web (admin) | `PricesController::actionSave` | Yagona mahsulot-narx paketini saqlash; `ProductPrice::savePrices` ni chaqiradi; `operation.settings.changePrice` bilan himoyalangan |
| Web (admin) | `PricesController::actionMultiSave` | Joriy filialga tayinlangan barcha diler narx turlari uchun narxlarni paket bilan saqlash |
| Web (admin) | `PricesController::actionSaveWithout` | HAND_EDIT bo'lmagan narx turida har bir element bo'yicha qo'lda narx override; `price` + `old_price` qatorlarini yozadi |
| Web (admin) | `PricesController::actionMarkup` | Kategoriya bo'ylab foiz yoki koeffitsient ustamasini hisoblash va qo'llash; `operation.settings.changePrice` bilan himoyalangan |
| Web (admin) | `PricesController::actionImportExcel` | Narxlarni paket bilan import qilish uchun Excel faylini yuklash (`Price::ImportExcel`) |
| Web (admin) | `CurrencyController::actionIndex` | Valyuta yozuvlarini ro'yxatlash / yaratish / yangilash |
| Web (admin) | `CurrencyController::actionUpdateAjax` | `Currency` yozuvini joyida yangilash |
| Web (admin) | `ParamsController::actionIndex` | Dinamik parametrlar konfiguratsiya UI ni render qilish |
| API (autentifikatsiyalangan) | `ApiController` → `SaveDynamicParamAction` | POST: dinamik parametrlarni `protected/config/params.json` ga tasdiqlash va saqlash; `main.php` ni `array_merge_recursive` → `array_replace_recursive` ga ham patch qiladi |
| API (autentifikatsiyalangan) | `ApiController` → `GetDynamicParamAction` | POST: joriy dinamik parametrlar + standart sxemani qaytaradi |
| API (autentifikatsiyalangan) | `ApiController` → `GetSubstatusesAction` | POST: joriy buyurtma sub-status konfiguratsiyasini qaytaradi |
| Web — substatus saqlash | `ApiController` → `SaveDynamicParamAction` (substatus tarmog'i) | Sub-status saqlash `SaveDynamicParamAction::run()` ichidagi tarmoq tomonidan boshqariladi (27–43 qatorlar) — alohida action sinfi yo'q |
| Web (admin) | `SettingsController::actionSaveSettings` | Foydalanuvchi bo'yicha datatable ustun/filtr afzalliklarini `tableControl` ga saqlaydi |
| Web (admin) | `SettingsController::actionSaveHeaderOrders` | Foydalanuvchi bo'yicha datatable ustun tartibini `tableControl` ga saqlaydi |
| Web (admin) | `SettingsController::actionTruncateCache` | `cache` jadvalini truncate qiladi va yo'naltiradi |

### Soha entitylari

```mermaid
erDiagram
    PriceType {
        string PRICE_TYPE_ID PK
        string NAME
        int TYPE
        int HAND_EDIT
        string DEALER_PRICE
        string CURRENCY
        string ACTIVE
        string OLD_PRICE_TYPE FK
    }
    OldPriceType {
        string OLD_PRICE_TYPE_ID PK
        string PRICE_TYPE_ID FK
        string NAME
        string CURRENCY
    }
    Price {
        string PRICE_ID PK
        string PRICE_TYPE_ID FK
        string PRODUCT_ID FK
        float PRICE
        string CURRENCY
        string ACTIVE
    }
    OldPrice {
        string OLD_PRICE_ID PK
        string OLD_PRICE_TYPE_ID FK
        string PRICE_TYPE_ID FK
        string PRODUCT_ID FK
        float PRICE
    }
    PriceTypeFilial {
        int id PK
        string PRICE_TYPE_ID FK
        int FILIAL_ID
    }
    Currency {
        string CURRENCY_ID PK
        string NAME
        string CODE
        string TITLE
        string ACTIVE
    }
    PriceType ||--o{ Price : "has many"
    PriceType ||--|| OldPriceType : "shadows as"
    OldPriceType ||--o{ OldPrice : "has many"
    Price }o--|| Currency : "denominated in"
    PriceType }o--o{ PriceTypeFilial : "scoped to filial"
```

### Workflow 1.1 — Narx turi va mahsulot bo'yicha narxni sozlash

Admin narx turini belgilaydi (masalan, "Chakana", "Diler"), so'ng o'sha tur ostidagi har bir mahsulot uchun sotish narxini belgilaydi. Saqlangan narxlar darhol buyurtma yaratish va mobil agent zaxira ko'rinishiga ko'rinadi.

```mermaid
sequenceDiagram
    participant Web
    participant PriceTypeController
    participant PricesController
    participant ProductPrice
    participant DB

    Web->>PriceTypeController: POST actionCreateAjax PriceType NAME TYPE HAND_EDIT
    PriceTypeController->>DB: INSERT price_type
    alt HAND_EDIT is truthy
        PriceTypeController->>DB: INSERT old_price_type shadow copy
        PriceTypeController->>DB: UPDATE price_type SET OLD_PRICE_TYPE
    end
    PriceTypeController-->>Web: json success id

    Web->>PricesController: POST actionSave price_type_id items
    PricesController->>PricesController: H::access operation.settings.changePrice
    PricesController->>ProductPrice: savePrices postData
    loop each product-price pair
        ProductPrice->>DB: UPSERT price price_type + product
        ProductPrice->>DB: UPSERT old_price old_price_type + product
    end
    ProductPrice-->>PricesController: ok true
    PricesController-->>Web: success

    Note over DB: price and old_price now readable by orders/api4/vs modules
```

### Workflow 1.2 — Paket ustama qayta hisoblash

Admin manba narx turiga foiz yoki koeffitsient ustamani qo'llaydi va hisoblangan narxlarni maqsadli narx turiga yozadi. Barcha ta'sir qilingan mahsulotlar tarixiy farq uchun ham `price` qatori, ham `old_price` snapshot oladi.

```mermaid
flowchart TD
    A[Web: POST PricesController::actionMarkup] --> B{H::access changePrice}
    B -- denied --> Z[fail 403]
    B -- allowed --> C[Load source PriceType realPriceType]
    C --> D{PriceType found?}
    D -- no --> Z2[fail: type not found]
    D -- yes --> E[Load target PriceType]
    E --> F{target found?}
    F -- no --> Z3[fail: real type not found]
    F -- yes --> G[Compute multiplication factor percent or coefficient]
    G --> H{multiplication gt 0?}
    H -- no --> Z4[fail: invalid factor]
    H -- yes --> I[PriceType::saveOldPriceType INSERT old_price_type snapshot]
    I --> J[SELECT prices from price WHERE PRICE_TYPE_ID = source]
    J --> K[loop: calculate rounded price via Distr round]
    K --> L[UPSERT price on target price_type]
    L --> M[Price::createOldPrice UPSERT old_price]
    M --> N{more products?}
    N -- yes --> K
    N -- no --> O[Snapshot remaining target prices]
    O --> P[commit transaction]
    P --> Q[success: count of updated prices]
```

### Workflow 1.3 — Dinamik parametrlar konfiguratsiyasi

Admin (yoki serverlar aro avtomatlashtirish) tasdiqlangan tenant-bo'ylab feature flag'lari va raqamli sozlamalarning JSON to'plamini `params.json` ga yozadi. Fayl yuklash vaqtida `Yii::app()->params` ga birlashtiriladi va hamma joyda `ServerSettings` yordamchi metodlari orqali iste'mol qilinadi.

```mermaid
sequenceDiagram
    participant Web
    participant ApiController
    participant SaveDynamicParamAction
    participant ParamStoreService
    participant FS as FileSystem
    participant ServerSettings

    Web->>ApiController: POST /settings/api/saveDynamicParam login password params
    ApiController->>SaveDynamicParamAction: run
    SaveDynamicParamAction->>SaveDynamicParamAction: ParamAuthService::auth login password
    alt auth failed
        SaveDynamicParamAction-->>Web: 403 Access denied
    end
    SaveDynamicParamAction->>ParamStoreService: save params
    ParamStoreService->>ParamStoreService: validate params against DEFAULT_PARAMS schema
    alt validation errors
        ParamStoreService-->>SaveDynamicParamAction: errors
        SaveDynamicParamAction-->>Web: invalid_params error
    end
    ParamStoreService->>FS: file_put_contents protected/config/params.json
    ParamStoreService->>FS: patch main.php array_merge_recursive to array_replace_recursive
    ParamStoreService-->>SaveDynamicParamAction: ok
    SaveDynamicParamAction-->>Web: success

    Note over FS,ServerSettings: On next request boot: params.php reads params.json into Yii::app()->params

    Web->>ServerSettings: ServerSettings::roundingDecimalsMoney
    ServerSettings->>ServerSettings: read Yii::app()->params roundingDecimalsMoney
    ServerSettings-->>Web: int precision

    Web->>ServerSettings: ServerSettings::hasAccessToDeleteOrders
    ServerSettings->>ServerSettings: read Yii::app()->params enableDeleteOrders
    ServerSettings-->>Web: bool
```

### Modullar aro tutash nuqtalari

- O'qiydi: `settings.PriceType` — `orders.CreateOrderController`, `orders.ImportOrderController`, `vs.CreateOrderController` tomonidan iste'mol qilinadi (buyurtma satri narxlash)
- O'qiydi: `settings.Price` — `api4.CreateVsReturnAction`, `api4.CreateReplaceAction`, `api4.CreateDefectAction`, `PriceService::getPrices` tomonidan iste'mol qilinadi (mobil agent zaxira narxini qidirish)
- O'qiydi: `settings.OldPrice` — `vs.CreateOrderController` (tarixiy narx farqi), `clients.FinansController` (yetkazib berishda qarz hisoblash) tomonidan iste'mol qilinadi
- O'qiydi: `settings.PriceType` + `settings.OldPriceType` — `orders.RecoveryOrderController` tomonidan iste'mol qilinadi (buyurtmani tiklash narxlash)
- O'qiydi: `settings.Currency` — `PricesController::actionConfig` (format bloki), `PriceTypeController::actionCreateAjax` (valyuta tayinlash) tomonidan iste'mol qilinadi
- O'qiydi: `settings.PriceTypeFilial` — `PricesController::actionMultiSave` tomonidan iste'mol qilinadi (narx turlarini joriy filialning diler turlariga filtrlash)
- Yozadi: `Yii::app()->params` (`params.json` orqali) — `models.Order` (`debtNewOrder` bayrog'i), `models.ServerSettings` (`roundingDecimalsMoney`, `visitDistance`, `enableDeleteOrders`, `hasNotAccessToEditPurchase` va h.k.), `components.Formatter` (ilova bo'ylab pul/miqdor yaxlitlash) tomonidan iste'mol qilinadi
- Yozadi: `upload/status_config.txt` — `ServerSettings::substatuses()` tomonidan iste'mol qilinadi (buyurtma ko'rinishlarida buyurtma sub-status yorliqlari)
- Yozadi: `tableControl` — `SettingsController::actionSaveSettings` / `actionSaveHeaderOrders` (foydalanuvchi bo'yicha datatable afzalliklari, barcha datatable sahifalari tomonidan qayta o'qiladi) tomonidan iste'mol qilinadi

### Tuzoqlar

- `PricesController::actionSaveWithout` faqat `HAND_EDIT = 0` narx turlarida ishlaydi; agar narx turi allaqachon qo'lda-tahrirlash rejimida bo'lsa, metod xato javobsiz jim ravishda hech narsa qilmaydi.
- `PricesController::actionMultiSave` `price_type_filial` ga xom SQL join orqali filial-ko'lamli diler narx turlariga filtrlaydi; agar `FilialComponent::isOnlyFilial()` false qaytarsa (super-admin konteksti), filtr o'tkazib yuboriladi va barcha narx turlari ishlanadi.
- `ParamStoreService::save` dinamik parametrlar statik konfiguratsiyadan ustun bo'lishi uchun `protected/config/main.php` ni o'rnida ham patch qiladi (`array_merge_recursive` ni `array_replace_recursive` ga almashtirib). Bu ilova konfiguratsiyasiga fayl tizimi mutatsiyasi bo'lib, runtime'da `main.php` ga yozish ruxsatini talab qiladi.
- `SaveDynamicParamAction` standart Yii sessiya autentifikatsiyasi ustida maxsus `ParamAuthService::auth` ma'lumotlar tekshiruvini ishlatadi; tizimga kirgan admin uchun ham yo'qolgan yoki noto'g'ri ma'lumot 403 ni qaytaradi.
- Sub-statuslar `upload/status_config.txt` da oddiy matnli JSON fayl sifatida saqlanadi (`protected/` dan tashqarida). Saqlashdan keyin `ServerSettings::$_substatuses` PHP `ReflectionClass` orqali tozalanadi, chunki statik kesh oddiy so'rov hayot davri tomonidan qayta tiklanmaydi.
- Buyurtmalardagi narx-tarix farqi uchun `OldPrice` / `OldPriceType` shadow jadvallari mavjud. Har bir paket ustama ishga tushishi avval `PriceType::saveOldPriceType()` ni chaqiradi; sikl o'rtasida tranzaksiya rollback bo'lganida ustamani o'tkazib yuborish yoki qisman-tugatish shadow'ni nomuvofiq holatda qoldirishi mumkin.
- `DEALER_PRICE = 1` bo'lgan `PriceType` qatorlari `api4` orqali mobil ilovaga uzatiladigan yagona qatorlar; diler bo'lmagan narx turlari dala agentlariga ko'rinmaydi.
