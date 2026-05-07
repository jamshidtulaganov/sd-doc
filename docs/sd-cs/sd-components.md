---
sidebar_position: 6
title: sd-components
---

# `sd-components` — shared UI library

`sd-components` (a.k.a. `sales-doctor-ui-components`) is a Vue + Vuetify
component library shared between sd-main, sd-cs, and any future SPA.

## Layout

```
sd-components/
├── README.md
├── libs/
└── src/
    ├── components/      Vue components
    ├── styles/          SCSS
    └── fonts/
```

## Configuration

`src/components/config.vuetify.js` configures the Vuetify instance —
theme, defaults, locale.

## Use it from a host app

The library is consumed as a Git-submodule or local linked package.
Import individual components:

```js
import { SdTable, SdFilterBar, SdModal } from 'sd-components';
```

Add the SCSS to your host's main entry to get fonts and Vuetify
overrides:

```scss
@import 'sd-components/src/styles/main.scss';
```

## When to add a component here

- It's used (or will be) in **more than one** host app.
- It's UI-only (presentation + light state); domain logic stays in the
  host.
- It can be styled via Vuetify props / theme without leaking host
  styles.
