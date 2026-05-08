#!/usr/bin/env python3
"""
Generate docs/diagrams/ — a grouped gallery of every Mermaid diagram in
the docs site, drawn inline.

Usage:
    cd ~/projects/salesdoctor/sd-docs
    python3 scripts/render-diagram-gallery.py

What it does:
- Walks `docs/` and finds every ```mermaid ... ``` block (skipping the
  gallery itself so it doesn't recurse).
- For each block: detects the kind (flowchart / sequence / state / er),
  finds the H2 above it for the title, and the page H1 for context.
- Buckets each diagram by source-folder convention (ecosystem / sd-billing
  / sd-cs / architecture / data / modules / team-workflow).
- Writes one page per bucket to docs/diagrams/<slug>.md plus a
  docs/diagrams/index.md cover page.

Re-run on every PR that adds, removes, or edits a Mermaid block in any
docs page. The originating pages keep their Mermaid blocks; this script
just produces the grouped gallery view.
"""

import os, re
from collections import defaultdict, Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS = os.path.join(ROOT, "docs")
OUT  = os.path.join(DOCS, "diagrams")
os.makedirs(OUT, exist_ok=True)


def discover():
    diagrams = []
    for root, _, files in os.walk(DOCS):
        for fn in files:
            if not fn.endswith(".md"):
                continue
            path = os.path.join(root, fn)
            rel = os.path.relpath(path, DOCS).replace("\\", "/")
            if rel.startswith("diagrams/"):
                continue
            if rel.startswith("data/diagrams-"):
                continue
            txt = open(path, encoding="utf-8").read()
            for m in re.finditer(r"```mermaid\n(.*?)\n```", txt, re.S):
                head = txt[:m.start()]
                h = re.findall(r"^(#{1,3})\s+(.+)$", head, re.M)
                section = h[-1][1] if h else fn
                h1 = re.search(r"^# (.+)$", txt, re.M)
                page_title = h1.group(1) if h1 else rel
                first = m.group(1).split("\n", 1)[0].strip()
                kind = (
                    "flowchart" if first.startswith("flowchart") else
                    "sequence"  if first.startswith("sequenceDiagram") else
                    "state"     if first.startswith("stateDiagram") else
                    "er"        if first.startswith("erDiagram") else
                    "other"
                )
                diagrams.append({
                    "rel": rel,
                    "page_title": page_title,
                    "section": section,
                    "kind": kind,
                    "block": m.group(1).rstrip(),
                })
    return diagrams


def bucket(d):
    r = d["rel"]
    s = d["section"].lower()
    pt = d["page_title"].lower()
    if r.startswith("ecosystem"): return "01-ecosystem"
    if r.startswith("sd-billing") or r.startswith("billing"): return "02-sd-billing"
    if r.startswith("sd-cs"): return "03-sd-cs"
    if r.startswith("architecture"): return "04-sd-main-system"
    if r.startswith("devops"): return "04-sd-main-system"
    if r.startswith("data"): return "05-data"
    if r.startswith("modules"): return "06-sd-main-features"
    if "workflow" in pt or "workflow" in s or r.startswith("team/workflow") or r.startswith("team/rag"):
        return "07-workflows"
    return "99-other"


META = {
    "01-ecosystem":       dict(pos=1, title="Ecosystem",                  slug="ecosystem",
        blurb="Three-project map of the SalesDoctor platform. Use these diagrams to orient new hires before they dive into any single project."),
    "02-sd-billing":      dict(pos=2, title="sd-billing",                 slug="sd-billing",
        blurb="Subscription billing — licensing, payments (Click/Payme/Paynet/MBANK), distributor settlement, dunning."),
    "03-sd-cs":           dict(pos=3, title="sd-cs (HQ)",                 slug="sd-cs",
        blurb="Head-office app reading from many dealer DBs to produce consolidated reports."),
    "04-sd-main-system":  dict(pos=4, title="sd-main · System design",   slug="sd-main-system",
        blurb="Tier-level architecture of sd-main — HTTP, app tier, MySQL, Redis (3 DBs), queue, cron, file storage."),
    "05-data":            dict(pos=5, title="Data · ERDs",               slug="data",
        blurb="Two ERDs side-by-side: the conceptual intent and the truth-from-the-code (generated from declared Yii relations)."),
    "06-sd-main-features":dict(pos=6, title="sd-main · Feature flows",   slug="sd-main-features",
        blurb="Per-module feature flows for everyday operations in sd-main."),
    "07-workflows":       dict(pos=7, title="Process workflows",         slug="workflows",
        blurb="Operating-process diagrams that aren't app-feature flows."),
    "99-other":           dict(pos=99, title="Other",                    slug="other",
        blurb="Cross-cutting diagrams that don't fit a single project bucket."),
}


