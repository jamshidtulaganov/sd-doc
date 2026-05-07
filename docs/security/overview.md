---
sidebar_position: 1
title: Security overview
---

# Security overview

| Concern | Treatment |
|---------|-----------|
| Authentication | DB-stored credentials, MD5 (legacy) — see notes |
| Sessions | Redis db0, `HTTP_HOST` keyPrefix |
| Authorisation | `DbAuthManager` over `authitem` + cached |
| Tenant isolation | Subdomain → DB; cache prefixed by tenant + filial |
| Transport | TLS at Nginx |
| Data at rest | MySQL + filesystem; back-ups encrypted |
| Secrets | `main_local.php` (not committed); 1C / Didox / Faktura.uz creds in tenant settings |
| Audit | `IntegrationLog`, `OrderStatusHistory`, `audit_*` tables |
| Rate limiting | Login throttling per-IP / per-user |

## Known weaknesses (be aware)

- **MD5 passwords** — historic; should be migrated to bcrypt over time.
  `LoginController` already supports both during a transition window.
- **Yii 1 CSRF** — enabled by default but several legacy POST endpoints
  bypass it. Audit before adding new ones.
- **PHP 7.3** — out of upstream security support. Compensate with WAF
  and frequent OS-level updates.

## Reporting a vulnerability

Email `security@salesdoc.io` with a description and reproduction. Please
don't open public GitHub issues for security bugs.

## Pages

- [Auth and roles](./auth-and-roles.md)
- [RBAC](./rbac.md)
- [Sessions](./sessions.md)
- [Data isolation](./data-isolation.md)
