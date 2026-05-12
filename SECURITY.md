# Security

This document describes the threat model for the `sd-docs` site and the steps required to deploy it safely.

## Threat model

`sd-docs` is a **Docusaurus static site** containing internal developer documentation, including pages that enumerate:

- Multi-tenant database layouts and connection patterns
- Production token formats and HMAC signing recipes
- Payment-gateway integration details
- "Landmines" and known weaknesses in legacy code
- Internal IP allow-lists and bot proxies
- Seed credentials for local development
- The full inbound API surface of `sd-billing`

These pages are tagged `RESTRICTED_PATHS` in `src/auth/permissions.js`.

### What the client-side "RBAC" does

`src/auth/` implements a login screen and a sidebar swizzle that hides certain pages from non-superadmin users. **This is a visual hint, not a security boundary.**

- The user database, including plaintext passwords, lives in `src/auth/users.js` and is bundled into every visitor's browser.
- The full markdown of every doc page — including pages tagged as restricted — is shipped as part of `/assets/js/*.js` chunks at build time.
- The list of "restricted" paths is itself bundled, providing a roadmap of which content is sensitive.

A determined visitor can read any "restricted" page by:

1. Logging in with `admin / admin` (default), **or**
2. Fetching the relevant JS chunk directly with `curl` and locating the markdown payload, **or**
3. Disabling the sidebar swizzle in DevTools.

### What server-side gating gives you

Real protection comes from a server-side gate **in front of** the static site:

- HTTP basic-auth at the reverse proxy
- Cloudflare Access / Zero Trust
- Tailscale / WireGuard private network
- nginx `allow`/`deny` IP rules

Any one of these prevents an unauthenticated visitor from reaching the static assets at all. The client-side gate then becomes a redundant UX nicety, not a security control.

## Required deployment posture

The site **MUST NOT** be deployed to a publicly reachable host without server-side gating. See [`deploy/README.md`](./deploy/README.md) for two recommended configurations:

1. **nginx basic-auth** — simplest, see `deploy/nginx-basic-auth.conf.example`
2. **Cloudflare Access** — best for distributed teams, SSO-friendly

## Secrets in markdown

Several pages currently contain references to production tokens, merchant IDs, or HMAC secrets. These were classified as `RESTRICTED_PATHS` on the assumption that the client-side gate would hide them, which is **not true**.

**Required actions:**

- [ ] Audit every page in `RESTRICTED_PATHS` (`src/auth/permissions.js`) for live secrets.
- [ ] Rotate any secret value that has been committed to git history.
- [ ] Move secrets out of markdown into a separate password-manager-backed reference, linked from the docs by name only ("merchant ID — see `sd-prod-secrets`").
- [ ] If a secret was leaked through a previous public deploy, treat it as compromised and rotate immediately.

## What to do before the next deploy

1. Stand up a server-side gate (see `deploy/`).
2. Audit and rotate secrets per the section above.
3. Verify `curl -s https://<docs-host>/assets/js/*.js | grep -E 'TOKEN|merchant_id|HMAC'` returns nothing meaningful.
4. Keep the client-side login as a visual cue — but rely on it for nothing.

## Reporting a vulnerability

Internal — contact `@jtulaganov` directly.
