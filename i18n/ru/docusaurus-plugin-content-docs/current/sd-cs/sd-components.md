---
sidebar_position: 6
title: sd-components
---

# `sd-components` — общая UI-библиотека

`sd-components` (он же `sales-doctor-ui-components`) — это библиотека Vue + Vuetify
компонентов, разделяемая между sd-main, sd-cs и любым будущим SPA.

## Раскладка

```
sd-components/
├── README.md
├── libs/
└── src/
    ├── components/      Vue components
    ├── styles/          SCSS
    └── fonts/
```

## Конфигурация

`src/components/config.vuetify.js` конфигурирует инстанс Vuetify —
тему, дефолты, локаль.

## Использование из host-приложения

Библиотека потребляется как Git-submodule или локально слинкованный package.
Импортируйте отдельные компоненты:

```js
import { SdTable, SdFilterBar, SdModal } from 'sd-components';
```

Добавьте SCSS в главный entry хоста, чтобы получить шрифты и
override`ы Vuetify:

```scss
@import 'sd-components/src/styles/main.scss';
```

## Когда добавлять компонент сюда

- Он используется (или будет) в **более чем одном** host-приложении.
- Он только UI (presentation + лёгкий state); доменная логика остаётся в
  хосте.
- Его можно стилизовать через Vuetify props / theme без утечки
  стилей хоста.
