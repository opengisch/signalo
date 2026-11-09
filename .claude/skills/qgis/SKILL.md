---
name: qgis
description: "Run and test the QGIS project of signalo headless in Docker: the stack with demo data, PyQGIS on project/signalo.qgs, a render of the map to PNG to check the symbology, the tests."
---

# QGIS in Docker

The `qgis` service of `docker-compose.yml` is `qgis/qgis-slim`: QGIS 4.2 and its Python, without the desktop. It
mounts the repository at `/usr/src`, and reaches the database through the service `pg_signalo` of
`datamodel/.docker/.pg_service.conf`, which every layer of `project/signalo.qgs` names. There is no QGIS window:
look at the map through a render. `docker compose run --rm qgis …` needs no profile, and takes a few seconds.

## Start

- Reuse the stack when it runs and has data:
  ```bash
  docker compose exec db psql -U postgres signalo -c 'select count(*) from signalo_db.support'
  ```
- Else `scripts/run-docker.sh -d`: it removes the stack and its volumes, then installs the datamodel with the demo
  data of Lausanne, 15 supports. `-l <n>` adds n times every official sign, for load.

## Look at the map

`render.py` draws the layers checked in the layer tree of the project, as QGIS does, without the online base maps
unless `--background`, to `build/qgis/<out>.png`. Read the PNG with `Read`.

```bash
docker compose run --rm qgis python3 /usr/src/.claude/skills/qgis/render.py \
  --support <id> --scale 250 --style 01-danger --out danger
```

- Without `--support` or `--bbox` (EPSG:2056), it draws all the supports. `--scale` is 250 around a support.
- `--style` sets a named style, such as `01-danger`, on the layers that have it: the two symbology layers.
- It prints the PNG, its scale and extent, the layers drawn at that scale, and the errors of the render. A blank
  picture, or one without signs, is a failed check, not a passed one.

## Run PyQGIS

Any script, from the repository at `/usr/src`; `-T` to give it the heredoc:

```bash
docker compose run --rm -T qgis python3 - <<'EOF'
import os
os.environ["QT_QPA_PLATFORM"] = "offscreen"
from qgis.core import QgsApplication, QgsProject
app = QgsApplication([], False)
app.initQgis()
project = QgsProject.instance()
assert project.read("/usr/src/project/signalo.qgs")
print(project.mapLayersByName("Support")[0].featureCount())
EOF
```

## Tests

| What                                   | Command                                                                                                                  |
|----------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| The datamodel, the project file        | `docker compose run --rm --entrypoint pytest pum`                                                                        |
| The virtual layer matches the view     | `docker compose run --rm qgis python3 /usr/src/project/virtual_layers/diff_vw.py /usr/src/project/signalo.qgs`           |
| Write the virtual layer in the project | `docker compose run --rm qgis python3 /usr/src/project/virtual_layers/sign_symbol_layer.py /usr/src/project/signalo.qgs` |
| The atlas of the official signs        | `docker compose run --rm qgis qgis_process run native:atlaslayouttopdf --PROJECT_PATH=/usr/src/project/signalo.qgs LAYOUT="official sign" OUTPUT=/usr/src/build/qgis/atlas.pdf` |

`project/virtual_layers/README.md` explains the virtual layer and its scripts.

## Gotchas

- The QGIS of Docker is newer than the 3.44 LTR the users run. Never save the project from a script: a save of
  QGIS rewrites the whole file. Only `sign_symbol_layer.py` writes it, and canonicalises it.
- The group `Symbologie` holds the signs twice, mutually exclusive: `Vue signal (symbologie hors ligne)`, the
  virtual layer QField gets, is checked; `Vue signal (symbologie)`, from PostgreSQL, draws below 1:5'000 only.
- To render in a script, wait for the job in a `QEventLoop`, never with `waitForFinished()`: the virtual layer reads
  its source layers through the main thread, and the render hangs, idle.
- The signs are SVGs of `project/images`, found through the path of the project: read it from `/usr/src/project`.
- On stderr, `QFont::setPointSizeF`, `qt.svg … #gridpattern`, `QThreadStorage` and the warning on the version of the
  project are noise.
- The image has DejaVu fonts only: text in Arial, as in the layout of the atlas, draws in DejaVu Sans.
- `run-docker.sh` runs `docker compose down -v`: it wipes the database.
- The container runs as root: files it writes in the checkout belong to root on Linux.
