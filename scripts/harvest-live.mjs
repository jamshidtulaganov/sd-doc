#!/usr/bin/env node
/**
 * Live-demo harvester for sd-docs.
 *
 * Logs into the local sd-main demo (localhost:8080 by default), walks every
 * URL reachable from the left sidebar (`nav.menu-aside`), and for each one
 * captures:
 *
 *   - URL (after redirects), document title, breadcrumb
 *   - role-suffixed screenshot in static/screens/<role>/<slug>.png
 *   - form fields ({ label, name, type })
 *   - table column headers (first .grid-view / .dataTable on the page)
 *   - top-level action buttons / .btn elements
 *
 * Emits:
 *   static/data/pages.json       (one row per crawled URL)
 *   static/data/nav.json         (the discovered sidebar tree)
 *
 * Usage:
 *   node scripts/harvest-live.mjs                       # defaults
 *   BASE=http://localhost:8080 USER=demo PASS=123456 \
 *     ROLE=admin LIMIT=200 node scripts/harvest-live.mjs
 *
 * Required env (with defaults):
 *   BASE     http://localhost:8080
 *   SD_USER  demo                # NOT $USER — shell already has that
 *   SD_PASS  123456
 *   ROLE     admin               # subdirectory under static/screens/
 *   LIMIT    500                 # safety cap on pages visited
 *
 * The script is idempotent — running it twice produces a deterministic
 * pages.json (sorted by URL). Re-run after demo data changes.
 */

import { chromium } from 'playwright';
import fs from 'node:fs/promises';
import path from 'node:path';

const BASE  = process.env.BASE     || 'http://localhost:8080';
const USER  = process.env.SD_USER  || 'demo';
const PASS  = process.env.SD_PASS  || '123456';
const ROLE  = process.env.ROLE     || 'admin';
const LIMIT = parseInt(process.env.LIMIT || '500', 10);

const REPO    = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const DATA    = path.join(REPO, 'static', 'data');
const SHOTS   = path.join(REPO, 'static', 'screens', ROLE);

await fs.mkdir(DATA,  { recursive: true });
await fs.mkdir(SHOTS, { recursive: true });

