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

PG_VIEW_PATH = (
    Path(__file__).resolve().parents[1] / "datamodel" / "app" / "vw_sign_symbol.py"
)

# `WHEN sign.fk_sign_type = 12 THEN ...` -- the ladder deciding which image a sign gets.
SIGN_TYPE_BRANCH = re.compile(r"fk_sign_type\s*=\s*(\d+)")

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


class TestSignTypeParity(unittest.TestCase):
    """The sign-type branches must not drift between the two implementations.

    datamodel/app/vw_sign_symbol.py builds the PostgreSQL view and
    project/virtual_layers/vw_sign_symbol.sql the virtual layer, and both carry the same
    CASE ladder deciding which image a sign type gets. They are edited separately, so
    adding a type to one and forgetting the other is easy -- and invisible until someone
    in the field sees a sign with no image.

    diff_vw.py compares the two for real, but only over whatever rows the database holds,
    so it proves nothing about a type the data does not contain. Hence both a structural
    check here and a coverage check below.
    """

    def branches(self, path):
        return {
            int(n) for n in SIGN_TYPE_BRANCH.findall(path.read_text(encoding="utf-8"))
        }

    def test_both_implementations_branch_on_the_same_types(self):
        pg = self.branches(PG_VIEW_PATH)
        virtual = self.branches(SQL_PATH)
        self.assertTrue(pg, "no sign-type branches found in the PostgreSQL view")
        self.assertEqual(
            pg,
            virtual,
            f"sign types handled by the view but not the virtual layer: {sorted(pg - virtual)}; "
            f"handled by the virtual layer but not the view: {sorted(virtual - pg)}",
        )


class TestSignTypeCoverage(unittest.TestCase):
    """Every branched sign type must exist in the data, or diff_vw.py never compares it."""

    @classmethod
    def setUpClass(cls):
        pg_service = os.environ.get("PGSERVICE") or "signalo"
        cls.conn = psycopg.connect(f"service={pg_service}")

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def test_demo_data_exercises_every_branch(self):
        branched = {
            int(n)
            for n in SIGN_TYPE_BRANCH.findall(SQL_PATH.read_text(encoding="utf-8"))
        }
        with self.conn.cursor() as cur:
            cur.execute("SELECT DISTINCT fk_sign_type FROM signalo_db.sign")
            present = {row[0] for row in cur.fetchall() if row[0] is not None}
        missing = sorted(branched - present)
        self.assertFalse(
            missing,
            f"no sign in the database uses type(s) {missing}, so the parity check never "
            "compares that branch -- add one to datamodel/demo_data/sign_content.sql",
        )


if __name__ == "__main__":
    unittest.main()
