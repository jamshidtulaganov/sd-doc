---
sidebar_position: 5
title: RBAC and users
audience: QA
---

# RBAC and users — accounts, roles, permissions, licence cap

## What this feature is for

This is the access-control hub. Every other screen in the system reads from here to answer two questions:

1. *Who is this person?* — the user record, their role, their login, their password hash.
2. *What may they do?* — the per-task permission grid that overrides role defaults.

On top of that, the user-creation screen enforces the paid **licence cap**: each dealer has a maximum number of active agents / supervisors / sellers / van-sellers / merchandisers, and the form blocks the create when the cap is reached.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Admin (1), Operator (3) | Full create / edit / deactivate / change password for any user | Web → Settings → Users |
| Manager (2), Key-account (9) | Create / edit users at or below their level | Same |
| Supervisor (8) | Read-only for their team | Same |
| Any user | Change own login + password from the profile screen | Web → Profile |
| Agent (4), Cashier (6), Expeditor (10), Merchandiser (11), Stockman (20) | No access to the catalogue | — |

## The workflow

```mermaid
sequenceDiagram
    autonumber
    participant U as Admin
    participant Form as User form
    participant Lic as Licence check
    participant DB as User table
    participant RBAC as Permission grid
    participant Cash as Cashbox catalogue

    U->>Form: Open Users → New
    U->>Form: Fill name, login, password, role, optional cashboxes
    Note over Form: Login must be free of spaces;<br/>password must be set;<br/>role must be picked.
    Form->>DB: Login unique?
    alt taken
        Form-->>U: "Этот логин уже занят"
    else free
        Form->>DB: Phone unique?
        alt taken
            Form-->>U: "Этот телефон уже есть в базе"
        else free
            Form->>Lic: Active count of this role +1 ≤ cap?
            Note over Form,Lic: QA-relevant: the cap is enforced per role-type<br/>(admin, agent, supervisor, merchant, dastavchik,<br/>vansel, seller, bot_order, bot_report).
            alt cap exceeded
                Form-->>U: License-blocked error
            else within cap
                Form->>DB: INSERT user (role, active, password hash)
                Form->>RBAC: Apply default role grants
                opt role = cashier
                    Form->>Cash: Bind selected cashboxes to this user
                end
                Form-->>U: Success
            end
        end
    end
```

## Step by step

1. The admin opens **Settings → Users**. *The system splits the list into active and inactive groups, filterable by role.*
2. On **New**, the admin fills the form. *The system rejects a login that contains a space, a missing role, and a missing password.*
3. *The system checks login uniqueness across all users and phone uniqueness across all users.*
4. *The system checks the licence cap by counting active users in this role-family.* The cap comes from the licence file shown on **Settings → Licence**.
5. On save, *the system stores the password (md5 of the supplied value), stamps create-by / create-at, and applies default per-role grants in the permission grid.*
6. If the new user is a cashier (role 6), *the cashbox multi-select on the form rebinds the selected cashboxes to this user* — see [Cashbox management](./cashbox-management.md).
7. If the new user is a manager (role 9), *the system also creates a default filial-structure row for them* so they are visible in the supervisor / manager hierarchy.
8. To **edit**, the admin opens the row. The same uniqueness probes run on save. *Toggling the active flag from `Y` to `N` does not delete the user — it just hides them from new screens.*
9. To **change own password**, any user opens the profile screen. *The system rejects weak passwords from a shortlist (`123456`, `password`, `qwerty`, `111111`, `123123`) and any password shorter than 6 characters; it rejects a wrong old password; it rejects a confirmation that does not match.*
10. *On demo servers, the password-change endpoint refuses every change to prevent demo-account abuse.*

## What can go wrong (errors the user sees)

| Trigger | What the user sees | Plain-language meaning |
|---|---|---|
| Login contains a space | "У этого логин есть пробелы" | Spaces are not allowed in login. |
| Login already used by another user | "Этот логин уже занят" | Logins are globally unique. |
| Phone already used by another user | "Этот телефон уже есть в базе" | Phone is unique across the dealer. |
| Role left blank | "Роль не установлен" | Role is required on create. |
| Password left blank on create | "Пароль не установлен" | Password is required on create. |
| Licence cap reached for that role | A licence-error banner; the create button blocks the save | The dealer needs to upgrade their licence or deactivate someone first. |
| Editing the special country-sales user | "Вы не можете изменить этого пользователя" | This account is system-managed. |
| Demo server, any password change | "Невозможно поменять пароль" / "Вы не можете изменить логин или пароль демо сервера" | Demo lockdown. |
| Weak password | "Пароль слишком простой или короче 6 символов" | The shortlist + length 6 check. |
| New password and confirmation differ | "Новый пароль и подтверждение не совпадают" | Both fields must match. |
| Old password wrong | "Неверный старый пароль" | Mismatch with the stored hash. |
| User deletes their own account through the admin route | The user logs out, the row hard-deletes, related cache rows refresh | Cascade is intentional. |

