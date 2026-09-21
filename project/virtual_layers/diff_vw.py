#!/usr/bin/python3
"""Compare the offline virtual layer against the PostgreSQL vw_sign_symbol view.

Both layers must agree row for row on every column they share, keyed on `pk`
(`<sign uuid>-<0|1>`), which is unique across the recto/verso duplication while the
bare sign `id` is not. Also guards the virtual layer's feature ids, which silently
collapse onto 0 if the uid column is ever pointed back at the text `pk`.

    docker compose run --rm qgis \
        xvfb-run /usr/src/project/virtual_layers/diff_vw.py /usr/src/project/signalo.qgs
"""

import argparse
import sys

from qgis.core import QgsApplication, QgsProject, QgsVectorLayer

sys.path.insert(0, str(__import__("pathlib").Path(__file__).parent))

KEY = "pk"
# Booleans arrive as bool from postgres and as 0/1 from the SQLite-backed virtual layer.
BOOLISH = (bool, int)


def normalise(value):
    if value is None or value == "" or repr(value) == "NULL":
        return None
    if isinstance(value, BOOLISH):
        return float(int(value))
    try:
        return round(float(value), 6)
    except (TypeError, ValueError):
        return str(value)


def rows(layer, fields):
    return {
        str(f[KEY]): {name: normalise(f[name]) for name in fields}
        for f in layer.getFeatures()
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project")
    args = parser.parse_args()

    app = QgsApplication([], False)
    app.setPrefixPath("/usr", True)
    app.initQgis()

    project = QgsProject.instance()
    if not project.read(args.project):
        sys.exit(f"cannot read project {args.project}")

    import sign_symbol_layer as R

    pg = R.find_by_table(project, R.SYMBOL_VIEW_TABLE)
    vl = QgsVectorLayer(R.build_definition(project).toString(), "vl", "virtual")
    if not vl.isValid():
        sys.exit(f"virtual layer invalid: {vl.error().summary()}")

    shared = sorted(
        ({f.name() for f in vl.fields()} & {f.name() for f in pg.fields()}) - {KEY}
    )
    pg_rows, vl_rows = rows(pg, shared), rows(vl, shared)

    only_pg = sorted(set(pg_rows) - set(vl_rows))
    only_vl = sorted(set(vl_rows) - set(pg_rows))
    differing = {
        pk: [
            (c, pg_rows[pk][c], vl_rows[pk][c])
            for c in shared
            if pg_rows[pk][c] != vl_rows[pk][c]
        ]
        for pk in sorted(set(pg_rows) & set(vl_rows))
    }
    differing = {k: v for k, v in differing.items() if v}

    fids = [f.id() for f in vl.getFeatures()]

    print(f"columns compared : {len(shared)}")
    print(f"postgres rows    : {len(pg_rows)}")
    print(f"virtual rows     : {len(vl_rows)}")
    print(f"only in postgres : {len(only_pg)} {only_pg[:5]}")
    print(f"only in virtual  : {len(only_vl)} {only_vl[:5]}")
    print(f"differing rows   : {len(differing)}")
    print(f"distinct fids    : {len(set(fids))} of {len(fids)}")

    for pk, diffs in list(differing.items())[:3]:
        print(
            f"  {pk}: " + ", ".join(f"{c} pg={a!r} vl={b!r}" for c, a, b in diffs[:4])
        )

    ok = not only_pg and not only_vl and not differing and len(set(fids)) == len(fids)
    print("\nPARITY OK" if ok else "\nPARITY FAILED")
    app.exitQgis()
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
