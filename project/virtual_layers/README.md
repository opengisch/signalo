# Offline sign symbology (QGIS Virtual Layer)

Sign symbols are drawn from `signalo_app.vw_sign_symbol`, which computes the whole visual
arrangement of signs on a support: recto/verso duplication, stacking order, vertical shift,
group height and width, azimuth rectification and which SVG to draw.

That is a *database* view, so QFieldSync packages it as a frozen GeoPackage snapshot: a sign
added, deleted or reordered in the field keeps the arrangement it had at packaging time.

A QGIS Virtual Layer runs the equivalent SQL over the project's own sign/frame/azimut/support
layers. QFieldSync carries virtual layers into the package untouched (`no_action` is their
only cable-packaging option) and the offliners keep layer ids stable, so the SQL keeps
resolving against the offline GeoPackage copies and the symbology recomputes in the field.

## Files

- `vw_sign_symbol.sql` — the static SQLite port of the view. Sources are referenced by the
  aliases bound in the layer URI (`layer_ref=<layerid>:<alias>`), so the file needs no
  substitution step.
- `sign_symbol_layer.py` — builds the virtual layer: definition, styles, QFieldSync actions,
  layer-tree placement. Imported by the packaging script; it never writes a project itself.
- `diff_vw.py` — asserts the virtual layer matches the PostgreSQL view row for row. Run in CI.

## Usage

```sh
# does the virtual layer still match the view?
docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
    python3 /usr/src/project/virtual_layers/diff_vw.py /usr/src/project/signalo.qgs

# build the field package and check it
docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
    /usr/src/project/scripts/package-qfield.py \
    /usr/src/project/signalo.qgs /usr/src/qfield-package

docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
    /usr/src/project/scripts/check-qfield-package.py /usr/src/qfield-package/signalo.qgs
```

## Two rules for editing the SQL

Both look like pointless contortions. Each works around a behaviour of the QGIS virtual
layer provider, and undoing either gives you a layer that loads, reports the right feature
count, and is quietly wrong.

### The uid must be `_vl_fid`, never `pk`

QGIS feature ids are 64-bit integers, and this provider reads whatever column you name as
the uid straight through `columnInt64()` — it does not translate. (The PostgreSQL provider
keeps a key-to-id map, which is why `key='pk'` is fine on the database layer and fatal
here.)

`pk` is text, `<sign uuid>-<0|1>`, and SQLite turns text into an integer by taking the
leading digits and giving up at the first character that is not one:

```
'a1b2-0' -> 0      'b3c4-0' -> 0      '1a2b-0' -> 1
```

Every feature would land on one of a handful of ids. The attribute table still looks
correct, which is what makes it nasty — what breaks is identify, selection, and anything
that addresses a feature by id.

So the uid is `_vl_fid`, a `ROW_NUMBER()` over the final result. `pk` stays as an ordinary
column because it is the stable key `diff_vw.py` compares the two layers on, and
`check-qfield-package.py` asserts the feature ids come out distinct.

### Join the `*_n` CTEs, never the source layers directly

Through this provider, two identical uuid strings do not compare equal. Joining `sign` to
`frame` on `frame.id = sign.fk_frame` matches **0 of 34 rows** — no error, just a full set
of features whose joined columns are all NULL.

Casting both sides with `CAST(... AS TEXT)` fixes the comparison, but an expression in the
`ON` clause stops SQLite using an index, so it falls back to fetching features from the
provider one row at a time. A 34-sign project did not finish in nine minutes that way.

The `*_n AS MATERIALIZED` CTEs cast each source's keys once, up front, so everything
downstream joins plain normalised text columns: correct *and* indexable. Text and integer
keys (`official_sign.id`, `marker_type.id`) never had the problem, but go through the same
CTEs so there is one pattern to follow rather than two.

Those CTEs double as the SQL's dependency manifest — `test/test_virtual_layer_sql.py` reads
the column lists out of them and fails if one no longer exists in `signalo_db`.