function slugify(p) {
  return p.replace(/^\//, '').replace(/[\/?&=:]+/g, '_').replace(/[^\w\-.]+/g, '').slice(0, 80) || 'root';
}

function shouldVisit(url) {
  const u = new URL(url, BASE);
  if (u.origin !== new URL(BASE).origin) return false;
  if (u.pathname.startsWith('/site/logout')) return false;
  if (u.pathname.match(/\.(png|jpg|jpeg|gif|svg|webp|pdf|xlsx?|docx?|csv|zip)$/i)) return false;
  // Skip clearly destructive routes
  if (u.pathname.match(/\/delete\//)) return false;
  return true;
}

async function login(page) {
  await page.goto(`${BASE}/site/login`, { waitUntil: 'domcontentloaded' });
  await page.fill('#LoginForm_username', USER);
  await page.fill('#LoginForm_password', PASS);
  await Promise.all([
    page.waitForLoadState('domcontentloaded'),
    page.click('#login-form button[type=submit], #login-form input[type=submit]').catch(() => page.press('#LoginForm_password', 'Enter')),
  ]);
  // Settle redirect chain
  await page.waitForLoadState('networkidle', { timeout: 15000 }).catch(() => {});
}

async function extractMenuTree(page) {
  return await page.evaluate(() => {
    const aside = document.querySelector('nav.menu-aside') || document.querySelector('aside.sidebar-left');
    if (!aside) return { groups: [], links: [] };
    const groups = [];
    const links = [];

    // Heuristic: each "group" is an <li> with a .menu-link that toggles + a
    // nested <ul> of leaf <a href="/...">.  Fall back to flat anchor list.
    const groupNodes = aside.querySelectorAll('li');
    if (groupNodes.length === 0) {
      aside.querySelectorAll('a[href^="/"]').forEach(a => {
        const href = a.getAttribute('href');
        if (href && !href.startsWith('#')) links.push({ href, label: a.textContent.trim() });
      });
      return { groups, links };
    }

    groupNodes.forEach(li => {
      const head = li.querySelector('a.menu-link, .menu-link');
      const headLabel = head ? head.textContent.trim() : '';
      const sub = [];
      li.querySelectorAll('a[href^="/"]').forEach(a => {
        const href = a.getAttribute('href');
        const label = a.textContent.trim();
        if (!href || href === '#' || href.startsWith('#')) return;
        sub.push({ href, label });
        links.push({ href, label, group: headLabel });
      });
      if (headLabel || sub.length) groups.push({ label: headLabel, items: sub });
    });

    return { groups, links };
  });
}

async function describePage(page) {
  return await page.evaluate(() => {
    const txt = (el) => (el ? el.textContent.trim().replace(/\s+/g, ' ') : null);

    // Breadcrumb
    const crumbEls = document.querySelectorAll('.breadcrumb a, .breadcrumb li, .breadcrumbs a');
    const breadcrumb = Array.from(crumbEls).map(e => txt(e)).filter(Boolean);

    // Header / page title
    const h1 = txt(document.querySelector('h1, .page-title, .panel-title'));

    // Fields — label[for] paired with control[id]
    const fields = [];
    document.querySelectorAll('label[for]').forEach(lab => {
      const id = lab.getAttribute('for');
      const ctl = id ? document.getElementById(id) : null;
      if (!ctl) return;
      fields.push({
        label: txt(lab),
        name: ctl.getAttribute('name'),
        type: ctl.tagName.toLowerCase() === 'select' ? 'select' : (ctl.getAttribute('type') || ctl.tagName.toLowerCase()),
        required: ctl.required || ctl.getAttribute('aria-required') === 'true',
      });
    });

    // Grid columns
    const grid = document.querySelector('.grid-view table, table.dataTable, table.items, table');
    const columns = grid ? Array.from(grid.querySelectorAll('thead th')).map(th => txt(th)).filter(Boolean) : [];

    // Top action buttons
    const seen = new Set();
    const actions = [];
    document.querySelectorAll('.btn, button, a.action').forEach(btn => {
      const label = txt(btn);
      if (!label || label.length > 60 || seen.has(label)) return;
      seen.add(label);
      actions.push(label);
    });

    return {
      title: document.title.trim(),
      h1,
      breadcrumb,
      fields,
      columns,
      actions: actions.slice(0, 30),
    };
  });
}

async function main() {
  const browser = await chromium.launch();
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();

  // 1. Login
  console.error(`[harvest] login as ${USER} @ ${BASE}`);
  await login(page);
  console.error(`[harvest] landed on ${page.url()}`);

  // 2. Discover menu
  const nav = await extractMenuTree(page);
  await fs.writeFile(path.join(DATA, 'nav.json'), JSON.stringify(nav, null, 2) + '\n');
  console.error(`[harvest] nav: ${nav.groups.length} groups, ${nav.links.length} links`);

  // 3. Build seed list — start from menu links plus the current landing page.
  const seeds = new Set();
  seeds.add(new URL(page.url()).pathname);
  for (const l of nav.links) seeds.add(l.href);

  // 4. BFS
  const queue = Array.from(seeds);
  const visited = new Set();
  const rows = [];

  while (queue.length && rows.length < LIMIT) {
    const next = queue.shift();
    if (visited.has(next)) continue;
    visited.add(next);
    const url = next.startsWith('http') ? next : `${BASE}${next}`;
    if (!shouldVisit(url)) continue;

    try {
      const resp = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
      const status = resp ? resp.status() : 0;
      await page.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {});
      if (page.url().includes('/site/login')) {
        console.error(`[harvest] re-login required at ${next}`);
        await login(page);
        await page.goto(url, { waitUntil: 'domcontentloaded' }).catch(() => {});
      }
      const desc = await describePage(page);
      const finalUrl = new URL(page.url());
      const slug = slugify(finalUrl.pathname);
      const shotPath = path.join(SHOTS, `${slug}.jpg`);
      // JPEG @ quality 70 keeps full-page shots small enough to commit.
      await page.screenshot({ path: shotPath, fullPage: true, type: 'jpeg', quality: 70 }).catch((e) => {
        console.error(`[harvest] screenshot failed for ${next}: ${e.message}`);
      });
      rows.push({
        url: finalUrl.pathname,
        seed: next,
        role: ROLE,
        status,
        title: desc.title,
        h1: desc.h1,
        breadcrumb: desc.breadcrumb,
        screenshot: path.relative(REPO, shotPath),
        fields: desc.fields,
        columns: desc.columns,
        actions: desc.actions,
      });
      console.error(`[harvest] ${rows.length.toString().padStart(3)} ${status} ${finalUrl.pathname}`);
    } catch (e) {
      console.error(`[harvest]  !! ${next}: ${e.message}`);
      rows.push({ url: next, role: ROLE, error: e.message });
    }
  }

  rows.sort((a, b) => (a.url || '').localeCompare(b.url || ''));
  await fs.writeFile(path.join(DATA, 'pages.json'), JSON.stringify(rows, null, 2) + '\n');
  console.error(`[harvest] wrote ${rows.length} rows to pages.json`);

  await browser.close();
}

main().catch(e => {
  console.error(e);
  process.exit(1);
});
