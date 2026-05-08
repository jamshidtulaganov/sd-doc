---
sidebar_position: 6
title: sd-main xavfsizlik tuzoqlari
---

# sd-main xavfsizlik va operatsion tuzoqlari

Ushbu sahifa **sd-main** diler CRM uchun [sd-billing xavfsizlik tuzoqlari](../sd-billing/security-landmines.md) ni aks ettiradi. Elementlar 2026-05 hujjat auditidan topilgan, `/Users/jamshid/projects/salesdoctor/sd-main` dagi manba o'qishlariga asoslangan. Har bir qator jiddiylik darajasini, qayerdaligini va maqsadli tuzatishni ko'rsatadi.

| # | Muammo | Jiddiylik | Qayerda | Maqsadli tuzatish |
|---|--------|-----------|---------|-------------------|
| 1 | **MD5 parol hashlash — bcrypt fallback yo'q** | Critical | `protected/components/UserIdentity.php:26` (`md5($this->password) === $user->PASSWORD`); `protected/models/User.php:199, 208` (`md5($PASSWORD)` yozadi); `User.php:449` (validatsiya) | `password_hash()` (bcrypt) ga o'tish. Keyingi muvaffaqiyatli loginda shaffof yangilanish. `auth-and-roles.md` dagi "yangi foydalanuvchilar uchun bcrypt" faol degan oldingi da'vo noto'g'ri edi. |
| 2 | **Loyiha testlari nol** | High | `composer.json` da PHPUnit yo'q; faqat `*Test.php` fayllar `Gumlet\ImageResize` dan `protected/extensions/image2/test/` ostida vendor qilingan va hech narsaga ulanmagan | phpunit ni ko'taring; `OrderService` o'tishlari va har bir qator defekt / butun buyurtmani rad etish farqidan boshlang (qarang: `api/api-v3-mobile.md`). |
| 3 | **CI yo'q** | High | `.github/workflows/` yo'q, `.gitlab-ci.yml` yo'q, test-runner config yo'q | phpunit ni (#2) CI ga ulang. Mermaid diagrammalari uchun lint tekshiruvini qo'shing (sd-docs dagi `package.json` `lint:mermaid` ga qarang). |
| 4 | **Ilova healthcheck endpointi yo'q** | Medium | `protected/` ning hech qaerida `/healthz`, `actionHealth` yoki `actionPing` yo'nalishi yo'q. Oldingi deploy hujjatidagi `GET /healthz` ga murojaat qilgan smoke-test orzu edi. | DB-ping JSON bilan 200 qaytaradigan minimal `SiteController::actionHealthz` qo'shing. K8s/orchestrator probe lari uchun nginx allow-list ga qo'shing. |
| 5 | **Deploy avtomatlashtirish yo'q** | Medium | `deploy.sh` yo'q, `Makefile` yo'q, `infra/smoke.sh` yo'q, `.github/workflows/deploy*` yo'q | Haqiqiy rolloutni hujjatlashtiring (hozir `devops/deployment.md` da). Uni kodlaydigan `bin/deploy` skriptini qo'shing. |
| 6 | **Hujjatlardagi qattiq kodlangan dev kreditlari** | Low | `docs/project/local-setup.md` MySQL uchun `jamshid / secret` va phpMyAdmin uchun `root / root` ni jo'natadi | Neytral o'rinbosarga (`sd_dev / sd_dev`) o'ting va `.env.example` ga murojaat qiling. |
| 7 | **PHP 7.3 EOL** | High | `Dockerfile` PHP 7.3 ni pin qiladi (xavfsizlik patch lari Dek 2021 da to'xtagan) | PHP 8.2 ga compat-patched Yii 1.1 bilan yangilanish yo'li uchun [ADR 0001 — Yii 1 da qoling](../adr/yii1-stay.md) ga qarang. |

## Hisobot oqimi

Yangi muammoni topganingizda:

1. Loyiha trekerida ticket oching (`security` yorlig'i bilan).
2. Production da ekspluatatsiya qilinadigan bo'lsa, **P0** deb belgilang
   va tuzatishdan oldin xavfsizlik kanaliga xabar bering.
3. Tuzatishdan oldin regression testini qo'shing — lekin yuqoridagi #2
   ga qarang (avval PHPUnit ni ulashingiz kerak bo'lishi mumkin).
4. Status bilan ushbu jadvalga qator qo'shing (Open / In progress / Closed).

## Chuqur himoya (joriy holat)

Yuqoridagi elementlar ochiq bo'lganda, kompensatsion nazoratlar
xavfni kamaytiradi:

- Barcha sd-main endpointlari oldida WAF.
- Subdomen-izolyatsiyalangan sessiya hovuzlari (`redis_session` da
  `HTTP_HOST` prefiksi).
- Tenant bo'yicha DB izolyatsiyasi (mijoz boshiga DB, qarang:
  [Multi-tenancy](../architecture/multi-tenancy.md)).
- `api/billing/license` da IP allow-list (bugun bitta IP; sd-billing
  landmine #4 ga qarang).

## Qilmang

- ❌ Yangi MD5 parol ustunlari yoki yo'llari qo'shmang.
- ❌ `api/` yoki `api2/` ostida yangi endpointlar qo'shmang — ular
  muzlatilgan. `api3` (mobil) yoki `api4` (onlayn) dan foydalaning.
- ❌ Commit qilingan config fayllarda dev kreditlarini jo'natmang.
- ❌ #4 yopilmaguncha deploy/runbook hujjatlarida healthcheck
  endpointi mavjud deb da'vo qilmang.

## Shuningdek qarang

- [sd-billing xavfsizlik tuzoqlari](../sd-billing/security-landmines.md) —
  qarindosh loyihaning tuzoq sahifasi; ba'zi elementlar mos keladi.
- [security/auth-and-roles](./auth-and-roles.md) — joriy MD5 holati
  parol siyosati ostida hujjatlashtirilgan.
- [quality/testing](../quality/testing.md) — haqiqiy test holati (yo'q).
- [devops/deployment](../devops/deployment.md) — haqiqiy deploy holati (qo'lda).
