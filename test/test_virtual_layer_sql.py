import os
import re
import unittest
from pathlib import Path

import psycopg

SQL_PATH = (
    Path(__file__).resolve().parents[1]
    / "project"
    / "virtual_layers"
    / "vw_sign_symbol.sql"
)

# Alias used inside vw_sign_symbol.sql -> the signalo_db table it is bound to by the
# layer_ref= entries in the virtual layer URI (see project/virtual_layers/sign_symbol_layer.py).
SOURCE_TABLES = {
    "sign": "sign",
    "frame": "frame",
    "azimut": "azimut",
    "support": "support",
    "official_sign": "vl_official_sign",
    "user_sign": "vl_user_sign",
    "marker_type": "vl_marker_type",
}

# Each `<alias>_n AS MATERIALIZED ( SELECT ... FROM <alias> )` CTE is the complete list of
# columns the virtual layer reads from that source, so the CTEs double as a manifest.
NORMALISING_CTE = re.compile(
    r"(?P<alias>\w+)_n AS MATERIALIZED \((?P<body>.*?)\n\s*FROM (?P<source>\w+)\n\s*\)",
    re.S,
)


def referenced_columns():
    """alias -> set of source columns the virtual layer SQL depends on."""
    sql = SQL_PATH.read_text(encoding="utf-8")
    found = {}
    for match in NORMALISING_CTE.finditer(sql):
        body = match.group("body")
        body = body[body.index("SELECT") + len("SELECT") :]
        # strip CAST(x AS TEXT) wrappers and "AS alias" tails, then take bare identifiers
        body = re.sub(r"CAST\(\s*(\w+)\s+AS\s+\w+\s*\)", r"\1", body)
        body = re.sub(r"\bAS\s+\w+", "", body)
        columns = {c.strip() for c in body.replace("\n", " ").split(",") if c.strip()}
        found[match.group("source")] = columns
    return found


class TestVirtualLayerSql(unittest.TestCase):
    """The offline symbology virtual layer must not drift from the data model.

    project/virtual_layers/vw_sign_symbol.sql is a hand-maintained SQLite port of
    signalo_app.vw_sign_symbol. Nothing in the database fails when a column it reads is
    renamed or dropped -- the layer just silently stops drawing signs in QField -- so the
    dependency is asserted here instead.
    """

    @classmethod
    def setUpClass(cls):
        pg_service = os.environ.get("PGSERVICE") or "signalo"
        cls.conn = psycopg.connect(f"service={pg_service}")

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def columns_of(self, table):
        with self.conn.cursor() as cur:
            cur.execute(
                "SELECT column_name FROM information_schema.columns"
                " WHERE table_schema = 'signalo_db' AND table_name = %s",
                (table,),
            )
            return {row[0] for row in cur.fetchall()}

    def test_every_source_is_mapped(self):
        self.assertEqual(
            set(referenced_columns()),
            set(SOURCE_TABLES),
            "a normalising CTE was added or removed without updating SOURCE_TABLES",
        )

    def test_referenced_columns_exist(self):
        for alias, columns in sorted(referenced_columns().items()):
            table = SOURCE_TABLES[alias]
            available = self.columns_of(table)
            self.assertTrue(available, f"signalo_db.{table} not found")
            missing = columns - available
            self.assertFalse(
                missing,
                f"vw_sign_symbol.sql reads signalo_db.{table}.{{{', '.join(sorted(missing))}}}"
                " which no longer exists",
            )

    def test_uid_is_not_the_text_pk(self):
        sql = SQL_PATH.read_text(encoding="utf-8")
        self.assertIn("AS _vl_fid", sql)
        self.assertIn("ROW_NUMBER() OVER (ORDER BY id, _verso) AS _vl_fid", sql)


if __name__ == "__main__":
    unittest.main()
