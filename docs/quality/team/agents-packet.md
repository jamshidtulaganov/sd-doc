---
sidebar_position: 8
title: agents-packet — mobile-app config bundle
audience: QA
---

# agents-packet — the configuration bundle pushed to the sd-agents mobile app

## What this feature is for

The **agents-packet** is the bundle of configuration the dealer pushes from the web admin down to every agent's mobile phone. It controls almost everything about how the sd-agents app behaves: which products the agent can sell, which prices they can quote, whether GPS is required at every check-in, the order of clients on their route, what photo evidence to demand at a visit, what time of day the app should refuse to take new orders, whether the agent can apply a discount, and many more switches.

Internally the model is named **`AgentPaket`** (Russian-flavoured spelling kept for historical reasons), and the main payload is a JSON blob stored in its **`SETTINGS`** column. The blob is large — up to 100 KB per agent — and is read by the mobile app on every login and config refresh.

**Why QA should care more about this than any other feature in the Team module:**

- It controls behaviour on the mobile app that is invisible from the web admin until you sync the phone.
- It has three scopes: **company-wide**, **per-agent**, **per-group** — and they interact.
- It has a notorious **read-modify-write hazard**: simultaneous edits by two admins can silently destroy each other's changes.
- It has no version field or ETag; the mobile app re-reads the full blob every time, and the admin has no way to confirm what the phone currently has.

Treat this as the highest-value test surface in the module.

## Who uses it and where they find it

| Role | Action | How they get to the screen |
|---|---|---|
| Admin (1) | Read / edit company-wide and per-agent settings | Web → Settings or Команда → Агенты → Settings tab |
| Manager (2) | Same (depending on RBAC) | Same |
| Key-account (9) | Edit per-agent settings within scope | Same |
| Operations (5) | Often read-only | Same |
| Supervisor (8), Agent (4), Expeditor (10) | No access to the packet editor | — |
| Agent themselves | Implicitly read it every time the mobile app calls config-fetch | Mobile app (transparent to user) |

The web action is gated by `operation.agents.paket`.

## The three scopes

The packet lives in three places at once. The app sees the **merged** result.

| Scope | Where stored | When edited | What it covers |
|---|---|---|---|
| **Company-wide** | `/upload/company_config.txt` on the server's filesystem | Admin saves *"as company"* | Defaults for every agent at this dealer |
| **Per-agent** | `AgentPaket.SETTINGS` JSON for one agent | Admin opens an agent and saves *"by agent"* | Overrides for one specific agent |
| **Per-group** | `AgentPaket.SETTINGS` JSON for multiple agents at once | Admin picks a list of agents and saves *"by group"* | Bulk override — applied to every agent in the list |

When the mobile app asks for its config, the server returns the agent's own SETTINGS if present; otherwise the company defaults. There is **no automatic merging field-by-field** — saving a packet at the per-agent level replaces the entire JSON. This is the source of the read-modify-write hazard.

## What's in the SETTINGS JSON, in plain language

The blob is grouped into **categories**. Each category contains many individual toggles. Don't memorise these — instead, when QA hits a UI quirk on the mobile app, search this list for the toggle whose name matches.

| Category | What it controls |
|---|---|
| `client` | Can the agent edit / create / verify clients; can they see balance; do they have to photograph; what phone prefix to default to |
| `clientUpdateFields` | Which client fields the agent is allowed to change |
| `clientRequiredFields` | Which client fields are mandatory before saving |
| `gps` | Whether GPS is required; minimum accuracy; battery threshold; tracking intervals; distance thresholds for "out of zone" |
| `outlet` | Whether to show outlet plan numbers; which version |
| `showEmptyProduct` | Whether to hide products that are out of stock; consignment mode; required comment per line; manual price types; allowed time windows for taking orders |
| `photo` | Image dimensions and compression; categories that require a photo; whether trade-equipment photos are mandatory |
| `order` | Visit start/end times; location checks; photo/remainder/return requirements; minimum order amount; **`follow_sequence`** (must visit clients in route order); discount caps; return rules; expiry-date checks |
| `audit` | Which audit checkboxes appear in the visit screen — SKU, facing, poll, price, motivation, stock, sales |
| `sync` | When mandatory sync runs; allowed time windows; sync ban times; required order count |
| `agent` | Payment-related toggles: can collect cash, which currency, required-payment, cashbox-balance check |
| `vanselling` | Van-selling-specific switches: payment currency, required-payment, defect-delivery rules, cashbox-balance check |
| `visiting` | Which operations *count* as a visit (just photo? new order? rejection? old payment? etc.), visit radius |
| `visit_rules` | Filters for which clients these rules apply to: by city, category, type, channel, class |

