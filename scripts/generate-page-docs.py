#!/usr/bin/env python3
"""
Generate per-page reference docs from harvested data.

Reads:
    static/data/pages.json        (from harvest-live.mjs)
    static/data/routes.json       (from walk-source-routes.py)

Writes:
    docs/ui/pages/index.md
    docs/ui/pages/<module>/index.md
    docs/ui/pages/<module>/<slug>.md
    i18n/ru/docusaurus-plugin-content-docs/current/ui/pages/...    (stubs)
    i18n/uz/docusaurus-plugin-content-docs/current/ui/pages/...    (stubs)

Each page MD links its URL, role, screenshot, fields, columns, actions,
and back to the owning module page in docs/modules/. Re-run after the
harvester to refresh.
"""
from __future__ import annotations

import json
import os
import re
import sys
from collections import defaultdict
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DOCS = REPO / "docs"
UI   = DOCS / "ui" / "pages"
I18N_LOCALES = ["ru", "uz"]
SCREENS_ROOT = REPO / "static" / "screens"

MODULE_LABELS = {
    "adt": "ADT audit",
    "agents": "Agents",
    "audit": "Audit (visit)",
    "clients": "Clients",
    "dashboard": "Dashboard",
    "gps2": "GPS v2",
    "integration": "Integration",
    "inventory": "Inventory",
    "markirovka": "Markirovka (CIS)",
    "onlineOrder": "Online order",
    "orders": "Orders",
    "planning": "Planning",
    "report": "Reports",
    "sms": "SMS",
    "staff": "Staff",
    "stock": "Stock",
    "store": "Store",
    "team": "Team",
    "vs": "Van-selling",
    "warehouse": "Warehouse",
}

# Existing module docs that we cross-link to from each page card.
EXISTING_MODULE_DOCS = {
    "agents", "audit-adt", "clients", "dashboard", "finans", "gps",
    "integration", "inventory", "onlineOrder", "orders", "overview",
    "payment", "report", "settings-access-staff", "sms", "stock",
    "store", "sync", "warehouse",
}
# URL prefix → docs/modules/<slug>.md mapping
MODULE_DOC_FOR_PREFIX = {
    "adt": "audit-adt",
    "audit": "audit-adt",
    "agents": "agents",
    "clients": "clients",
    "dashboard": "dashboard",
    "gps2": "gps",
    "integration": "integration",
    "inventory": "inventory",
    "markirovka": "modules/markirovka",  # written in Phase 3
    "onlineOrder": "onlineOrder",
    "orders": "orders",
    "planning": "modules/planning",      # written in Phase 3
    "report": "report",
    "sms": "sms",
    "staff": "settings-access-staff",
    "stock": "stock",
    "store": "store",
    "team": "modules/team",              # written in Phase 3
    "vs": "modules/vs",                  # written in Phase 3
    "warehouse": "warehouse",
}


def slugify(url: str) -> str:
    s = url.lstrip("/").replace("/", "_")
    s = re.sub(r"[^\w\-.]+", "", s)
    return s[:80] or "root"


def safe_text(s: str) -> str:
    """Escape MDX-meaningful characters in arbitrary string content.

    Captured UI strings sometimes contain Vue templates like
    `{{ $t('foo') }}` that MDX tries to evaluate as JSX expressions.
    Wrap any line containing `{` in inline code to neutralize it.
    """
    if s is None:
        return ""
    if "{" in s or "}" in s or "<" in s:
        return "`" + s.replace("`", "'") + "`"
    return s


def module_of(url: str) -> str:
    parts = url.lstrip("/").split("/", 1)
    return parts[0] or "root"


def load_routes_index() -> dict:
    """Index routes by full route path; we match URLs against it."""
    routes_path = REPO / "static" / "data" / "routes.json"
    if not routes_path.exists():
        return {}
    data = json.loads(routes_path.read_text())
    by_route = {}
    for r in data:
        by_route[r["route"].rstrip("/").lower()] = r
    return by_route


def find_route(by_route: dict, url: str) -> dict | None:
    """Best-effort match an observed URL to a controller action.

    Yii1 fills missing pieces with `index`. So `/orders/list` should look
    up `/orders/list/index` (module=orders, ctrl=list, action=index), and
    `/planning` should look up `/planning/default/index`.
    """
    u = url.rstrip("/").lower()
    # Exact (3+ segments — typically already includes action).
    if u in by_route:
        return by_route[u]
    # 2-segment URL → try `<url>/index` for the default action.
    if u in by_route or (u + "/index") in by_route:
        return by_route.get(u) or by_route.get(u + "/index")
    if (u + "/index") in by_route:
        return by_route[u + "/index"]
    # 1-segment URL → try `<url>/default/index` (Yii module default ctrl).
    if u.count("/") == 1 and (u + "/default/index") in by_route:
        return by_route[u + "/default/index"]
    # Drop last segment and try again (it might be an ID).
    parts = u.split("/")
    if len(parts) >= 4:
        return by_route.get("/".join(parts[:-1]))
    return None