def main():
    diagrams = discover()
    buckets = defaultdict(list)
    for d in diagrams:
        buckets[bucket(d)].append(d)

    # Per-bucket page
    for key, items in buckets.items():
        meta = META[key]
        fname = os.path.join(OUT, f"{meta['slug']}.md")
        with open(fname, "w") as f:
            f.write("---\n")
            f.write(f"sidebar_position: {meta['pos']}\n")
            f.write(f"title: \"{meta['title']}\"\n")
            f.write("audience: All team members\n")
            f.write(f"summary: \"{meta['blurb']}\"\n")
            f.write(f"topics: [diagrams, {meta['slug'].replace('-', ', ')}]\n")
            f.write("---\n\n")
            f.write(f"# {meta['title']} — diagram gallery\n\n")
            f.write(f"{meta['blurb']}\n\n")
            f.write(f"All {len(items)} diagrams in this group, drawn inline.\n\n")
            f.write("## Index\n\n")
            f.write("| # | Title | Kind | Source page |\n|---|-------|------|-------------|\n")
            for i, d in enumerate(items, 1):
                page_path = "/docs/" + d["rel"].replace(".md", "")
                f.write(f"| {i:02d} | [{d['section']}](#d-{i:02d}) | `{d['kind']}` | [{d['rel'].replace('.md','')}]({page_path}) |\n")
            f.write("\n")
            for i, d in enumerate(items, 1):
                f.write(f"## {i:02d}. {d['section']} {{#d-{i:02d}}}\n\n")
                page_path = "/docs/" + d["rel"].replace(".md", "")
                f.write(f"- **Kind**: `{d['kind']}`\n")
                f.write(f"- **Source page**: [{d['rel'].replace('.md','')}]({page_path})\n")
                f.write(f"- **Originating section**: {d['section']}\n\n")
                f.write("```mermaid\n")
                f.write(d["block"])
                f.write("\n```\n\n")

    # Index page
    with open(os.path.join(OUT, "index.md"), "w") as f:
        f.write("---\n")
        f.write("sidebar_position: 0\n")
        f.write("title: Diagram gallery\n")
        f.write("slug: /diagrams\n")
        f.write("audience: All team members\n")
        f.write("summary: \"Single entry point to every diagram in the SalesDoctor docs. Grouped by project / concern; each diagram is rendered inline.\"\n")
        f.write("topics: [diagrams, gallery, mermaid, index]\n")
        f.write("---\n\n")
        f.write("# Diagram gallery\n\n")
        f.write("This is the canonical home for every diagram in the docs. Each group has its own page with the diagrams drawn inline.\n\n")
        f.write("## Groups\n\n")
        f.write("| # | Group | Page | Count |\n|---|-------|------|-------|\n")
        for key, m in sorted(META.items(), key=lambda kv: kv[1]["pos"]):
            if key not in buckets:
                continue
            f.write(f"| {m['pos']:02d} | **{m['title']}** | [open](./{m['slug']}.md) | {len(buckets[key])} |\n")
        f.write("\n")
        f.write("## Visual taxonomy used in every flowchart\n\n")
        f.write("| Colour | Class | Meaning |\n|--------|-------|---------|\n")
        f.write("| Blue   | `action`   | Standard step |\n")
        f.write("| Amber  | `approval` | Requires review / approval |\n")
        f.write("| Green  | `success`  | Final OK / closed state |\n")
        f.write("| Red    | `reject`   | Failed / cancelled final state |\n")
        f.write("| Grey   | `external` | External system (1C, Didox, gateway, FCM) |\n")
        f.write("| Purple | `cron`     | Scheduled / time-driven |\n\n")
        f.write("(Defined in [Workflow design standards](/docs/team/workflow-design).)\n\n")
        f.write(f"## Stats\n\n- **{len(diagrams)}** diagrams total\n")
        for k, n in sorted(Counter(d["kind"] for d in diagrams).items()):
            f.write(f"- **{n}** `{k}` diagrams\n")
        f.write("\n## Refresh procedure\n\n")
        f.write("This gallery is generated by `sd-docs/scripts/render-diagram-gallery.py`. Re-run after editing any diagram source on the original page:\n\n")
        f.write("```bash\npython3 sd-docs/scripts/render-diagram-gallery.py\n```\n")

    print(f"Wrote {len(buckets)} bucket pages + index in {OUT}")


if __name__ == "__main__":
    main()
