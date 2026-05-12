# Deploying `sd-docs`

This site contains internal-only content. It **MUST** be deployed behind a real server-side gate. See [`SECURITY.md`](../SECURITY.md) for the threat model.

This directory documents two recommended deployment patterns:

| Pattern | When to pick it |
|---------|-----------------|
| **nginx basic-auth** (`nginx-basic-auth.conf.example`) | You already host the static build on a VM/server with nginx. Lowest setup cost. |
| **Cloudflare Access** (notes below) | You want SSO (Google Workspace, GitHub, Okta) and audit logs without running your own proxy. |

Whichever you pick, the static `build/` output must sit **behind** the gate, never in front of it.

## Option A — nginx basic-auth

1. Build the site locally: `npm ci && npm run build` produces `build/`.
2. Upload `build/` to the server (e.g. `/var/www/sd-docs`).
3. Create the basic-auth password file:

   ```bash
   sudo apt install apache2-utils
   sudo htpasswd -c /etc/nginx/.htpasswd-sd-docs jamshid
   sudo htpasswd /etc/nginx/.htpasswd-sd-docs <another-user>
   ```

4. Install the example server block (`nginx-basic-auth.conf.example`) to `/etc/nginx/sites-available/sd-docs.conf`, edit the `server_name` and `root`, then `ln -s` it into `sites-enabled/` and `nginx -t && systemctl reload nginx`.

The example block authenticates the whole site, sends HSTS, and serves the SPA fallback for Docusaurus.

## Option B — Cloudflare Access

1. Put the site behind Cloudflare (orange-cloud the DNS record).
2. In the Cloudflare dashboard → Zero Trust → Access → Applications → Add an application → **Self-hosted**.
3. Application domain: `docs.salesdoc.io` (or whatever host you use).
4. Path: `/` (covers everything).
5. Identity providers: pick one (Google Workspace is the usual choice for a UZ team).
6. Add a policy: `Include → Emails ending in @salesdoc.io` (or specific group).
7. Save.

Cloudflare Access challenges unauthenticated visitors with an SSO login before any byte of the static build is served. You can leave the origin completely closed except to Cloudflare IPs.

## What about the client-side `/login` screen?

Leave it. Once a real gate is in front, the client-side login is harmless visual decoration. If you don't want users seeing two login screens, remove `src/auth/` and the related swizzle — but only after the server-side gate is verified working.
