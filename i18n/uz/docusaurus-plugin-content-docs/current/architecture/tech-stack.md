---
sidebar_position: 2
title: Tech stack
---

# Tech stack

| Qatlam | Texnologiya | Versiya | Eslatmalar |
|-------|------------|---------|-------|
| Til | PHP | **7.3** | `Dockerfile` da pin qilingan |
| Framework | **Yii 1.x** | `framework/` ichida bundle qilingan | Gii dev tool ni o'z ichiga oladi |
| HTTP server | Nginx + php-fpm | latest | Repo ildizidagi `nginx.conf` |
| Ma'lumotlar bazasi | MySQL | **8.0** | InnoDB, `utf8` (eski standart) |
| Kesh + navbat | Redis | **7-alpine** | 3 mantiqiy DB (sessiyalar / navbat / kesh) |
| Frontend | jQuery 1.10 | – | Plus jQuery UI, Highcharts, fancybox |
| Frontend (zamonaviy) | Angular | `ng-modules/` ga ko'ra | `gps`, `neakb` da ishlatiladi |
| Frontend (boshqa) | Vue | – | `views/vue` ostida bir nechta izolyatsiyalangan view lar |
| Excel | PHPExcel | – | `protected/extensions/phpexcel` |
| Imaging | GD | – | php image ga o'rnatilgan |
| QR / shtrix-kod | `protected/extensions/qrcode` | – | Buyurtma yorliqlari |
| Auth | Yii `CDbAuthManager` (subclass qilingan) | – | RBAC roli 1–10 |
| Konteynerizatsiya | Docker / Docker Compose | – | `docker-compose.yml` |
| Lokallar | `ru` (default), `en`, `uz`, `tr`, `fa` | – | `protected/messages/` |
| Tashqi | Firebase FCM, Telegram Bot, SMS gateway, GPS providerlar | – | [Integratsiyalar](../integrations/overview.md) ga qarang |

## Nega 2026 da PHP 7.3

Eski Yii 1.x va PHP 8+ qattiq tiplashda buziladigan bir qator vendor
qilingan kutubxonalar tufayli pin qilingan. PHP 8 tuzatishlarini olib
keladigan Yii 1.1 fork i bilan PHP 8.2 ga yangilashga ochiq ADR taklif
mavjud — [ADR 0001](../adr/0001-yii1-stay.md) ga qarang.

## Nimani ishlatmaymiz (qasddan)

- Yii Active Record dan tashqari ORM.
- Ilova kodi uchun Composer (faqat `composer.json` / `vendor` uchinchi tomon
  bog'liqliklari uchun ishlatiladi; PSR-4 autoloader asosan Yii `import`
  yo'lidir).
- Boshidan oxirigacha SPA framework. Sahifalar server-rendered;
  "zamonaviy" widget lar — izolyatsiyalangan Angular yoki Vue islandlari.
- Frontend build pipeline. Asset lar `clientScript` tomonidan boshqariladigan
  `<script>` teglari orqali `js/` va `js_plugins/` dan yuklanadi.
