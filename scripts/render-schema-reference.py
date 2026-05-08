#!/usr/bin/env python3
"""
Render docs/data/schema-reference.md from the model extract + live SQL dump.

Inputs:
    static/data/schema-extract.json    — output of extract-schema.py
    static/data/live-schema-parsed.json — output of parse-live-schema.py

Output:
    Markdown to stdout. Redirect to docs/data/schema-reference.md.

Usage:
    python3 sd-docs/scripts/render-schema-reference.py \
        > sd-docs/docs/data/schema-reference.md
"""

import json, os, re, sys
from collections import defaultdict, Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODELS_PATH = os.path.join(ROOT, "static/data/schema-extract.json")
LIVE_PATH = os.path.join(ROOT, "static/data/live-schema-parsed.json")

models = json.load(open(MODELS_PATH))
live = json.load(open(LIVE_PATH))

table_to_model = {m["table"]: m for m in models if m.get("table")}


def bucket(name):
    n = re.sub(r"^d0_", "", name)
    rules = [
        ("order", "Orders"), ("client", "Clients"), ("agent", "Agents"),
        ("product", "Catalog"), ("cat", "Catalog"), ("price", "Catalog"),
        ("stock", "Stock"), ("warehouse", "Warehouse"), ("inventory", "Inventory"),
        ("store", "Store"), ("lot", "Lot management"),
        ("payment", "Payment / Pay"), ("pay_", "Payment / Pay"), ("pay", "Payment / Pay"),
        ("cashbox", "Cashbox"), ("finans", "Finans"), ("bonus", "Bonus"),
        ("audit", "Audit"), ("adt_", "Audit ADT"), ("adt", "Audit ADT"), ("aud_", "Audit master"),
        ("akb", "AKB"), ("photo", "Photo"), ("plan", "Plan"),
        ("gps", "GPS"), ("visit", "Visit"), ("route", "Route"), ("track", "GPS"),
        ("sms", "SMS"), ("telegram", "Telegram"),
        ("idokon", "Integration"), ("apelsin", "Integration"), ("click", "Integration"),
        ("payme", "Integration"), ("paynet", "Integration"), ("didox", "Integration"),
        ("user", "User / Auth"), ("access", "User / Auth"), ("auth", "User / Auth"),
        ("filial", "Filial"), ("diler", "Diler"), ("distr", "Distributor"),
        ("contragent", "Contragent"), ("contact", "Contact"), ("contract", "Contract"),
        ("kpi", "KPI"), ("rating", "Rating"),
        ("tara", "Tara"), ("vs", "Vansel"), ("expeditor", "Expeditor"),
        ("reject", "Reject"), ("defect", "Defect"),
        ("doctor", "Doctor"), ("manager", "Manager"), ("partner", "Partner"),
        ("config", "Config"), ("cache", "Cache"), ("cron", "Cron"),
        ("loyalty", "Loyalty"), ("knowledge", "Knowledge base"), ("skidka", "Discount"),
        ("comment", "Comment"), ("notify", "Notification"),
        ("sd_", "sd*"), ("demo", "Demo"),
    ]
    for prefix, label in rules:
        if n.startswith(prefix):
            return label
    return "Other"


# --- Render markdown to stdout ---
out = sys.stdout
def w(s=""): out.write(s + "\n")

w("---")
w("sidebar_position: 6")
w("title: Schema reference (live + models)")
w("audience: Backend engineers, QA, PM, Data engineers")
w("summary: Authoritative schema reference for sd-main built from BOTH the live MySQL dump AND the active Yii models. Truth-source for migrations, reports, and any RAG query about the data layer.")
w("topics: [schema, erd, models, tables, columns, indexes, mysql, charset, engine]")
w("---")
w()
w("# Schema reference (live + models)")
w()
w("This page combines two sources:")
w()
w("- **`live-schema.sql`** — `mysqldump --no-data --routines --triggers` of a")
w("  development sd-main MySQL 8.0 instance.")
w("- **`schema-extract.json`** — parsed `@property` docblocks,")
w("  `tableName()` / `filialTable()` / `primaryKey()` / `relations()` from")
w("  every active Yii model under `sd-main/protected/models/`.")
w()
w("Run the procedure under [Refresh procedure](#refresh-procedure)")
w("after any schema-changing PR.")
w()

