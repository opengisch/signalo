# Offline sign symbology (QGIS Virtual Layer)

Sign symbols are drawn from `signalo_app.vw_sign_symbol`, which computes the whole visual
arrangement of signs on a support: recto/verso duplication, stacking order, vertical shift,
group height and width, azimuth rectification and which SVG to draw.

That is a *database* view, so QFieldSync packages it as a frozen GeoPackage snapshot: a sign
added, deleted or reordered in the field keeps the arrangement it had at packaging time.

A QGIS Virtual Layer runs the equivalent SQL over the project's own sign/frame/azimut/support
layers. QFieldSync carries virtual layers into the package untouched (`no_action` is their
only packaging option) and the offliners keep layer ids stable, so the SQL keeps resolving
against the offline GeoPackage copies and the symbology recomputes in the field.

## Where the layer lives

**The layer is committed inside `project/signalo.qgs`.** It has to be: QFieldCloud packages
the project you push and runs no plugins, so there is no hook that could add it later.

It sits in the mutually exclusive layer-tree group **Symbologie**, next to the PostgreSQL
layer `Vue signal (symbologie)` it replaces. Only one of the two draws at a time, which is
why no platform filter is needed. The virtual layer is the checked one, so the desktop shows
what the field will get; tick the other to compare. Packaging drops the PostgreSQL layer
(`action` and `cloud_action` are both `remove`).

While both layers exist, a symbology change has to be made twice or the comparison is
meaningless.

## Files

- `vw_sign_symbol.sql` — the static SQLite port of the view, and the readable copy of the
  SQL. Sources are referenced by the aliases bound in the layer URI
  (`layer_ref=<layerid>:<alias>`), so the file needs no substitution step.
- `sign_symbol_layer.py` — the generator. Run it to write the layer into a project:
  definition, styles, QFieldSync actions, layer-tree placement. Re-running refreshes the
  existing layer in place rather than adding a second one.
- `diff_vw.py` — asserts the virtual layer matches the PostgreSQL view row for row, and that
  its feature ids come out distinct. Run in CI. It builds its own layer from
  `vw_sign_symbol.sql`, so it compares the *file* against the database.

## Usage

The SQL lives twice — in `vw_sign_symbol.sql` and percent-encoded inside the `.qgs`, because
that is the only way QGIS stores a virtual layer's query. **After editing the SQL, regenerate
the project and commit both.** `test/test_virtual_layer_sql.py` fails when they diverge.

```sh
# regenerate the layer in the project after editing vw_sign_symbol.sql
docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
    python3 /usr/src/project/virtual_layers/sign_symbol_layer.py \
    /usr/src/project/signalo.qgs

# does the virtual layer still match the view?
docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
    python3 /usr/src/project/virtual_layers/diff_vw.py /usr/src/project/signalo.qgs
```

Packaging itself is done from the QFieldSync plugin, by cable or through QFieldCloud; nothing
here has to run first. One project setting matters: `images` must stay in the project's
QFieldSync attachment directories, or the package ships without the sign SVGs and draws
nothing. `test/test_qfield_packaging.py` guards it.

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
column because it is the stable key `diff_vw.py` compares the two layers on, while the
same script asserts the feature ids come out distinct.

### Join the `*_n` CTEs, never the source layers directly

Joining `sign` to `frame` on `frame.id = sign.fk_frame` matches **0 of 34 rows** — no
error, just a full set of features whose joined columns are all NULL.

The values are fine; they are never compared. The provider tells SQLite it can satisfy an
`=` on a layer's primary key itself (`vtableBestIndex`, `idxNum = 1`), and then honours it
with `setFilterFid( sqlite3_value_int( … ) )` — coercing the key to an integer feature id.
For a uuid that is 0, so the join asks for feature 0 and gets nothing. SQLite is told to
omit its own check, so the wrong rows pass silently.

Wrapping each side in `CAST(... AS TEXT)` blocks that push-down, which is why it fixes the
result — but it also stops SQLite using an index, so the join falls back to fetching
features one row at a time. A 34-sign project did not finish in nine minutes that way.

The `*_n AS MATERIALIZED` CTEs cast each source's keys once, up front, so everything
downstream joins plain normalised text columns: correct *and* indexable. Text and integer
keys (`official_sign.id`, `marker_type.id`) never had the problem, but go through the same
CTEs so there is one pattern to follow rather than two.

**This is fixed upstream** — QGIS `5cb8ed11a09` only uses a primary key column for the
push-down when it is an integer. The fix is in QGIS master and 4.2, but not in the 3.44 the
`qgis` compose image pins, and QField embeds its own QGIS. Once both are past 3.44 these
CTEs can collapse back into plain joins.

Those CTEs double as the SQL's dependency manifest — `test/test_virtual_layer_sql.py` reads
the column lists out of them and fails if one no longer exists in `signalo_db`.
