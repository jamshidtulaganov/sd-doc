---
sidebar_position: 6
title: sd-components
---

# `sd-components` — umumiy UI kutubxona

`sd-components` (boshqa nomi `sales-doctor-ui-components`) — bu
sd-main, sd-cs va kelajakdagi har qanday SPA o'rtasida birgalikda
ishlatiladigan Vue + Vuetify komponent kutubxonasi.

## Joylashuv

```
sd-components/
├── README.md
├── libs/
└── src/
    ├── components/      Vue komponentlar
    ├── styles/          SCSS
    └── fonts/
```

## Konfiguratsiya

`src/components/config.vuetify.js` Vuetify instansini sozlaydi —
mavzu, defaultlar, locale.

## Host ilovadan foydalanish

Kutubxona Git submodul yoki lokal bog'langan paket sifatida
iste'mol qilinadi. Alohida komponentlarni import qiling:

```js
import { SdTable, SdFilterBar, SdModal } from 'sd-components';
```

Shriftlar va Vuetify override'larini olish uchun host'ning asosiy
kirish nuqtasiga SCSS'ni qo'shing:

```scss
@import 'sd-components/src/styles/main.scss';
```

## Bu yerga komponent qachon qo'shish kerak

- U **bir nechta** host ilovada ishlatiladi (yoki ishlatiladi).
- U faqat UI (taqdimot + yengil holat); domen mantig'i hostda qoladi.
- U Vuetify props / mavzu orqali host uslublarini sizdirmasdan
  uslublanishi mumkin.
