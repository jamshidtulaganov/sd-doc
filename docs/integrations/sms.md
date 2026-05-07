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
