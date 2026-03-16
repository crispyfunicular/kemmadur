"""Exporte les flashcards depuis la base SQLite vers web/flashcards.js."""

import json
import os
import sqlite3

import aiosql


def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    db_path = os.path.join(base_dir, "kemmadur.db")
    sql_path = os.path.join(base_dir, "requetes.sql")
    out_dir = os.path.join(base_dir, "web")
    out_path = os.path.join(out_dir, "flashcards.js")

    os.makedirs(out_dir, exist_ok=True)

    queries = aiosql.from_path(sql_path, "sqlite3")
    conn = sqlite3.connect(db_path)

    categories = ["declencheurs", "nombres", "nom_adjectif", "articles", "article_nom_adj"]
    data = {}

    for cat in categories:
        query_fn = getattr(queries, cat)
        rows = list(query_fn(conn))
        data[cat] = [list(row) for row in rows]
        print(f"  {cat}: {len(rows)} flashcards")

    conn.close()

    total = sum(len(v) for v in data.values())
    js_content = f"// Généré automatiquement — {total} flashcards\nwindow.FLASHCARDS = {json.dumps(data, ensure_ascii=False, indent=2)};\n"

    with open(out_path, "w", encoding="utf-8") as f:
        f.write(js_content)

    print(f"\n✅ {out_path} généré ({total} flashcards)")


if __name__ == "__main__":
    main()
