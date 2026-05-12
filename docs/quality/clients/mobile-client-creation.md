---
sidebar_position: 3
title: Mobile client creation
audience: QA
---

# Mobile client creation — agent adds a new outlet

## What this feature is for

A field agent finds a new shop on their route that isn't yet in the system. From their mobile app they can capture the outlet — name, category, contact, GPS coordinates, photos — and submit it. The dealer can choose to either accept it straight away as an active client, or **park it for verification** until a manager approves it.

## Who uses it and where they find it

| Role | Action | Path |
|---|---|---|
| Agent (4), Merchandiser (11) | Create on mobile, subject to packet gating | sd-agents app → Add outlet |
| Operator (3, 5, 9) | Web view of pending list; approve / reject | Web → Clients → Pending (Approval) |

## Two flavours, gated by the agent's packet

| Packet setting | Effect |
|---|---|
| `client.create = 1` | Agent's "Add outlet" button is enabled |
| `client.create = 0` | Button hidden — agent cannot create new outlets |
| `client.verify = 1` | New outlets go to `ClientPending` queue, **inactive** until a manager approves them |
| `client.verify = 0` | New outlets created directly in `Client` table, **active** immediately |

Both toggles are configured in the [agents-packet](../team/agents-packet.md). Test plans must run both configurations.

## The workflow

```mermaid
sequenceDiagram
    autonumber
    participant Ag as Agent on mobile
    participant App as sd-agents app
    participant API as Server (api3 / api4)
    participant DB as DB
    participant Mgr as Manager (web)

    Ag->>App: Tap Add outlet
    App->>App: Capture name, category, address, GPS, photos
    App->>API: Submit (with deviceToken)
    API->>API: Read agent's packet — client.verify?
    alt verify=1
        API->>DB: INSERT ClientPending (+ ClientPhoto rows)
        API-->>App: "Submitted for approval"
        Note over App,Mgr: Outlet does NOT appear on agent's route yet
        Mgr->>DB: Open Pending list; Approve
        DB->>DB: Copy to Client, link photos to new id
        DB->>DB: Insert Visiting from pending WEEK_DAYS
    else verify=0
        API->>DB: INSERT Client directly
        API-->>App: Saved (active, on route)
    end
```

## Step by step (verify=1 path)

1. Agent opens **Add outlet** on their phone.
2. App captures: name, category, region, city, contact, phone, address, GPS, optional photos.
3. *App submits.*
4. *Server reads the agent's packet*; if `client.verify=1`, inserts into **`ClientPending`** instead of `Client`.
5. **ClientPhotos** if any are attached with `CLIENT_ID = pending row id` (not the future Client id).
6. The agent sees *"submitted for approval"*. The outlet does NOT appear on their route yet.
7. A manager opens the web Approval list. Each pending row shows fields + photos + the creating agent.
8. The manager picks **Approve**.
9. *The system copies the pending fields into a fresh `Client` row*, with `CONFIRMED_BY` and `CONFIRMED_AT` stamped, `ACTIVE='Y'`.
10. *Photo rows are re-pointed* from the pending id to the new Client id.
11. *Visiting rows* are inserted from the pending row's `WEEK_DAYS` (comma-separated weekday list).
12. *The ClientPending row is deleted.*
13. On next sync, the agent sees the new outlet on their route.

If the manager picks **Reject**, the ClientPending row is deleted and any attached photo rows are orphaned (not auto-cleaned).

## Step by step (verify=0 path)

1. Agent submits.
2. *Server inserts directly into `Client` table with `ACTIVE='Y'`.*
3. *Visiting rows are created from the submitted WEEK_DAYS.*
4. On next sync the agent sees the outlet on their route — usually the same day.

## What can go wrong

| Trigger | What you see | Plain-language meaning |
|---|---|---|
| Packet has `client.create=0` | Button missing on mobile | Working as designed. |
| Agent submits but no GPS | Submission allowed, coordinates null | Most dealers want GPS — verify the packet's required-fields. |
| Same outlet submitted twice (agent re-submits) | Two pending rows created | No dedup at submit time. Manager will spot it in the queue. |
| Manager approves a pending row whose creating agent has been deactivated | Approval proceeds; the new client has CREATE_BY pointing at the deactivated agent | Audit confusion but not a functional bug. |
| Photo upload fails | Submission succeeds, photo missing | Photo upload is separate; test the photo retry. |
| Manager rejects a pending row | ClientPending row deleted; ClientPhoto rows orphaned | Filesystem cleanup is manual. |
| ClientPending row sits stale (manager never approves) | No timeout; the row sits forever | Test plans should call out stale-pending accumulation. |

## Rules and limits

- **`client.verify=1` blocks the outlet from appearing on the agent's route until approval.** Their next visit to that outlet has no system record until the manager acts.
- **`WEEK_DAYS` is comma-separated** on the pending row; expanded into one Visiting row per weekday on approval.
- **Photo re-pointing is by SQL UPDATE** — no transactional guarantee. If the update fails after Client INSERT, photos remain orphaned.
- **Rejecting a pending row does not auto-delete photos.** Operations should run a manual cleanup periodically.
- **Bulk approval / rejection** is supported — operator picks multiple pending rows in the queue.

## What to test

### `verify=1` flow

- Agent submits a new outlet. Verify ClientPending row appears in the manager's queue.
- Outlet does NOT appear on agent's route until approval.
- Manager approves. Verify (a) new Client row exists, (b) photos re-pointed, (c) Visiting rows inserted from WEEK_DAYS, (d) ClientPending row gone.
- Manager rejects. Verify pending row gone; photos orphaned (and document the filesystem hygiene gap).
- Bulk approve five pending rows in one save. All five become active.

### `verify=0` flow

- Submit with verify=0. Outlet appears in Client table immediately, active, on route on next sync.

### Packet gating

- Set `client.create=0`. Add-outlet button must disappear on next mobile sync.
- Toggle from 1 → 0 mid-day. Verify on next sync the button is gone.

### Edge cases

- Agent submits the same outlet name + address twice. Two pending rows. Manager spots them in the queue.
- Agent submits, then their account is deactivated before approval. The pending row still approves, but the CREATE_BY is a dead agent.
- ClientPending sits for 30 days. Verify it still approves cleanly (no implicit expiry).

## Where this leads next

- For the manager's approval screen, see [Verification](./verification.md).
- For the packet toggles, see [agents-packet](../team/agents-packet.md).

## For developers

Developer reference: `protected/modules/clients/controllers/ApprovalController.php`, `protected/models/ClientPending.php`.