# Headline numbers
w("## Headline numbers")
w()
w("| Metric | Value |")
w("|--------|-------|")
w(f"| Tables in live MySQL | **{len(live)}** |")
w(f"| Active models | **{len(models)}** |")
w(f"| Models resolvable to a real table | **{sum(1 for m in models if m.get('table') in live)}** |")
w(f"| Tables in MySQL with no model | **{len(set(live.keys()) - {m['table'] for m in models if m.get('table')})}** |")
w(f"| Total columns (live) | **{sum(len(t['cols']) for t in live.values())}** |")
w(f"| Total declared `relations()` | **{sum(len(m['rels']) for m in models)}** |")
w(f"| Foreign keys at DB level | **{sum(len(t['fks']) for t in live.values())}** |")
w(f"| Indexes (non-unique) | **{sum(len(t['indexes']) for t in live.values())}** |")
w(f"| Unique keys | **{sum(len(t['uniques']) for t in live.values())}** |")
w()

# Engines / charsets
engines = Counter(t["engine"] for t in live.values())
charsets = Counter(t["charset"] for t in live.values())
w("## Engines and charsets")
w()
w("| Engine | Count |")
w("|--------|-------|")
for e, c in engines.most_common():
    w(f"| `{e}` | {c} |")
w()
w("| Charset | Count |")
w("|---------|-------|")
for c, n in charsets.most_common():
    w(f"| `{c}` | {n} |")
w()
w("**Action item**: any MyISAM tables and any `utf8mb3` tables are legacy.")
w("Plan a migration to InnoDB + `utf8mb4` over time.")
w()

# Tables in DB without a model
modelled = {m["table"] for m in models if m.get("table")}
unmodelled = sorted(set(live.keys()) - modelled)
w("## Tables in DB without a Yii model")
w()
w(f"{len(unmodelled)} tables exist in MySQL but no Yii model maps to them.")
w()
w("| Table | Cols | Indexes | Engine | Charset |")
w("|-------|------|---------|--------|---------|")
for t in unmodelled:
    info = live[t]
    w(f"| `{t}` | {len(info['cols'])} | {len(info['indexes'])} | `{info['engine']}` | `{info['charset']}` |")
w()

# Tables by domain
by = defaultdict(list)
for name, t in live.items():
    by[bucket(name)].append((name, t))
w("## Tables by domain")
w()
for grp in sorted(by.keys()):
    items = sorted(by[grp])
    w(f"### {grp} ({len(items)} tables)")
    w()
    w("| Table | Cols | PK | Engine / charset | Model |")
    w("|-------|------|----|--------------------|-------|")
    for name, t in items:
        pk_str = (t["pks"][0] if t["pks"] else "—").replace("|", "/")[:40]
        cs = f"{t['engine']}/{t['charset'] or '?'}"
        modelname = table_to_model.get(name, {}).get("class", "—")
        w(f"| `{name}` | {len(t['cols'])} | `{pk_str}` | {cs} | `{modelname}` |")
    w()

# Index of all active models
w("## Index of active models")
w()
w(f"All {len(models)} active Yii models, alphabetised.")
w()
w("| Class | Table | PK | Cols (model) | Cols (live) | Relations |")
w("|-------|-------|----|--------------|-------------|-----------|")
for m in sorted(models, key=lambda x: x["class"].lower()):
    t = m.get("table")
    live_cols = len(live[t]["cols"]) if t in live else "—"
    table_link = f"`{t}`" if t in live else f"`{t}` ⚠"
    w(f"| `{m['class']}` | {table_link} | `{m['pk'] or '—'}` | {len(m['cols'])} | {live_cols} | {len(m['rels'])} |")
w()
w("⚠ = expected table not found in the live dump.")
w()

# Refresh procedure
w("## Refresh procedure")
w()
w("```bash")
w("# 1. Re-extract from models")
w("cd ~/projects/salesdoctor/sd-main")
w("python3 ../sd-docs/scripts/extract-schema.py \\")
w("    > ../sd-docs/static/data/schema-extract.json")
w("")
w("# 2. Re-dump the live schema (no rows)")
w("docker compose exec db mysqldump --no-data --routines --triggers \\")
w("    -uroot -proot sd_main \\")
w("    > ../sd-docs/static/data/live-schema.sql")
w("")
w("# 3. Parse the live SQL")
w("python3 ../sd-docs/scripts/parse-live-schema.py \\")
w("    < ../sd-docs/static/data/live-schema.sql \\")
w("    > ../sd-docs/static/data/live-schema-parsed.json")
w("")
w("# 4. Render this page")
w("python3 ../sd-docs/scripts/render-schema-reference.py \\")
w("    > ../sd-docs/docs/data/schema-reference.md")
w("```")
