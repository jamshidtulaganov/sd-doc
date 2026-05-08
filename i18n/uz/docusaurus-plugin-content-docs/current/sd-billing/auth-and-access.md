---
sidebar_position: 7
title: Auth va kirish
---

# Auth va kirish (sd-billing)

:::note Ko'lam
Ushbu sahifa **sd-billing** dagi rollarni hujjatlashtiradi (obunalar/litsenziyalash loyihasi). Bu yerdagi raqamli rol IDlari sd-main niki bilan bir xil EMAS. sd-main RBAC uchun [security/auth-and-roles](../security/auth-and-roles.md) ga qarang. Ikki enum mustaqil — hech qachon loyihalar o'rtasida butun sonni o'zaro havola qilmang.
:::

Ikki qatlam kirish nazorati yonma-yon yashaydi:

## 1. Sessiya logini

`PhpAuthManager` + `WebUser` + `UserIdentity` — klassik Yii sessiya
auth. Parol saqlash **MD5(plaintext)** — ma'lum landminadir. [Xavfsizlik landminalari](./security-landmines.md) sahifasiga qarang.

## 2. Bit-flag kirish to'ri

`Access::has($operation, $type_access)` `d0_access_user`ga qarshi har-foydalanuvchi
ruxsatlarini bit flaglar bilan tekshiradi:

```
DELETE = 8
SHOW   = 4
UPDATE = 2
CREATE = 1
```

`Access::check()` o'tib ketganda `CHttpException(403)` tashlaydi. Ikki
qisqa-tutashuv:

- `User.IS_ADMIN = 1` — barcha tekshiruvlarni chetlab o'tadi.
- `User.ROLE = ROLE_ADMIN (3)` — barcha tekshiruvlarni chetlab o'tadi.

## Rollar

`User::ROLE_*` konstantalari sifatida aniqlangan:

| ID | Nom |
|----|------|
| 3 | `ADMIN` |
| 4 | `MANAGER` |
| 5 | `OPERATOR` |
| 6 | `API` |
| 7 | `SALE` |
| 8 | `MENTOR` |
| 9 | `KEY_ACCOUNT` |
| 10 | `PARTNER` |

## Hamkor cheklovlari

`PartnerAccessService::checkAccess` `ROLE_PARTNER`ni quyidagilar bilan cheklaydi:

- `partner` moduli
- `directory` moduli
- `dashboard/dashboard/index`
- `site/*`

Tekshiruv hozirda `protected/components/Controller.php:63` da **kommentdan o'chirilgan** —
ya'ni o'sha qator izohdan chiqarilmaguncha hamkorlar kerak bo'lganidan ko'proq narsaga
yetib borishi mumkin. Yuqori ustuvorlikdagi xavfsizlik elementi sifatida ko'ring.

## API autentifikatsiya

API endpointlari aralash sxemalardan foydalanadi:

| Kontroller | Auth |
|------------|------|
| `LicenseController` | Faylda qattiq kodlangan `TOKEN` konstantasi |
| `ClickController` | Click uslubidagi sign tekshiruvi |
| `PaymeController` | Payme HMAC sarlavhasi |
| `PaynetController` | `paynetuz` kengaytmasidagi SOAP / WS-Security |
| Boshqa bir nechta | `new UserIdentity("sd","sd")` — qattiq foydalanuvchi logini |

Qattiq kodlangan tokenlarni atrof-muhit o'zgaruvchilariga ko'chiring va
nashrdan keyin almashtiring.

## Sessiyalar

Yii standart `CHttpSession` (fayl asosida). Agar bu ilovani gorizontal
masshtablashtirsangiz, DB- yoki Redis-asosli sessiyaga o'tishni o'ylang.

## Chiqish

`SiteController::actionLogout` sessiyani yo'q qiladi. Bu yerda qurilma-token
tushunchasi yo'q — sd-billing faqat veb-admin.

## Rate limiting

Amalga oshirilmagan. Login throttling va IP-asosli limitlar tavsiya etiladigan
qattiqlashtirishlar — hozirda oldinda turgan WAFga tayanadi.
