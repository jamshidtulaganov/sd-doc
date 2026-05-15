#!/usr/bin/env python3
"""
Walk sd-main controllers and emit a flat routes inventory.

Usage:
    cd ~/projects/salesdoctor/sd-main
    python3 ../sd-docs/scripts/walk-source-routes.py \
        > ../sd-docs/static/data/routes.json

Scans every active *Controller.php under:
    - protected/controllers/                 (app-wide controllers, e.g. SiteController)
    - protected/modules/<module>/controllers/

Captures two action styles common in Yii1 + this codebase:
    1. Inline:   public function actionFoo()   ->  route /<module>/<controller>/foo
    2. External: 'foo' => ['class' => 'application.modules.x.actions.FooAction']

For each route the script also tries to pull:
    - rbac:        H::access('operation.<x>.<y>')   (taken from the action body)
    - pageTitle:   $this->pageTitle = Yii::t(...)   (first match in action body)
    - render:      $this->render('view/name')       (first match in action body)

Output is a JSON array of:
    {
        "module":     "orders"     | null,
        "controller": "EditController",
        "controller_url": "edit",
        "action":     "partialDefect",
        "route":      "/orders/edit/partialDefect",
        "kind":       "inline" | "external",
        "rbac":       "operation.orders.partial-defect"  | null,
        "title":      "Частичный возврат"                | null,
        "render":     "order/partialDefect"              | null,
        "file":       "protected/modules/orders/controllers/EditController.php",
        "line":       137
    }

Re-run after controller/action changes; commit the resulting routes.json
so docs can be regenerated deterministically.
"""

from __future__ import annotations

import json
import os
import re
import sys
from glob import glob
from typing import List, Optional, Tuple


ROOT_CONTROLLER_DIR = "protected/controllers"
MODULES_DIR = "protected/modules"


def url_segment(name: str) -> str:
    """Yii1 lower-cases the first letter for the URL: actionFoo -> /foo."""
    return name[:1].lower() + name[1:] if name else name


def find_files() -> List[Tuple[Optional[str], str]]:
    """Yield (module, file_path) for each *Controller.php."""
    out: List[Tuple[Optional[str], str]] = []
    # App-wide controllers
    for p in sorted(glob(os.path.join(ROOT_CONTROLLER_DIR, "*Controller.php"))):
        if p.endswith(".obsolete"):
            continue
        out.append((None, p))
    # Module controllers
    for mod in sorted(os.listdir(MODULES_DIR)):
        cdir = os.path.join(MODULES_DIR, mod, "controllers")
        if not os.path.isdir(cdir):
            continue
        for p in sorted(glob(os.path.join(cdir, "*Controller.php"))):
            if p.endswith(".obsolete"):
                continue
            out.append((mod, p))
    return out


# Match `public function actionFoo(` and capture name+start offset.
RE_INLINE_ACTION = re.compile(
    r"public\s+function\s+action([A-Z]\w*)\s*\(",
)

# Match an entry in actions(): 'key' => ['class' => 'application....FooAction']
RE_EXTERNAL_ACTION = re.compile(
    r"['\"]([\w\-]+)['\"]\s*=>\s*\[\s*['\"]class['\"]\s*=>\s*['\"](application\.[\w\.]+)['\"]",
)

RE_RBAC = re.compile(r"H::access\(\s*['\"]([^'\"]+)['\"]")
RE_TITLE = re.compile(r"\$this->pageTitle\s*=\s*Yii::t\([^,]+,\s*['\"]([^'\"]+)['\"]")
RE_RENDER = re.compile(r"\$this->render\(\s*['\"]([^'\"]+)['\"]")


def slice_action_body(txt: str, start: int) -> str:
    """Return roughly the body of the action starting at index `start`.

    We don't try to brace-match perfectly; we just scan forward up to the
    next `public function ` declaration or 2000 chars, whichever is first.
    Good enough to catch H::access / pageTitle / render lines.
    """
    next_decl = re.search(r"public\s+function\s+\w", txt[start + 1 :])
    end = start + 1 + (next_decl.start() if next_decl else 2000)
    return txt[start:end]


def line_of(txt: str, offset: int) -> int:
    return txt.count("\n", 0, offset) + 1


def controller_url(controller_class: str) -> str:
    """EditController -> edit, OrderBonusController -> orderBonus."""
    base = controller_class[: -len("Controller")] if controller_class.endswith("Controller") else controller_class
    return base[:1].lower() + base[1:] if base else base


def parse_one(module: Optional[str], path: str) -> List[dict]:
    try:
        txt = open(path, encoding="utf-8", errors="replace").read()
    except OSError:
        return []

    m = re.search(r"class\s+(\w+Controller)\b", txt)
    if not m:
        return []
    cls = m.group(1)
    curl = controller_url(cls)
    base_route = f"/{module}/{curl}" if module else f"/{curl}"
    rel = os.path.relpath(path)

    rows: list[dict] = []

    # 1. Inline actions
    for am in RE_INLINE_ACTION.finditer(txt):
        name = am.group(1)
        body = slice_action_body(txt, am.start())
        rbac = (RE_RBAC.search(body) or [None, None])[1] if RE_RBAC.search(body) else None
        title = (RE_TITLE.search(body) or [None, None])[1] if RE_TITLE.search(body) else None
        render = (RE_RENDER.search(body) or [None, None])[1] if RE_RENDER.search(body) else None
        action_url = url_segment(name)
        rows.append({
            "module": module,
            "controller": cls,
            "controller_url": curl,
            "action": action_url,
            "route": f"{base_route}/{action_url}",
            "kind": "inline",
            "rbac": rbac,
            "title": title,
            "render": render,
            "file": rel,
            "line": line_of(txt, am.start()),
        })

    # 2. External action classes
    # Look only inside the actions() return array to avoid false positives.
    am2 = re.search(r"function\s+actions\s*\([^)]*\)\s*\{", txt)
    if am2:
        # Take everything from the opening brace until the matching `}` (cheap: until next "public function" or EOF)
        slice_start = am2.end()
        rest = txt[slice_start:]
        nxt = re.search(r"\n\s*(public|protected|private)\s+function\s", rest)
        body = rest[: nxt.start()] if nxt else rest
        for em in RE_EXTERNAL_ACTION.finditer(body):
            key = em.group(1)
            cls_ref = em.group(2)
            # Often actions are in protected/modules/<mod>/actions/...
            rows.append({
                "module": module,
                "controller": cls,
                "controller_url": curl,
                "action": key,
                "route": f"{base_route}/{key}",
                "kind": "external",
                "rbac": None,
                "title": None,
                "render": None,
                "action_class": cls_ref,
                "file": rel,
                "line": line_of(txt, slice_start + em.start()),
            })

    return rows


def main() -> int:
    rows: List[dict] = []
    for module, path in find_files():
        rows.extend(parse_one(module, path))
    # Stable sort: module, controller, action
    rows.sort(key=lambda r: (r.get("module") or "", r["controller"], r["action"]))
    json.dump(rows, sys.stdout, indent=2, ensure_ascii=False)
    sys.stdout.write("\n")
    print(
        f"\n# {len(rows)} routes across {len({r['file'] for r in rows})} controller files",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
