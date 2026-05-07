---
sidebar_position: 2
title: Getting started (frontend)
audience: New frontend engineers
summary: Frontend-specific local setup — what to install, how to run, where the JS/CSS actually comes from, how to force a refresh, and a smoke-test checklist for your first session.
topics: [frontend, onboarding, local-setup]
---

# Getting started (frontend)

This page is the frontend-specific companion to the general
[Local setup](../project/local-setup.md). Read that first; this page
fills in the parts a frontend engineer needs and the general page
glosses over (the answer to "Hot reload?" on that page is just
"no" — read on).

## Prerequisites you actually need

- **Docker Desktop** — runs the whole backend (web, MySQL, Redis).
  This is the only must-have for editing `protected/views/*.php`,
  `js/*.js`, `js_plugins/*`, `css/*`.
- **Node 18+** — only required if you'll touch:
  - the docs site (`sd-docs`) — `npm install && npm run start`
  - an Angular island (`ng-modules/gps`, `ng-modules/neakb`) —
    `npm install && npm run build`. See
    [ng-modules](./ng-modules.md).
- **A modern Chromium** — the dev workflow leans on DevTools.
  Firefox works, but team examples use Chrome.

You do **not** need a local PHP install. Everything PHP runs in the
container.

## Bring it up

```bash
git clone git@github.com:salesdoctor/sd-main.git
cd sd-main
cp protected/config/main_sample.php protected/config/main_local.php
docker compose up -d --build
```

The web app is at **http://localhost:8080** (per
[Local setup](../project/local-setup.md)). Log in with
`admin / admin`.

## Where the frontend code actually comes from

There is no frontend build pipeline (see
[Assets pipeline](./assets-pipeline.md)). Files are served as-is.
Mental model:

| You edit | Browser sees |
|----------|--------------|
| `protected/views/<ctl>/<action>.php` | Re-rendered on next request |
| `js/<file>.js`, `js_plugins/<...>.js` | Picked up on browser reload |
| `css/<file>.css` | Picked up on browser reload |
| `ng-modules/<feature>/src/...` | **Only after** `npm run build` re-emits `dist/` |
| Anything inside `assets/<hash>/` | Don't edit — auto-generated copies |

Yii's `CAssetManager` copies anything registered as an "asset bundle"
into `assets/<hash>/` and serves the hashed URL. When you edit a file
that ends up in such a bundle, the hash changes and the browser
fetches the new copy automatically.

For files registered directly with `clientScript->registerScriptFile`
(most of `js/`, `js_plugins/`), the URL is stable and the browser may
cache the old copy. Two defenses:

1. **DevTools → Network → Disable cache** while DevTools is open.
   This is the standard frontend dev workflow.
2. **Append a version query** in the view to force a hard refresh
   on a release:

   ```php
   Yii::app()->clientScript
     ->registerScriptFile('/js/orders.js?v=' . VERSION);
   ```

## Browser DevTools setup

- **Disable cache** (Network tab) — always on while you have DevTools
  open.
- **Preserve log** (Console + Network) — the app does some
  full-page-redirect flows where logs would otherwise be wiped.
- **Source maps** — there are none. Most files are unminified
  already; debug them as-is.

## Smoke-test checklist (first session)

Before you write any code, click through this. If anything breaks,
that's a setup problem, not your code.

- [ ] Log in as `admin / admin` at http://localhost:8080.
- [ ] Open one **list page** (e.g. orders) — confirm filters render
      and the table draws.
- [ ] Open one **form page** (create / edit) — confirm Chosen
      dropdowns and date pickers work.
- [ ] Open one **modal** flow — confirm fancybox modals open and
      close.
- [ ] Open the **GPS map** page (uses an `ng-modules/gps` Angular
      island) — confirm the map tiles load.
- [ ] Switch the locale (top bar) between RU and EN — confirm strings
      change.
- [ ] DevTools → Network — confirm no 404s on `js/`, `js_plugins/`,
      `css/`, or `assets/<hash>/` URLs.
- [ ] DevTools → Console — note any uncaught errors. Some legacy
      noise is expected; treat as the baseline you must not regress.

## Hot reload?

There isn't any. The general [Local setup](../project/local-setup.md)
page already calls this out. The frontend workflow is:

- Edit file in `protected/views/`, `js/`, or `css/`.
- Switch to the browser.
- **Hard refresh**: `Cmd-Shift-R` (mac) / `Ctrl-Shift-R` (win/linux).
- DevTools → Network must have **Disable cache** ticked or the hard
  refresh won't pick up `js_plugins/` changes consistently.

For Angular islands (`ng-modules/gps`, `ng-modules/neakb`), the
default flow today is build-then-refresh:

```bash
cd ng-modules/gps
npm run build
# then hard-refresh the browser
```

Live `ng serve` against the live Yii backend is theoretically
possible but is not documented today — see open questions below.

## Tail the runtime log

Most "the page is blank" or "the modal won't submit" failures are
**server-side errors** the frontend just shows blankly. Tail the log:

```bash
docker compose exec web tail -f protected/runtime/application.log
```

Per [Conventions](../project/conventions.md), keep this open in a
terminal whenever you're debugging an AJAX flow.

## Common gotchas

- **`assets/` filling disk** — periodically `rm -rf assets/<hash>`
  for stale published bundles.
- **Permissions on `runtime/` and `assets/`** — must be writable by
  `www-data` in the container; a host bind mount can clobber that.
- **PHP warnings flooding the log** — many files are PHP 7.3-era.
  Stay on 7.3 unless you know what you're doing.
- **Old caches in `protected/runtime/cache/`** — rare, but if a view
  partial seems frozen even after editing, clear that folder.

## Where to go next

1. [Conventions](./conventions.md) — file layout, naming, when to
   use jQuery vs Angular vs Yii.
2. [Adding a screen](./adding-a-screen.md) — the recipe for your
   first end-to-end change.
3. [Yii views](./yii-views.md), [JS plugins](./js-plugins.md),
   [ng-modules](./ng-modules.md), [Asset pipeline](./assets-pipeline.md)
   — reference detail.

## Open questions / TODO

These are unresolved at the time of writing — confirm with the team
and update this page once known:

- **Live `ng serve` against Yii** — is there a documented dev-loop
  that avoids the `npm run build` step on every change?
- **Console-error baseline** — is there a known list of acceptable
  legacy console errors, or should the baseline be empty?
- **`?v=` value source** — what global / constant should the version
  query reference today? `VERSION` is shown above as a placeholder;
  the real symbol may differ per repo.