A separate set of columns on `AgentPaket` is **not** in the JSON blob:

| Column | What it does |
|---|---|
| `PRODUCT_ID` | Comma-separated list of product IDs this agent is allowed to sell |
| `PRICE_TYPE` | Comma-separated list of price types they may quote |
| `VS_PRICE_TYPE` | Comma-separated list of van-selling price types |

These are managed by the **Product distribution** screen — see [product-distribution](./product-distribution.md).

## The workflow — at a glance

```mermaid
sequenceDiagram
    autonumber
    participant U as Admin
    participant Form as Settings UI
    participant Server as Server
    participant Agent as Agent's AgentPaket
    participant Comp as company_config.txt
    participant Phone as Mobile app

    U->>Form: Open settings; pick scope (company / agent / group)
    U->>Form: Toggle some setting
    U->>Form: Save
    Form->>Server: POST EditAgentConfig with scope + full blob
    alt scope = company
        Server->>Comp: Overwrite company_config.txt
    else scope = by-agent
        Server->>Agent: Replace AgentPaket.SETTINGS for one agent
        Note over Server,Agent: ⚠ Full-blob replace.<br/>Two admins editing different keys<br/>at the same time can clobber each other.
    else scope = by-group
        loop each selected agent
            Server->>Agent: Replace AgentPaket.SETTINGS for that agent
        end
    end
    Server-->>U: Saved

    Note over Phone: Phone has whatever it last fetched.<br/>It does NOT push-receive changes.
    Phone->>Server: On next login or manual sync — fetch config
    Server->>Server: Merge company defaults + agent override
    Server-->>Phone: Full JSON
    Phone->>Phone: Apply new toggles to the UI
```

## Step by step — Editing settings as the admin

