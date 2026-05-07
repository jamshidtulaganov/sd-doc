---
sidebar_position: 18
title: settings / access / staff
---

# `settings`, `access`, `staff` modules

Admin-side platform configuration.

## `settings`

Tenant-wide preferences: number formats, default currencies, feature flags
(those not in `params.php`), printing templates, invoice templates.

## `access`

Web UI for the RBAC tables (`authitem`, `authitemchild`, `authassignment`)
+ filial visibility. The role hierarchy itself lives in
`protected/config/auth.php`.

## `staff`

Internal employees of the *tenant company* (not customers, not agents).
Used for assigning to roles like manager, supervisor, expeditor.

`CreateController`, `EditController`, `DeleteController`, `ListController`,
`ViewController`.
