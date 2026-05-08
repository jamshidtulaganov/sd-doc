#!/usr/bin/env python3
"""
Extract sd-main's schema from Yii model files.

Usage:
    cd ~/projects/salesdoctor/sd-main
    python3 ../sd-docs/scripts/extract-schema.py \
        > ../sd-docs/static/data/schema-extract.json

Reads every active *.php file in protected/models/ (skipping *.obsolete),
and for each model parses:

  - class name + parent class
  - tableName()  OR  filialTable()  (BaseFilial-derived models override
    filialTable, not tableName, so we need both)
  - primaryKey()
  - @property docblock columns
  - relations() (BELONGS_TO / HAS_ONE / HAS_MANY / MANY_MANY)

Resolves the table template (e.g. `{{order}}`) into the final table
name `d0_order` (using the project tablePrefix).

Re-run on every schema-changing PR; commit the resulting
schema-extract.json so the docs site picks it up.
"""

import os, re, json, sys, glob

MODEL_DIR = "protected/models"
TABLE_PREFIX = "d0_"  # matches main.php config


def parse_one(path):
    txt = open(path, encoding="utf-8", errors="replace").read()

    cls_match = re.search(r"class\s+(\w+)\s+extends\s+(\w+)", txt)
    if not cls_match:
        return None
    cls, parent = cls_match.group(1), cls_match.group(2)

    cols = re.findall(r"@property\s+(\S+)\s+\$(\w+)", txt)

    # Look for filialTable() OR tableName() — BaseFilial-derived models
    # override filialTable instead of tableName.
    table_template = None
    table_source = None
    for fn in ("filialTable", "tableName"):
        m = re.search(
            rf"function\s+{fn}\s*\([^)]*\)\s*[:\w]*\s*\{{[^{{}}]*?return\s+(['\"])([^'\"]+)\1",
            txt,
            re.S,
        )
        if m:
            table_template = m.group(2)
            table_source = fn
            break

    pk = re.search(
        r"function\s+primaryKey\s*\(\)\s*\{[^}]*?return\s+(['\"])(.+?)\1",
        txt,
        re.S,
    )
    pkn = pk.group(2) if pk else None
    pkarr = re.search(
        r"function\s+primaryKey\s*\(\)\s*\{[^}]*?return\s+array\(([^)]+)\)",
        txt,
        re.S,
    )
    if not pkn and pkarr:
        pkn = " / ".join(s.strip().strip("\"'") for s in pkarr.group(1).split(","))

    rel_block = re.search(
        r"function\s+relations\s*\(\)\s*\{(.+?)\n\s*\}", txt, re.S
    )
    rels = []
    if rel_block:
        body = rel_block.group(1)
        for m in re.finditer(
            r"['\"](\w+)['\"]\s*=>\s*(?:array|\[)\(?\s*self::(BELONGS_TO|HAS_ONE|HAS_MANY|MANY_MANY)\s*,\s*['\"]([\w\\\\]+)['\"]\s*,\s*['\"]([^'\"]+)['\"]",
            body,
        ):
            rels.append({
                "name":   m.group(1),
                "type":   m.group(2),
                "target": m.group(3),
                "fk":     m.group(4),
            })

    # Resolve {{template}} → d0_template
    if table_template:
        t = table_template.strip()
        if t.startswith("{{") and t.endswith("}}"):
            table = TABLE_PREFIX + t[2:-2]
        else:
            table = t  # already an explicit table name
    else:
        # Yii default: lowercased class with prefix.
        table = TABLE_PREFIX + cls.lower()

    return {
        "file":           os.path.basename(path),
        "class":          cls,
        "parent":         parent,
        "table":          table,
        "table_template": table_template,
        "table_source":   table_source,  # 'filialTable', 'tableName' or None
        "pk":             pkn,
        "cols":           cols,
        "rels":           rels,
    }


def main():
    if not os.path.isdir(MODEL_DIR):
        print(
            f"ERROR: run me from sd-main repo root (no '{MODEL_DIR}' here)",
            file=sys.stderr,
        )
        sys.exit(2)

    out = []
    for path in sorted(glob.glob(os.path.join(MODEL_DIR, "*.php"))):
        if path.endswith(".obsolete"):
            continue
        parsed = parse_one(path)
        if parsed:
            out.append(parsed)

    by_source = {}
    for m in out:
        by_source[m["table_source"] or "default"] = (
            by_source.get(m["table_source"] or "default", 0) + 1
        )

    print(f"Parsed {len(out)} models", file=sys.stderr)
    print(f"  table source breakdown: {by_source}", file=sys.stderr)
    print(f"  with PK declared:    {sum(1 for x in out if x['pk'])}", file=sys.stderr)
    print(f"  total cols:          {sum(len(x['cols']) for x in out)}", file=sys.stderr)
    print(f"  total rels:          {sum(len(x['rels']) for x in out)}", file=sys.stderr)

    json.dump(out, sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