def render_page(row: dict, by_route: dict) -> str:
    url = row["url"]
    module = module_of(url)
    raw_title = row.get("h1") or row.get("title") or url
    # Strip Vue template tokens from titles; they wreck MDX parsing.
    title = re.sub(r"\{\{[^}]*\}\}", "", raw_title).strip() or url
    route = find_route(by_route, url)
    shot = row.get("screenshot")  # static/screens/admin/foo.jpg → /screens/admin/foo.jpg

    safe_title = title.replace('"', "'")
    front = [
        "---",
        f"title: \"{safe_title}\"",
        "audience: All sd-main developers, QA",
        f"summary: Live admin page at {url}",
        f"topics: [{module}, page, ui]",
        "---",
        "",
        f"# {title}",
        "",
    ]

    # Header card
    bits = [f"**URL**: `{url}`", f"**Module**: `{module}`"]
    if route:
        bits.append(f"**Controller**: `{route['controller']}::{route['action']}`")
        if route.get("rbac"):
            bits.append(f"**RBAC**: `{route['rbac']}`")
    bits.append(f"**Role harvested**: `{row.get('role','admin')}`")
    front.append(" · ".join(bits))
    front.append("")

    if shot:
        rel = shot.replace("static/", "/")
        front.append(f"![Screenshot of {title}]({rel})")
        front.append("")

    front.append("## Purpose")
    front.append("")
    front.append(
        f"This page lives at `{url}` in the live admin. "
        f"It belongs to the **{MODULE_LABELS.get(module, module)}** subsystem. "
        f"Captured via the live harvester on the demo tenant; the screenshot above shows "
        f"the page as it renders for the `{row.get('role','admin')}` role on a 1440×900 viewport."
    )
    front.append("")

    if row.get("breadcrumb"):
        front.append("**Breadcrumb**: " + " › ".join(row["breadcrumb"]))
        front.append("")

    # Fields
    fields = [f for f in row.get("fields", []) if f.get("label")]
    if fields:
        front.append("## Fields")
        front.append("")
        front.append("| Label | Name | Type | Required |")
        front.append("|---|---|---|---|")
        seen = set()
        for f in fields:
            key = (f.get("label",""), f.get("name") or "")
            if key in seen:
                continue
            seen.add(key)
            front.append(
                f"| {safe_text(f.get('label','—'))} | `{f.get('name') or '—'}` "
                f"| {f.get('type','—')} | {'✅' if f.get('required') else '—'} |"
            )
        front.append("")

    # Columns
    if row.get("columns"):
        front.append("## Grid columns")
        front.append("")
        front.append("| # | Column |")
        front.append("|---|---|")
        for i, c in enumerate(row["columns"], 1):
            front.append(f"| {i} | {safe_text(c)} |")
        front.append("")

    # Actions
    if row.get("actions"):
        front.append("## Actions")
        front.append("")
        for a in row["actions"]:
            front.append(f"- {safe_text(a)}")
        front.append("")

    # Controller / RBAC / route
    if route:
        front.append("## Backend route")
        front.append("")
        front.append(f"- **Controller file**: `{route['file']}` (line {route['line']})")
        front.append(f"- **Action kind**: {route['kind']}")
        if route.get("render"):
            front.append(f"- **View rendered**: `{route['render']}`")
        if route.get("title"):
            front.append(f"- **PageTitle()**: \"{route['title']}\"")
        if route.get("rbac"):
            front.append(f"- **Required permission**: `{route['rbac']}`")
        front.append("")

    # See-also
    mod_doc = MODULE_DOC_FOR_PREFIX.get(module)
    front.append("## See also")
    front.append("")
    if mod_doc:
        if mod_doc.startswith("modules/"):
            front.append(f"- Module reference: [/{mod_doc}](/docs/{mod_doc})")
        else:
            front.append(f"- Module reference: [/modules/{mod_doc}](/docs/modules/{mod_doc})")
    front.append(f"- Routes inventory: [`static/data/routes.json`](/data/routes.json)")
    front.append(f"- Page-to-module map: [/quality/page-to-module-map](/docs/quality/page-to-module-map)")
    front.append("")
    return "\n".join(front)


