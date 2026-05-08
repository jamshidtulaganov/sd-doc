#!/usr/bin/env python3
"""
Parse a `mysqldump --no-data` SQL file into structured JSON.

Reads SQL from stdin, writes JSON to stdout. Each table becomes:

    {
      "<table_name>": {
        "engine":    "InnoDB",
        "charset":   "utf8mb4",
        "collation": "utf8mb4_general_ci",
        "cols":      [{name, type, nullable, default}, ...],
        "pks":       ["(`ID`)"],
        "uniques":   ["UNIQUE KEY `idx_xx` ..."],
        "indexes":   ["KEY `idx_xx` ..."],
        "fks":       ["CONSTRAINT `fk_xx` FOREIGN KEY ..."],
      }
    }

Usage:
    python3 sd-docs/scripts/parse-live-schema.py \\
        < sd-docs/static/data/live-schema.sql \\
        > sd-docs/static/data/live-schema-parsed.json
"""

import re, sys, json

sql = sys.stdin.read()
tables = {}

for m in re.finditer(r"CREATE TABLE `(\w+)` \((.*?)\) ENGINE=(\w+)([^;]*);", sql, re.S):
    name = m.group(1)
    body = m.group(2)
    engine = m.group(3)
    suffix = m.group(4)
    cs = re.search(r"CHARSET=([\w\d]+)", suffix)
    coll = re.search(r"COLLATE=([\w\d_]+)", suffix)

    cols, pks, uniques, indexes, fks = [], [], [], [], []
    for line in body.split("\n"):
        line = line.rstrip(",").strip()
        if not line:
            continue
        if line.startswith("PRIMARY KEY"):
            pks.append(line[len("PRIMARY KEY"):].strip())
        elif line.startswith("UNIQUE KEY"):
            uniques.append(line)
        elif line.startswith("KEY "):
            indexes.append(line)
        elif line.startswith("CONSTRAINT"):
            fks.append(line)
        elif line.startswith("`"):
            colname = re.match(r"`(\w+)`", line).group(1)
            type_match = re.match(r"`\w+`\s+(\S+(?:\([^)]*\))?(?:\s+unsigned)?)", line)
            ctype = type_match.group(1) if type_match else "?"
            nullable = "NULL" if "NOT NULL" not in line else "NOT NULL"
            default = ""
            dm = re.search(r"DEFAULT\s+('(?:[^']|'')*'|NULL|CURRENT_TIMESTAMP|[^,\s]+)", line)
            if dm:
                default = dm.group(1)
            cols.append({
                "name": colname, "type": ctype,
                "nullable": nullable, "default": default,
            })

    tables[name] = {
        "engine": engine,
        "charset": cs.group(1) if cs else None,
        "collation": coll.group(1) if coll else None,
        "cols": cols,
        "pks": pks,
        "uniques": uniques,
        "indexes": indexes,
        "fks": fks,
    }

json.dump(tables, sys.stdout, indent=2)
sys.stdout.write("\n")
print(f"Parsed {len(tables)} tables", file=sys.stderr)