## Rules and limits

- **Login is globally unique** across the dealer. Phone is unique too.
- **Password storage is md5-hash** at this version. Changing the password also clears the mobile device token on the user, forcing the next mobile login to re-pair the device.
- **Demo lockdown** forbids password and login changes when the server's `Demo` parameter is true.
- **Weak-password block list:** `123456`, `password`, `qwerty`, `111111`, `123123`. Plus minimum length 6.
- **Licence cap is per role-family** and is read out of the licence file. The "Licence" admin screen shows the current and limit for each: admin, agent, supervisor, merchant, expeditor (dastavchik), van-seller, seller, bot-order, bot-report.
- **The "pay" flag on a user** marks whether they consume a licence seat. On supervisor (role 8) and expeditor (role 10), it can be toggled per user from the licence admin endpoint.
- **Toggling active from `Y` to `N`** hides the user from new screens, frees the licence seat, and stops new logins. Historical references survive.
- **Hard delete** is exposed (the delete-user endpoint) and also frees the seat. Cache rows are refreshed afterwards.
- **Cashier (role 6) rebinding.** When the admin edits a user and the user is a cashier, the cashbox multi-select on the user form is the source of truth — every previously bound cashbox is cleared, then the picked rows are rebound.
- **Manager (role 9) auto-structure.** Saving role 9 also creates a structure-filial row for the manager when the dealer is multi-filial.

## What to test

**Happy paths**
- Create an operator (role 3), an agent (role 4), a cashier (role 6) and a manager (role 9). Verify each appears in the active list and can log in.
- Edit one of them — change name, change role, change phone. Verify uniqueness checks fire on the new phone if you collide with another user.
- Deactivate one of them — verify they cannot log in any more, and the seat is freed on the licence screen.
- From a non-admin profile screen, change own password. Verify the next mobile login requires the new credentials.

**Validation**
- Login with a space → form error.
- Empty password on create → form error.
- Empty role on create → form error.
- Login collision → form error.
- Phone collision → form error.
- Weak password on profile → "пароль слишком простой" error.
- Wrong old password on profile → "неверный старый пароль" error.

**Role gating**
- Admin / operator can open the catalogue; agent / cashier / expeditor cannot.
- Supervisor can read but cannot save edits.
- The "country-sales-user" pseudo-account refuses any edit even from admin.

**Cross-module impact** (most important for users / RBAC)
- Switch a user from cashier to operator: on save, every cashbox row that referenced them as cashier should have its cashier slot cleared. Verify on the [Cashbox management](./cashbox-management.md) page.
- Switch a user from agent (role 4) to non-agent: the linked agent record (if any) should have its name and phone synced from the user record; verify the agent's mobile login still works with the new credentials.
- Switch an expeditor (role 10): the linked expeditor record gets the same name / phone / active sync.
- Promote a user to manager (role 9): in a multi-filial install, a new filial-structure row should appear automatically. The manager should then be visible in the supervisor / manager hierarchy.
- Demote a user: verify they lose the per-task grants they inherited and gain the new role's grants. Test by opening a screen that needs the old role.
- Cap edge: bring active agent count to one below the cap, then create one more — it should succeed; create another — it should fail.

**Side effects**
- Hard-delete a user: cache rows touching `UserModel` are invalidated; verify that the user's name no longer appears on any picker after a hard refresh.
- A user with the cashbox-access override is treated as having access to every cashbox; pair this test with [Cashbox management](./cashbox-management.md).
- After deactivating a user, log in as them from mobile and verify the app rejects the login.

## Where this leads next

- For cashier-to-cashbox binding, see [Cashbox management](./cashbox-management.md).
- For the agent-record sync, see [Create / edit agent](../team/create-edit-agent.md).
- For expeditor sync, see [Create / edit expeditor](../team/create-edit-expeditor.md).
- For supervisor sync, see [Create / edit supervisor](../team/create-edit-supervisor.md).
- For the licence file itself, see the licence-admin screen referenced in the Settings sidebar.

## For developers

Developer reference: `protected/modules/settings/controllers/UserController.php`, `protected/modules/settings/controllers/LicenseController.php`, `protected/modules/settings/actions/ManageUserLicenseAction.php`, `protected/modules/settings/actions/GetLicenseAction.php`, `protected/modules/settings/actions/GetPermissionAction.php`, `protected/modules/access/models/Access.php`, `protected/models/User.php`.
