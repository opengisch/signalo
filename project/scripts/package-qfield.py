#!/usr/bin/python3
"""Package the signalo project for QField, headlessly.

Does what the QFieldSync "Package for QField" dialog does, without the dialog, so the
mobile project is built identically every time and can be produced in CI. The per-layer
QFieldSync actions already authored into signalo.qgs decide what happens to each layer;
this script only drives the conversion.

Of note for the sign symbology: the PostgreSQL layer "Vue signal (symbologie)" is marked
`remove` and is dropped from the package, while the virtual layer
"Vue signal (symbologie hors ligne)" is marked `no_action` and is carried over untouched,
so it recomputes over the offlined GeoPackage copies. Run check-qfield-package.py
afterwards to assert that actually happened.

Needs libqfieldsync, which the qgis compose image ships (docker/qgis/Dockerfile):

    docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
        /usr/src/project/scripts/package-qfield.py \
        /usr/src/project/signalo.qgs /usr/src/qfield-package
"""

import argparse
import json
import shutil
import sys
from pathlib import Path

from libqfieldsync.offline_converter import ExportType, OfflineConverter
from libqfieldsync.offliners import QgisCoreOffliner
from qgis.core import (
    QgsApplication,
    QgsCoordinateReferenceSystem,
    QgsOfflineEditing,
    QgsProject,
)

sys.path.insert(0, str(Path(__file__).parent))
from signalo_symbology import symbology_digest  # noqa: E402

# Written next to the package so check-qfield-package.py can assert nothing was lost.
MANIFEST_NAME = "signalo-package.json"


def attachment_dirs(project):
    """Directories copied into the package, read exactly as the cloud worker reads them.

    QFieldCloud's packaging worker does:

        attachment_dirs, _ = project.readListEntry("QFieldSync", "attachmentDirs", ["DCIM"])
        data_dirs, _ = project.readListEntry("QFieldSync", "dataDirs", [])
        OfflineConverter(..., attachment_dirs=attachment_dirs + data_dirs, ...)

    and passes no dirs_to_copy, so OfflineConverter copies precisely these. This script
    mirrors that on purpose. It used to pass its own dirs_to_copy listing every project
    subdirectory, which made a cable package that contained images/ while a cloud package
    of the same project did not -- so the checks here passed and the field still saw no
    signs. Reading the same project setting is what keeps the two packages comparable.

    images/ therefore has to be declared in QFieldSync/dataDirs; the sign symbology
    resolves its SVGs relative to the project, and a package without images/ beside the
    project draws nothing at all while looking perfectly healthy.
    """
    dirs, _ = project.readListEntry("QFieldSync", "attachmentDirs", ["DCIM"])
    data, _ = project.readListEntry("QFieldSync", "dataDirs", [])
    return dirs + data


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project")
    parser.add_argument("output_dir")
    parser.add_argument(
        "--title", default="", help="packaged project title shown in QField"
    )
    args = parser.parse_args()

    app = QgsApplication([], False)
    app.setPrefixPath("/usr", True)
    app.initQgis()

    project = QgsProject.instance()
    if not project.read(args.project):
        sys.exit(f"cannot read project {args.project}")

    # The offline symbology layer is part of the committed project -- it has to be, because
    # QFieldCloud packages what you push and has no hook we could run. Packaging just drops
    # the PostgreSQL layer beside it, per the QFieldSync actions set in the project.
    virtual = next(
        (l for l in project.mapLayers().values() if l.providerType() == "virtual"), None
    )
    if virtual is None:
        sys.exit(
            "no virtual layer in the project -- run "
            "project/virtual_layers/sign_symbol_layer.py against it first"
        )

    manifest = {
        "virtual_layer_name": virtual.name(),
        "virtual_layer_id": virtual.id(),
        "virtual_layer_features": virtual.featureCount(),
        "symbology_digest": symbology_digest(virtual),
        "source_layer_count": len(project.mapLayers()),
    }

    # A fresh directory each time: a stale data.gpkg would be silently reused.
    output_dir = Path(args.output_dir)
    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True)
    export_filename = output_dir / Path(args.project).name

    converter = OfflineConverter(
        project,
        str(export_filename),
        # The area of interest is only read when the project sets offlineCopyOnlyAoi or
        # createBaseMap. signalo sets neither, so an empty one packages every feature.
        "",
        QgsCoordinateReferenceSystem(),
        attachment_dirs(project),
        QgisCoreOffliner(offline_editing=QgsOfflineEditing()),
        ExportType.Cable,
        export_title=args.title,
    )
    converter.warning.connect(lambda title, body: print(f"WARNING {title}: {body}"))

    # No need to reopen the source project afterwards in a one-shot script.
    converter.convert(reload_original_project=False)

    if not export_filename.is_file():
        sys.exit(f"packaging produced no project at {export_filename}")

    # QGIS leaves a ~3.6 MB `.qgs~` backup behind when it rewrites the project; there is
    # no reason to ship it to a phone.
    for backup in output_dir.glob("*~"):
        backup.unlink()

    (output_dir / MANIFEST_NAME).write_text(json.dumps(manifest, indent=2))

    print(f"packaged project : {export_filename}")
    print(
        f"virtual layer    : {manifest['virtual_layer_features']} symbols before packaging"
    )
    for path in sorted(output_dir.iterdir()):
        print(f"  {path.name} ({path.stat().st_size} bytes)")

    app.exitQgis()


if __name__ == "__main__":
    main()
