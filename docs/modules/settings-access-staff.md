---
sidebar_position: 18
title: settings / access / staff
audience: Backend engineers, QA, PM, Admins
summary: Three admin-side modules — settings (tenant prefs), access (RBAC UI), staff (internal employees).
topics: [settings, access, staff, rbac, admin, configuration]
---

# `settings`, `access`, `staff` modules

Admin-side platform configuration.

## Key features

### `settings`

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Number formats | Thousand separators, decimal places, currency symbols | 1 |
| Currencies | Supported currencies + exchange rates | 1 / Finance |
| Print templates | Invoice / waybill / order print layouts | 1 |
| Invoice templates | Per-tenant invoice formatting | 1 |
| Feature flags | Toggle experimental features per tenant | 1 |
| System log viewer | Browse runtime logs | 1 |

### `access`

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| Role assignment | Assign users to roles | 1 / 2 |
| Permission grid | Edit per-role permissions on operations | 1 |
| Filial visibility | Restrict users to a subset of filials | 1 / 2 |
| Cache bump | Force re-load of authitem hierarchy | 1 |

The role hierarchy itself lives in `protected/config/auth.php`.

### `staff`

| Feature | What it does | Owner role(s) |
|---------|--------------|---------------|
| User CRUD | Create / edit / deactivate internal employees | 1 / 2 |
| Role assignment | Assign internal staff to roles like manager, supervisor, expeditor | 1 / 2 |
| View user history | Audit trail per user | 1 |

`CreateController`, `EditController`, `DeleteController`,
`ListController`, `ViewController`.
