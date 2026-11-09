"""
Render the map of project/signalo.qgs to a PNG, headless, to look at the symbology: the layers checked in
the layer tree, as QGIS draws them, without the online base maps unless --background.

Run it in the qgis service, on a database with data (see SKILL.md):
`docker compose run --rm qgis python3 /usr/src/.claude/skills/qgis/render.py [--support <id>] [--scale <n>]`.
The PNG lands in build/qgis/, its path, the layers drawn and the errors of the render on stdout.
"""

import argparse
import os
import sys
from pathlib import Path

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

from qgis.core import (  # noqa: E402
    Qgis,
    QgsApplication,
    QgsDataSourceUri,
    QgsExpressionContext,
    QgsExpressionContextUtils,
    QgsFeatureRequest,
    QgsMapRendererParallelJob,
    QgsMapSettings,
    QgsProject,
    QgsRectangle,
)
from qgis.PyQt.QtCore import QEventLoop, QSize  # noqa: E402
from qgis.PyQt.QtGui import QColor  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
PROJECT = ROOT / "project/signalo.qgs"
OUT = ROOT / "build/qgis"
# the online base maps, slow and not what is being checked
BACKGROUND = (Qgis.LayerType.Raster, Qgis.LayerType.VectorTile)


def arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    where = parser.add_mutually_exclusive_group()
    where.add_argument("--support", help="id of a support to center on")
    where.add_argument("--bbox", help="xmin,ymin,xmax,ymax in EPSG:2056")
    parser.add_argument(
        "--scale",
        type=float,
        help="1:<scale>, 250 around a support, else that of the extent",
    )
    parser.add_argument(
        "--style",
        help="named style to set on the layers that have it, such as 01-danger",
    )
    parser.add_argument(
        "--background", action="store_true", help="draw the online base maps too"
    )
    parser.add_argument("--size", default="1200x900", help="<width>x<height> in px")
    parser.add_argument("--out", default="map", help="name of the PNG in build/qgis")
    return parser.parse_args()


def table_layer(project: QgsProject, table: str):
    for layer in project.mapLayers().values():
        uri = QgsDataSourceUri(layer.source())
        if layer.providerType() == "postgres" and uri.table() == table:
            return layer
    sys.exit(f"no layer of the table {table} in the project")


def visible_layers(project: QgsProject, background: bool) -> list:
    """The layers checked in the tree, groups included, top first, as the canvas draws them."""
    root = project.layerTreeRoot()
    checked = {node.layerId() for node in root.findLayers() if node.isVisible()}
    return [
        layer
        for layer in root.layerOrder()
        if layer.id() in checked
        and layer.isSpatial()
        and (background or layer.type() not in BACKGROUND)
    ]


def at_scale(center, scale: float, settings: QgsMapSettings) -> QgsRectangle:
    """The extent of the output size at 1:scale, in metres, those of EPSG:2056."""
    # computeExtentForScale of QgsMapSettings gives a square, which the output size then widens
    metres = scale * 0.0254 / settings.outputDpi() / 2
    width = settings.outputSize().width() * metres
    height = settings.outputSize().height() * metres
    return QgsRectangle(
        center.x() - width, center.y() - height, center.x() + width, center.y() + height
    )


def extent(args, project: QgsProject, settings: QgsMapSettings) -> QgsRectangle:
    if args.support:
        supports = table_layer(project, "support")
        request = QgsFeatureRequest().setFilterExpression(f"id = '{args.support}'")
        feature = next(supports.getFeatures(request), None)
        if feature is None:
            sys.exit(f"no support {args.support}")
        return at_scale(feature.geometry().asPoint(), args.scale or 250, settings)

    if args.bbox:
        rectangle = QgsRectangle(*(float(v) for v in args.bbox.split(",")))
    else:
        rectangle = table_layer(project, "support").extent()
        # room for the signs, drawn beside their support
        rectangle.scale(1.4)

    if args.scale:
        return at_scale(rectangle.center(), args.scale, settings)

    return rectangle


def main() -> None:
    args = arguments()
    app = QgsApplication([], True)
    app.initQgis()
    project = QgsProject.instance()
    if not project.read(str(PROJECT)):
        sys.exit(f"cannot read {PROJECT}: {project.error()}")

    for layer in project.mapLayers().values():
        if not layer.isValid():
            sys.stdout.write(f"invalid layer: {layer.name()}\n")
        if args.style and args.style in layer.styleManager().styles():
            layer.styleManager().setCurrentStyle(args.style)

    settings = QgsMapSettings()
    settings.setLayers(visible_layers(project, args.background))
    settings.setDestinationCrs(project.crs())
    settings.setTransformContext(project.transformContext())
    settings.setPathResolver(project.pathResolver())
    settings.setLabelingEngineSettings(project.labelingEngineSettings())
    context = QgsExpressionContext()
    context.appendScopes(
        [
            QgsExpressionContextUtils.globalScope(),
            QgsExpressionContextUtils.projectScope(project),
        ]
    )
    settings.setExpressionContext(context)
    settings.setBackgroundColor(QColor("white"))
    settings.setOutputDpi(96)
    width, height = (int(v) for v in args.size.split("x"))
    settings.setOutputSize(QSize(width, height))
    settings.setExtent(extent(args, project, settings))

    job = QgsMapRendererParallelJob(settings)
    # not waitForFinished: the virtual layer reads its source layers through the main thread,
    # which must run its events
    loop = QEventLoop()
    job.finished.connect(loop.quit)
    job.start()
    loop.exec()

    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / f"{args.out}.png"
    job.renderedImage().save(str(path))
    # the container runs as root, and the picture is for the user of the checkout
    for written in (OUT, path):
        os.chown(written, ROOT.stat().st_uid, ROOT.stat().st_gid)

    drawn = [
        layer.name()
        for layer in settings.layers()
        if layer.isInScaleRange(settings.scale())
    ]
    sys.stdout.write(f"{path.relative_to(ROOT)} at 1:{settings.scale():.0f}\n")
    sys.stdout.write(f"extent {settings.extent().toString(1)}\n")
    sys.stdout.write(f"layers {', '.join(drawn)}\n")
    for error in job.errors():
        sys.stdout.write(f"error {error.layerID}: {error.message}\n")


if __name__ == "__main__":
    main()
