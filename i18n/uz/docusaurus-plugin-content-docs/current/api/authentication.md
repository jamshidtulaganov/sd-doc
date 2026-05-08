---
sidebar_position: 2
title: Autentifikatsiya
---

# Autentifikatsiya

## Token asosida (api3, api4)

### Kirish

```http
POST /api3/login/index
Content-Type: application/x-www-form-urlencoded

login=agent1&password=plainPassword&deviceToken=fcm_or_apns_token
```

Muvaffaqiyatli javob:

```json
{
  "success": true,
  "agent_id": 42,
  "user_id": 17,
  "diler_id": "ACME",
  "fio": "Иванов И.И.",
  "role": 4,
  "phone_number": "+998901234567",
  "token": "..."
}
```

Muvaffaqiyatsizlik:

```json
{ "success": false, "error": "Неправильный логин или пароль" }
```

### Keyingi chaqiruvlarni avtorizatsiya qilish

Har bir so'rovda `token` ni (va ba'zi endpointlar uchun `deviceToken` ni)
form maydoni yoki `Authorization: Bearer ...` sarlavhasi sifatida uzating:

```http
POST /api3/order/create
Authorization: Bearer <token>
Content-Type: application/json

{ "client_id": "...", "lines": [...] }
```

Tokenlar **qurilma bo'yicha**: ikkinchi qurilmadan kirish, agar ko'p
qurilmali rejim ochiq yoqilmagan bo'lsa, birinchisini bekor qiladi.

## Litsenziya cheklovi

`User::hasSystemActive(int $systemId)` kirishda tekshiriladi. Namuna ID'lar:

| ID | Tizim |
|----|-------|
| 1 | Web admin |
| 2 | Audit |
| 4 | Mobil agent |
| 5 | Onlayn do'kon |

Agar litsenziya muddati o'tgan bo'lsa, kirish quyidagini qaytaradi:

```json
{ "success": false, "error": "Срок лицензии программы истёк" }
```

## Chiqish

```http
POST /api3/logout/index
Authorization: Bearer <token>
```

`{ "success": true }` qaytaradi. Server tomonida qurilma tokenini tozalaydi.