1. The admin opens the settings screen for the packet (varies by dealer's UI version — typically Команда → Агенты → click the agent → Settings tab, or a dedicated Settings page for the company-wide variant).
2. The admin picks a scope: **company**, **by-agent**, or **by-group**.
3. The admin toggles or enters values for one or more settings.
4. The admin presses **Save**.
5. *The server validates each field* against its type (checkbox, text, select, integer, timepicker). ⛔ A bad value (e.g. negative integer where positive is required) is rejected with the offending field's name.
6. **If scope = company**, *the server writes the full JSON to `/upload/company_config.txt`*.
7. **If scope = by-agent**, *the server replaces `AgentPaket.SETTINGS` for the chosen agent.*
8. **If scope = by-group**, *the server loops over every agent in the list and replaces each one's `AgentPaket.SETTINGS`*. Errors on one agent do not stop the others.
9. *The server returns success.* No mobile push happens here — the mobile app will see changes on next sync.

## Step by step — Mobile app reads the packet

1. Agent logs in or triggers a sync.
2. The mobile app calls `api3/config/index` (for agents) or `api4/config/expeditor` (for expeditors).
3. *The server loads the agent's `AgentPaket` by `AGENT_ID`.* If none exists (a freshly-created agent who has never been edited), it falls back to the company-wide config.
4. *The server flattens the JSON* for the mobile app — checkbox values become booleans, comma-strings become arrays, timepicker becomes "HH:mm".
5. *The mobile app stores the new config locally* and applies it.

There is **no ETag / version field**: every config-fetch returns the full payload. The mobile app does not know if anything changed since last sync.

## Conflict landmine — the read-modify-write hazard

Two admins, working at the same time on the same agent's packet:

- Admin A opens the agent's settings, changes `order.follow_sequence` from off to on, saves.
- Admin B (who opened the same agent's settings *before* A saved) changes `gps.accuracy_required` from 50m to 20m, saves.

After both saves, A's `follow_sequence` change is **gone**. The reason: B's save wrote the *entire* JSON blob, which B had loaded before A's change took effect.

This affects:

- The admin Settings UI (the most common landmine).
- The mobile app's path that updates `order.follow_sequence` via the route-ordering screen — this is also a full-blob write (verified by reading the code).
- Bulk-edit (by-group) — each agent in the group is full-blob-replaced one after another.

**QA must test for this explicitly** — the existing automated tests don't catch it. Test plan: open two browser windows logged in as different admins; have them edit different keys on the same agent; save in sequence; verify which change survives.

## What can go wrong

| Trigger | What you see | Plain-language meaning |
|---|---|---|
| Field-level validation fails | Error naming the field | E.g. negative integer where positive required. |
| Two admins clobber each other | First admin's change disappears silently | The read-modify-write landmine. No error is shown. |
| Mobile app doesn't reflect a change | Phone still behaves the old way | The agent didn't sync after the admin's save. Force a logout / login. |
| Company-level file `/upload/company_config.txt` missing or unreadable | Mobile app gets only the agent's overrides, missing defaults | Filesystem error on the server. |
| Newly-created agent has no AgentPaket row | Mobile app uses pure company defaults | This is the **expected** behaviour for first-time agents. |
| Permission denied on save | `operation.agents.paket` is not granted to the role | RBAC issue. |

## Rules and limits

- **The packet has no version field.** The mobile app never asks *"has anything changed?"* — it always fetches the full payload.
- **Mobile receives the merged view** (agent override on top of company defaults). The admin saves only one half of that merge at a time.
- **Per-agent settings are full-blob replace**, not field-level upsert. Lose this fact and you lose data.
- **A new agent with no overrides reads company defaults** — saving an empty agent settings *creates* an override, even if no toggle changed.
- **Free-trial dealers see the same packet behaviour** as paid dealers — there are no license-time gates on packet content.
- **The `PRODUCT_ID`, `PRICE_TYPE`, `VS_PRICE_TYPE` columns** are managed separately by [Product distribution](./product-distribution.md), not by this settings editor.

## What to test

### Happy paths (per scope)

- Change a company-level toggle. Confirm `/upload/company_config.txt` is updated. Confirm an agent who has no per-agent override picks up the new value on next sync.
- Open one agent's settings. Change one toggle. Save. Mobile app picks it up next sync.
- Pick a group of three agents. Bulk-set the same toggle to a new value. Sync each agent's phone — all three reflect.

### Conflict landmine

- Two admins, two browser tabs. Both open the same agent's settings. Admin A changes key X, saves. Admin B (without refreshing) changes key Y, saves. After B's save, look at the agent's settings: X should be back to the original, Y is the new value. **Document this as a known limitation.**
- Same idea but on a per-group save versus a per-agent save running in parallel.

### Mobile read

- Sync timing — change a setting, do *not* sync the phone, behave on the phone, the **old** value is in effect.
- Force-sync the phone (logout/login). Verify the new value takes effect.
- Brand-new agent, fresh phone, first login: verify they get the company defaults (no override exists yet).

### Validation

- Each typed field — checkbox, text, select, integer, timepicker — try invalid values (negative integer, malformed time, unknown select option). Each should fail with the field's name.
- Save with permission revoked. Verify the save is rejected.

### Cross-module touchpoints

- Toggle `order.follow_sequence` on. Verify the mobile app forces the agent to visit clients in route order.
- Toggle `gps.required` on. Verify the visit screen blocks check-in without GPS.
- Toggle `audit.facing`. Verify the audit checkbox appears in the visit screen.
- Toggle `agent.payment_enabled`. Verify cash-collection on the mobile app appears or disappears accordingly.
- Restrict the agent's `PRODUCT_ID` to a single category via [Product distribution](./product-distribution.md). Verify the mobile app lists only those products.

## Where this leads next

- The parallel feature for drivers: [expeditor-packet](./expeditor-packet.md).
- The screen that controls which products an agent can sell: [Product distribution](./product-distribution.md).
- The screen the agent uses on their phone, which all this configures: [Role — Agent](./role-agent.md), [Create order — mobile](../orders/create-order-mobile.md).

## For developers

Developer reference: `protected/models/AgentPaket.php` (model + `mainConfig()` definition), `protected/components/PaketTrait.php` (read/merge logic), `protected/modules/staff/actions/agent/EditAgentConfigAction.php`, `ListAgentPaketAction.php`, `DeleteAgentConfigAction.php`. Mobile read at `protected/modules/api3/controllers/ConfigController.php`.