def render_module_index(module: str, pages: list[dict]) -> str:
    label = MODULE_LABELS.get(module, module)
    out = [
        "---",
        f'title: "{label} — UI pages"',
        f"sidebar_position: 1",
        "---",
        "",
        f"# {label} — UI pages",
        "",
        f"Auto-generated index of every live admin page under `/{module}`.",
        "Re-run `scripts/generate-page-docs.py` after the harvester refresh.",
        "",
        "| URL | Page | Controller |",
        "|---|---|---|",
    ]
    for p in sorted(pages, key=lambda r: r["url"]):
        slug = p.get("_slug") or slugify(p["url"])
        if slug == module:
            slug = f"{module}_root"
        raw_title = (p.get("h1") or p.get("title") or p["url"])
        title = re.sub(r"\{\{[^}]*\}\}", "", raw_title).strip().replace("|", "\\|") or p["url"]
        ctrl = p.get("_route_label", "—")
        out.append(f"| `{p['url']}` | [{title}](./{slug}) | {ctrl} |")
    out.append("")
    return "\n".join(out)


def render_root_index(by_module: dict[str, list[dict]]) -> str:
    total = sum(len(v) for v in by_module.values())
    out = [
        "---",
        "title: \"UI page reference\"",
        "sidebar_position: 1",
        "---",
        "",
        "# UI page reference",
        "",
        f"One entry per live admin page captured by `scripts/harvest-live.mjs`. ",
        f"Currently **{total} pages** across **{len(by_module)} modules**, ",
        "from the `admin` role on the demo tenant.",
        "",
        "Use this to find:",
        "- the URL of a page,",
        "- which controller renders it,",
        "- what fields, grid columns, and action buttons it exposes,",
        "- and which RBAC permission is required.",
        "",
        "Pages are grouped by URL prefix (matching the `protected/modules/<x>` "
        "folder in sd-main).",
        "",
        "## Modules",
        "",
    ]
    for m in sorted(by_module):
        out.append(f"- [{MODULE_LABELS.get(m, m)} ({len(by_module[m])})](./{m}/)")
    out.append("")
    return "\n".join(out)


def stub(locale: str, en_content: str) -> str:
    """Locale-stub: keep frontmatter, replace body with TODO marker."""
    parts = en_content.split("---", 2)
    if len(parts) < 3:
        return en_content
    fm = parts[1]
    body_lang = {"ru": "Russian", "uz": "Uzbek"}[locale]
    return f"---{fm}---\n\n<!-- TODO: translate to {body_lang} (auto-stub from harvester) -->\n"


def main() -> int:
    pages = json.loads((REPO / "static" / "data" / "pages.json").read_text())
    by_route = load_routes_index()

    # Attach controller label for module-index table
    for p in pages:
        r = find_route(by_route, p["url"])
        p["_route_label"] = f"`{r['controller']}::{r['action']}`" if r else "—"

    by_module: dict[str, list[dict]] = defaultdict(list)
    for p in pages:
        by_module[module_of(p["url"])].append(p)

    # Wipe & rewrite EN tree
    if UI.exists():
        for child in UI.rglob("*"):
            if child.is_file():
                child.unlink()
    UI.mkdir(parents=True, exist_ok=True)

    written = 0
    for module, rows in sorted(by_module.items()):
        mod_dir = UI / module
        mod_dir.mkdir(parents=True, exist_ok=True)
        (mod_dir / "index.md").write_text(render_module_index(module, rows))
        for row in rows:
            slug = slugify(row["url"])
            # Docusaurus treats `<dir>/<dir>.md` as a *second* category
            # index, which collides with our explicit `index.md`. Suffix
            # the slug when it equals the parent module name.
            if slug == module:
                slug = f"{module}_root"
                row["_slug"] = slug
            md = render_page(row, by_route)
            (mod_dir / f"{slug}.md").write_text(md)
            written += 1

    (UI / "index.md").write_text(render_root_index(by_module))

    # Mirror to ru/uz
    for locale in I18N_LOCALES:
        loc_root = REPO / "i18n" / locale / "docusaurus-plugin-content-docs" / "current" / "ui" / "pages"
        if loc_root.exists():
            for f in loc_root.rglob("*.md"):
                f.unlink()
        for src in UI.rglob("*.md"):
            rel = src.relative_to(UI)
            tgt = loc_root / rel
            tgt.parent.mkdir(parents=True, exist_ok=True)
            tgt.write_text(stub(locale, src.read_text()))

    print(f"wrote {written} page MDs across {len(by_module)} modules + ru/uz stubs")
    return 0


if __name__ == "__main__":
    sys.exit(main())
