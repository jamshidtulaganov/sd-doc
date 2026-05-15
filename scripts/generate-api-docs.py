#!/usr/bin/env python3
"""
Split monolithic api3/api4 docs into per-controller endpoint references.

Reads:
    static/data/routes.json     (from walk-source-routes.py)

Writes:
    docs/api/api-v3-mobile/<controller>.md
    docs/api/api-v3-mobile/index.md          (catalog)
    docs/api/api-v4-online/<controller>.md
    docs/api/api-v4-online/index.md          (catalog)
    i18n/{ru,uz}/.../api/api-v3-mobile/...  (stubs)
    i18n/{ru,uz}/.../api/api-v4-online/...  (stubs)

For each endpoint we also inspect the controller PHP source to extract:
    - HTTP method (POST vs GET) by detecting $_POST / request->getPost vs getQuery
    - Required body / query parameters from getPost('...') / getQuery('...') calls
    - Response shape hints from _sendResponse / CJSON::encode calls

Re-run after routes.json refreshes.
"""
from __future__ import annotations

import json
import os
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Optional

REPO = Path(__file__).resolve().parent.parent
SD_MAIN = Path("/Users/jamshid/projects/salesdoctor/sd-main")
DOCS_API = REPO / "docs" / "api"
I18N_LOCALES = ["ru", "uz"]

API_VERSIONS = {
    "api3": "api-v3-mobile",
    "api4": "api-v4-online",
}

# Yii action method name → URL-friendly slug
def action_url(name: str) -> str:
    # "actionPostDraft" → already trimmed by walker; just lowercase first
    return name[:1].lower() + name[1:]


def controller_slug(controller_class: str) -> str:
    base = controller_class[: -len("Controller")] if controller_class.endswith("Controller") else controller_class
    return base[:1].lower() + base[1:]


def kebab(s: str) -> str:
    """camelCase → kebab-case for use in slug filenames."""
    return re.sub(r"([a-z0-9])([A-Z])", r"\1-\2", s).lower()


def read_controller_body(file_rel: str) -> Optional[str]:
    p = SD_MAIN / file_rel
    if not p.exists():
        return None
    try:
        return p.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return None


def detect_method(action_body: str) -> str:
    if re.search(r"->\s*getPost\(", action_body) or re.search(r"->\s*post\b", action_body) or "$_POST" in action_body:
        return "POST"
    if re.search(r"->\s*getPut\(", action_body):
        return "PUT"
    if re.search(r"->\s*getDelete\(", action_body):
        return "DELETE"
    return "GET"


def extract_params(action_body: str) -> List[Dict[str, str]]:
    """Find request->getPost('foo') / getQuery('foo') and similar."""
    params: List[Dict[str, str]] = []
    seen = set()
    for kind_re, kind in (
        (r"->\s*getPost\(\s*['\"]([\w\.]+)['\"]", "body"),
        (r"->\s*getQuery\(\s*['\"]([\w\.]+)['\"]", "query"),
        (r"->\s*getParam\(\s*['\"]([\w\.]+)['\"]", "param"),
        (r"\$_POST\[\s*['\"]([\w\.]+)['\"]", "body"),
        (r"\$_GET\[\s*['\"]([\w\.]+)['\"]", "query"),
    ):
        for m in re.finditer(kind_re, action_body):
            name = m.group(1)
            if name in seen:
                continue
            seen.add(name)
            params.append({"name": name, "in": kind})
    return params


def extract_response_hint(action_body: str) -> Optional[str]:
    """Find CJSON::encode($foo) or _sendResponse calls to give a shape hint."""
    m = re.search(r"CJSON::encode\(\s*([^)]+?)\)", action_body)
    if m:
        return m.group(1).strip()
    m = re.search(r"_sendResponse\(\s*\d+\s*,\s*([^)]+)\)", action_body)
    if m:
        return m.group(1).strip()
    return None


def slice_action_body(txt: str, action_name: str) -> Optional[str]:
    """Slice action body for both inline and external action classes.

    We don't try perfect brace-matching (PHP source has `{` inside strings,
    heredocs, regex, comments — a real parser is overkill for our docs).
    Instead: take everything from this action's opening `(` until the next
    `public function action` declaration or 30K chars, whichever is first.
    That window is more than enough for getPost/CJSON::encode hints.
    """
    pat = rf"public\s+function\s+action{re.escape(action_name[0].upper()+action_name[1:])}\s*\("
    m = re.search(pat, txt)
    if not m:
        return None
    start = m.end()
    nxt = re.search(r"public\s+function\s+action[A-Z]\w*\s*\(", txt[start:])
    end = start + (nxt.start() if nxt else 30000)
    return txt[start:end]


def render_endpoint(route: dict) -> str:
    """Render one endpoint section."""
    body = read_controller_body(route["file"]) or ""
    action_body = slice_action_body(body, route["action"]) or ""
    method = detect_method(action_body) if action_body else "?"
    params = extract_params(action_body) if action_body else []
    resp_hint = extract_response_hint(action_body) if action_body else None

    path = route["route"]
    out = [
        f"### `{method} {path}`",
        "",
    ]
    if route.get("title"):
        out.append(f"_{route['title']}_")
        out.append("")
    out.append(f"- **Controller**: `{route['controller']}::{route['action']}` "
               f"(`{route['file']}:{route['line']}`)")
    if route.get("rbac"):
        out.append(f"- **RBAC**: `{route['rbac']}`")
    out.append("")

    out.append("**Request**")
    if params:
        out.append("")
        out.append("| Name | In | Type | Required |")
        out.append("|---|---|---|---|")
        for p in params:
            out.append(f"| `{p['name']}` | {p['in']} | _string_ | TBD |")
    else:
        out.append("")
        out.append("_No parameters detected from source. May be a no-arg endpoint, "
                   "or params are derived via action-class properties. "
                   f"Inspect [{route['file']}:{route['line']}](#) directly._")
    out.append("")

    out.append("**Response**")
    out.append("")
    if resp_hint:
        out.append(f"Returns (server returns): `{resp_hint}`")
    else:
        out.append("_Response shape not auto-detected — TBD._")
    out.append("")
    return "\n".join(out)


