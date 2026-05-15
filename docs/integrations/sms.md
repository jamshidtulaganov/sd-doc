---
sidebar_position: 8
title: SMS gateway
---

# SMS gateway

Outbound SMS via the configured provider (Eskiz, Playmobile, etc.).

## Configuration

Per tenant, in **Settings → SMS → Providers**:

| Field | Notes |
|-------|-------|
| Provider | `eskiz`, `playmobile`, `custom` |
| API key / login | Provider creds |
| Sender ID | Approved alpha sender |
| Daily cap | Soft limit |

## Sending

Templates → `SmsTemplate`. Trigger event → `SendSmsJob` enqueued →
provider HTTP call → callback to `CallbackController` updates delivery
status.

## DLR (delivery receipt)

`POST /sms/callback/index` — provider posts here. Update
`SmsMessage.STATUS` to one of `pending / sent / delivered / failed`.

## Cost reporting

`SmsPackage` rolls up usage; surfaced in the SMS module list.

## Controller endpoints in sd-main

### `sms` module — admin UI + DLR webhook

Files under `protected/modules/sms/controllers/`:

| Controller | Action | Route | RBAC |
|-----------|--------|-------|------|
| `CallbackController` | `item` | `POST /sms/callback/item` | `noRbac` (provider DLR webhook) |
| `MessageController` | `list` | `GET /sms/message/list` | `operation.sms.list` |
| `MessageController` | `one` | `GET /sms/message/one` | `operation.sms.list` |
| `MessageController` | `send` | `POST /sms/message/send` | `operation.sms.list` |
| `MessageController` | `balance` | `GET /sms/message/balance` | `operation.sms.list` |
| `MessageController` | `checking` | `POST /sms/message/checking` | `operation.sms.list` |
| `PackageController` | `buying` | `POST /sms/package/buying` | `operation.sms.package.buying` |
| `TemplateController` | `list`, `create`, `delete`, `checking` | `/sms/template/...` | `operation.sms.template` |
| `ViewController` | `list`, `listDetail`, `templates`, `buyingPackage` | `/sms/view/...` | per-action `operation.sms.*` |

### `api/ScheduledSmsController` — scheduler

| Action | Route | RBAC |
|--------|-------|------|
| `send` | `POST /api/scheduledSms/send` | `noRbac` |

Used by the queue worker to fire scheduled SMS batches; not exposed to
end-users directly.

### Legacy / module-local SMS controllers

`doctor/SmsController` (10+ actions under `/doctor/sms/`) and
`clients/SendingSmsController` (`/clients/sendingSms/...`) ship
SMS-from-the-feature variants. They predate the unified `sms` module
and remain in use for legacy flows. New surfaces must use the `sms`
module above.

## See also

- [`sms` module](../modules/sms.md) — admin pages and provider config.
- [Jobs and scheduling](../architecture/jobs-and-scheduling.md) —
  `SendSmsJob` dispatch shape.
