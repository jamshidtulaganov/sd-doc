---
sidebar_position: 6
title: Supervisors screen — create and manage
audience: QA
---

# Supervisors screen — create and manage

## What this screen is for

The **Команда → Супервайзеры** screen lists every supervisor at the dealer and lets an admin / manager create new supervisors, edit them, or deactivate them. Supervisors are *web-only* people — they don't have a mobile app — so this screen is simpler than the Agents screen.

This page covers the screen itself. For what a supervisor *does* once they're logged in, see [Role — Supervisor](./role-supervisor.md).

## Who uses it and where they find it

| Role | What they do here | How they get to the screen |
|---|---|---|
| Admin (1) | Create / edit / deactivate any supervisor | Web → Команда → Супервайзеры |
| Manager (2) | Same | Same |
| Key-account (9) | Read; may create / edit within their country scope (depends on RBAC) | Same |
| Supervisor (8) themselves | Cannot manage other supervisors; cannot see this screen | — |

## The workflow — at a glance

```mermaid
sequenceDiagram
    autonumber
    participant U as Admin
    participant Form as Supervisor form
    participant DB as DB
    participant Link as Supervayzer table

    U->>Form: Open Supervisors → New
    U->>Form: Fill FIO, login, password
    U->>Form: Submit
    Form->>DB: Check 'fullname' present
    Form->>DB: Check 'login' present + unique + no spaces
    Form->>DB: Check 'password' present
    alt validation fails
        Form-->>U: Field error naming which check failed
    else
        Form->>DB: INSERT User (role=8, password hash)
        Note over Form,Link: ⚠ Agents are linked to the supervisor<br/>via the Supervayzer table — separate step<br/>after create. Verify the link exists.
        Form-->>U: Success — supervisor appears in the list
    end
    U->>Form: Edit agents under this supervisor
    Form->>Link: INSERT / DELETE Supervayzer rows<br/>(SV_AGENT_ID, AGENT_ID)
    Form-->>U: Saved
```

## Step by step — Create

1. The admin opens **Команда → Супервайзеры** and clicks **New supervisor**.
2. The admin fills in:
   - **FIO** (full name) — required.
   - **Login** — required, unique, no spaces.
   - **Password** — required.
   - **Active** — defaults to true.
3. The admin presses **Save**.
4. *The system validates* that FIO, login, password are present and that the login is not already used (the validations are simpler than agents — there's no subscription cap on supervisors). ⛔ Each missing or duplicate field returns a precise error code.
5. *The system creates the User row* with role 8.
6. *The form returns success.* The supervisor appears in the list.
7. The admin **separately** assigns agents to the new supervisor — see *Assigning agents* below.

## Step by step — Assigning agents to a supervisor

Supervisors only see what they're scoped to. The scoping is the `Supervayzer` table — each row links one supervisor User to one agent. There is no UI to bulk-assign on the supervisor's own page; the assignment happens either:

- On the **Agent's edit screen** (the supervisor dropdown), or
- On a dedicated **Sales team** screen (Торговая команда) — covered separately in this guide, where you can manage the whole team structure at once.

For QA tests, the workflow is:

1. Open one of the supervisor's would-be agents in the Agents screen.
2. Set the supervisor field to this supervisor.
3. Save the agent.
4. *A row is inserted in the `Supervayzer` table* linking the User (supervisor) and the Agent.
5. The supervisor, on next login, sees that agent in their team list and their orders / visits / KPI.

Re-assigning an agent to a different supervisor:

1. Open the agent in the Agents screen.
2. Change the supervisor.
3. Save.
4. *The old `Supervayzer` row is deactivated or replaced* (depending on dealer config — verify behaviour). The new supervisor sees the agent from now on; historical data remains attributed to whoever supervised at the time.

## Step by step — Edit

1. The admin clicks a supervisor in the list.
2. The edit dialog opens pre-filled.
3. The admin can change FIO, login, password, active flag.
4. The admin presses **Save**.
5. *The system runs the same validations* as create (presence, uniqueness, spaces).
6. *If password is filled*, it's updated. (Supervisors have no device tokens to clear — they're web-only.)
7. *The User row is updated.*

## Step by step — Deactivate

1. The admin clicks **Deactivate** on a supervisor.
2. The system asks for confirmation.
3. The admin confirms.
4. *The supervisor's User row gets `ACTIVE='N'`* and login is renamed to free up the username.
5. *Their `Supervayzer` links are deactivated* (the agents under them become unscoped or revert to admin-visibility only).
6. The supervisor cannot log into the web admin from this point.

## What can go wrong

| Trigger | Error | Plain-language meaning |
|---|---|---|
| Empty FIO | `ERROR_CODE_MISSING_REQUIRED_PARAM` for `fullname` | Required. |
| Empty login | `ERROR_CODE_MISSING_REQUIRED_PARAM` for `login` | Required. |
| Login with spaces | `ERROR_CODE_INVALID_PARAM` for `login` | No spaces allowed. |
| Empty password on create | `ERROR_CODE_MISSING_REQUIRED_PARAM` for `password` | Required. |
| Login already exists | Login conflict error | Another user has it. |

## Rules and limits

- **No subscription cap on supervisors.** Unlike agents, a dealer can have as many supervisors as they want.
- **No mobile app.** A supervisor's User has role 8, which the mobile app rejects at login. They are web-only.
- **One supervisor — many agents.** A supervisor can supervise any number of agents. An agent has *at most one* supervisor.
- **Deactivating a supervisor leaves their agents in place** but unscoped — they show up only for admin / manager / key-account, not for any supervisor's team list. Test plans must verify the orphaned-agent case.
- **The Supervayzer table is the source of truth for scoping** every screen the supervisor sees. If you see a leak (supervisor seeing an agent not on their team), investigate the table directly.

## What to test

### Happy paths

- Create a supervisor. Log in as the supervisor. Their team list is empty.
- Assign two agents to them on the Agents screen. Refresh as supervisor. Their team list shows two agents.
- Orders / visits / KPI of those two agents show up in the supervisor's views.
- Deactivate the supervisor. They cannot log in.

### Validation failures

- Empty FIO / login / password. Each should fail with the matching missing-param error.
- Login with spaces. Should fail.
- Duplicate login. Should fail.

### Scoping

- Two supervisors A and B, each with three agents. Log in as A. See A's three. Confirm B's three are **not visible** on any screen — team list, orders, visits, KPI, reports.
- Re-assign one of A's agents to B. As A, the team shrinks to two. As B, the team grows to four.
- Run a report for a date range spanning the re-assignment. Confirm the moved agent's historical data appears under whoever supervised at the *data's date*, not the current supervisor.
- Deactivate A. A's remaining agents become orphaned. Verify they're invisible to B. Verify admin can still see them.

### Side effects

- Creating a supervisor writes one User row, role 8.
- Assigning agents writes `Supervayzer` rows.
- Deactivation flips `ACTIVE='N'` on the User and on the linked Supervayzer rows.

## Where this leads next

- What the supervisor does after login: [Role — Supervisor](./role-supervisor.md).
- KPI targets the supervisor manages: [KPI setup and views](./kpi-setup-and-views.md).

## For developers

Developer reference: `protected/modules/staff/actions/supervisor/CreateSupervisorAction.php`, `EditSupervisorAction.php`, `DeleteSupervisorAction.php`. Scoping in `Supervayzer` model and `Agent::getAllAgentBySupervayzer()`.