def render_controller_page(version: str, controller_class: str, routes: List[dict]) -> str:
    """One MD per controller, with all its endpoints as H3 sections."""
    slug = controller_slug(controller_class)
    pretty = controller_class.replace("Controller", "")
    out = [
        "---",
        f'title: "{version} · {pretty}"',
        f"sidebar_position: 1",
        "---",
        "",
        f"# {version} · `{controller_class}`",
        "",
        f"Endpoints for `{controller_class}` (`{routes[0]['file']}`). "
        f"{len(routes)} action(s).",
        "",
    ]
    # Sort actions alphabetically; expose `index` first if present.
    actions_sorted = sorted(routes, key=lambda r: (0 if r["action"] == "index" else 1, r["action"]))
    for r in actions_sorted:
        out.append(render_endpoint(r))
    out.append("## See also")
    out.append("")
    out.append(f"- [{version} overview](./)")
    out.append("- [Authentication](../authentication.md)")
    out.append("- [Error codes](../error-codes.md)")
    out.append("")
    return "\n".join(out)


def render_version_index(version_label: str, version_dir_label: str, by_controller: Dict[str, List[dict]], legacy_body: Optional[str] = None) -> str:
    """Index page — preserves any legacy prose then appends the catalogue."""
    total = sum(len(v) for v in by_controller.values())
    out = [
        "---",
        f'title: "{version_label}"',
        f"sidebar_position: 1",
        "---",
        "",
    ]
    if legacy_body:
        out.append(legacy_body.strip())
        out.append("")
        out.append("---")
        out.append("")
    else:
        out.append(f"# {version_label}")
        out.append("")
    out.append("## Endpoint catalogue")
    out.append("")
    out.append(
        f"Auto-generated from `static/data/routes.json` via "
        "`scripts/generate-api-docs.py`. **{} controllers, {} endpoints.** "
        "Click a controller name to see every action with detected request "
        "params and source-file pointer.".format(len(by_controller), total)
    )
    out.append("")
    out.append("| Controller | Endpoints | First endpoint |")
    out.append("|---|---|---|")
    for ctrl in sorted(by_controller):
        rs = by_controller[ctrl]
        slug = controller_slug(ctrl)
        first = rs[0]
        out.append(f"| [{ctrl}](./{slug}) | {len(rs)} | `{first['route']}` |")
    out.append("")
    out.append("## See also")
    out.append("")
    out.append("- [API overview](../overview.md)")
    out.append("- [Authentication](../authentication.md)")
    out.append("- [Error codes](../error-codes.md)")
    out.append("")
    return "\n".join(out)


def extract_legacy_body(legacy_path: Path) -> Optional[str]:
    """Read a monolithic api-vN-x.md and return body (without frontmatter)."""
    if not legacy_path.exists():
        return None
    txt = legacy_path.read_text()
    parts = txt.split("---", 2)
    return parts[2] if len(parts) >= 3 else txt


def stub_locale(locale: str, en_content: str) -> str:
    parts = en_content.split("---", 2)
    if len(parts) < 3:
        return en_content
    body_lang = {"ru": "Russian", "uz": "Uzbek"}[locale]
    return f"---{parts[1]}---\n\n<!-- TODO: translate to {body_lang} (auto-generated stub) -->\n"


def main() -> int:
    routes = json.loads((REPO / "static" / "data" / "routes.json").read_text())

    VERSION_LABELS = {
        "api-v3-mobile": "API v3 — Mobile agent",
        "api-v4-online": "API v4 — Online / B2B",
    }
    for module, slug in API_VERSIONS.items():
        version_label = VERSION_LABELS.get(slug, slug)
        version_dir = DOCS_API / slug
        version_dir.mkdir(parents=True, exist_ok=True)

        # Group by controller
        rows = [r for r in routes if r["module"] == module]
        by_ctrl: Dict[str, List[dict]] = defaultdict(list)
        for r in rows:
            by_ctrl[r["controller"]].append(r)

        # Wipe existing per-controller pages (keep index, will be rewritten)
        for f in version_dir.glob("*.md"):
            f.unlink()

        # Preserve any legacy monolithic page as the index's prose preamble.
        legacy_md = DOCS_API / f"{slug}.md"
        legacy_body = extract_legacy_body(legacy_md)

        # Render index + each controller
        (version_dir / "index.md").write_text(
            render_version_index(version_label, slug, by_ctrl, legacy_body)
        )
        # Remove the legacy monolith so it doesn't collide with the new index.
        if legacy_md.exists():
            legacy_md.unlink()
        for ctrl, rs in by_ctrl.items():
            csl = controller_slug(ctrl)
            (version_dir / f"{csl}.md").write_text(render_controller_page(slug, ctrl, rs))

        print(f"{slug}: wrote index + {len(by_ctrl)} controller pages ({len(rows)} endpoints)")

        # i18n stubs
        for locale in I18N_LOCALES:
            i18n_root = REPO / "i18n" / locale / "docusaurus-plugin-content-docs" / "current" / "api" / slug
            if i18n_root.exists():
                for f in i18n_root.glob("*.md"):
                    f.unlink()
            i18n_root.mkdir(parents=True, exist_ok=True)
            for f in version_dir.glob("*.md"):
                (i18n_root / f.name).write_text(stub_locale(locale, f.read_text()))

    return 0


if __name__ == "__main__":
    sys.exit(main())
