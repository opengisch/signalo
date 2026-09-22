"""Write the offline sign-symbology virtual layer into signalo.qgs.

This is a generator, not a runtime step: run it after editing vw_sign_symbol.sql and commit
the result. The layer has to be *in* the committed project, because QFieldCloud packages
what you push -- its worker runs a fixed step list around libqfieldsync and loads no plugins,
so there is no hook that could inject a layer the way the cable script once did.

That puts it alongside the PostgreSQL layer it replaces, in the mutually exclusive
`Symbologie` group: exactly one of the two ever draws, so no platform filter is needed and a
package opened on desktop renders normally. Whichever child is *checked* is what ships, since
packaging removes the PostgreSQL layer and nothing re-checks what is left -- so this script
leaves the virtual layer checked. Desktop then renders what the field will get, and ticking
the PostgreSQL one is how you compare them.

Both layers carry all 11 named styles for that comparison, which is the cost of the
transition: a symbology change has to be made twice until the PostgreSQL layer is deleted.
"""

import re
from pathlib import Path

from qgis.core import (
    QgsDataSourceUri,
    QgsMapLayer,
    QgsMapLayerDependency,
    QgsMapLayerStyle,
    QgsReadWriteContext,
    QgsVectorLayer,
    QgsVirtualLayerDefinition,
)
from qgis.PyQt.QtXml import QDomDocument

# SQL alias -> signalo_db table backing it. The aliases are what vw_sign_symbol.sql
# selects FROM; they are bound to real project layers through layer_ref= in the URI.
SOURCE_TABLES = {
    "sign": "sign",
    "frame": "frame",
    "azimut": "azimut",
    "support": "support",
    "official_sign": "vl_official_sign",
    "user_sign": "vl_user_sign",
    "marker_type": "vl_marker_type",
}

SYMBOL_VIEW_TABLE = "vw_sign_symbol"
VIRTUAL_LAYER_NAME = "Vue signal (symbologie hors ligne)"

# Layers whose edits must retrigger a recompute of the virtual layer.
REFRESH_ON = ("sign", "frame", "azimut", "support")

SQL_PATH = Path(__file__).with_name("vw_sign_symbol.sql")

# A saved style carries a copy of the layer's custom properties, so a style switch would
# otherwise restore whatever QFieldSync action was current when the style was saved --
# silently undoing the no_action set below. Packaging config is not symbology.
QFIELDSYNC_OPTION = re.compile(
    r'\s*<Option\b[^>]*\bname="QFieldSync/[^"]*"(?:[^>]*/>|[^>]*>.*?</Option>)', re.S
)

# The symbology builds its SVG paths relative to the project. QGIS resolves those against
# the project directory, but QField has a long history of failing to (QField #282, #299,
# #2287), which shows up as signs rendering without their image. Anchoring the path on
# @project_path makes it absolute at render time, on whatever device holds the package --
# a literal absolute path would be wrong the moment the package is copied anywhere.
# The same idiom is already used by the project's map tips and the atlas layout.
RELATIVE_IMAGE_PREFIX = "'images/' ||"
ANCHORED_IMAGE_PREFIX = "file_path(@project_path) || '/images/' ||"


def find_by_table(project, table):
    """Resolve a project layer by its PostgreSQL table name, not its display name."""
    for layer in project.mapLayers().values():
        if layer.providerType() != "postgres":
            continue
        if QgsDataSourceUri(layer.source()).table() == table:
            return layer
    raise RuntimeError(f"no postgres layer found for table {table!r}")


def build_definition(project):
    definition = QgsVirtualLayerDefinition()
    for alias, table in SOURCE_TABLES.items():
        definition.addSource(alias, find_by_table(project, table).id())
    definition.setQuery(SQL_PATH.read_text(encoding="utf-8"))
    # The uid column is read as int64 by the virtual layer provider, so it has to be the
    # integer surrogate rather than the text pk (which would collapse onto fid 0).
    definition.setUid("_vl_fid")
    definition.setGeometryField("support_geometry")
    definition.setGeometrySrid(2056)
    return definition


# Only the symbology travels. A whole-style copy also brings the PostgreSQL layer's field
# configuration, aliases, forms and attribute table setup -- roughly 23,500 lines
# describing 126 fields, most of which this layer does not even have. It is a render-only
# layer; none of that is meaningful on it.
STYLE_CATEGORIES = (
    QgsMapLayer.StyleCategory.Symbology | QgsMapLayer.StyleCategory.Symbology3D
)


def copy_styles(source, target):
    """Copy the symbology of every named style from the PostgreSQL layer.

    The SVG paths are anchored on @project_path on the way through: they are written
    relative to the project, and QField has a long history of failing to resolve those
    (QField #282, #299, #2287).
    """
    src_mgr, dst_mgr = source.styleManager(), target.styleManager()
    src_original, dst_original = src_mgr.currentStyle(), dst_mgr.currentStyle()

    for name in src_mgr.styles():
        src_mgr.setCurrentStyle(name)
        document = QDomDocument()
        source.exportNamedStyle(document, QgsReadWriteContext(), STYLE_CATEGORIES)
        style = QgsMapLayerStyle(
            document.toString().replace(RELATIVE_IMAGE_PREFIX, ANCHORED_IMAGE_PREFIX)
        )
        if not style.isValid():
            raise RuntimeError(f"style {name!r} did not export cleanly")

        if name in dst_mgr.styles():
            dst_mgr.setCurrentStyle(name)
            style.writeToLayer(target)
        else:
            dst_mgr.addStyle(name, style)

    src_mgr.setCurrentStyle(src_original)
    if dst_original in dst_mgr.styles():
        dst_mgr.setCurrentStyle(dst_original)
    return len(src_mgr.styles())


def add_to_project(project):
    """Create or refresh the virtual layer, style it, and place it in the layer tree.

    Returns (layer, style_count). The project is modified in memory only -- writing it is
    the caller's business.

    Re-running is the normal case, not the exception: the datasource carries the SQL, so
    every edit to vw_sign_symbol.sql has to be regenerated into the project. An existing
    layer is therefore refreshed in place with setDataSource, which keeps its id -- adding
    a second copy instead would leave the project with two symbology layers and only one
    of them current.
    """
    definition = build_definition(project).toString()
    existing = project.mapLayersByName(VIRTUAL_LAYER_NAME)
    if existing:
        layer, *duplicates = existing
        layer.setDataSource(definition, VIRTUAL_LAYER_NAME, "virtual")
        for duplicate in duplicates:
            project.removeMapLayer(duplicate.id())
    else:
        layer = QgsVectorLayer(definition, VIRTUAL_LAYER_NAME, "virtual")
        project.addMapLayer(layer, False)

    if not layer.isValid():
        raise RuntimeError(f"virtual layer is invalid: {layer.error().summary()}")

    pg_layer = find_by_table(project, SYMBOL_VIEW_TABLE)
    styles = copy_styles(pg_layer, layer)

    layer.setDependencies(
        {QgsMapLayerDependency(find_by_table(project, t).id()) for t in REFRESH_ON}
    )
    layer.setReadOnly(True)

    # Package the virtual layer, drop the PostgreSQL one it replaces. Both properties
    # matter: offline_converter reads `action` for a cable export and `cloud_action` for a
    # cloud one, and a layer left at the project default `offline` is packaged rather than
    # dropped -- verified, a cloud export shipped the PostgreSQL layer as a frozen copy.
    for prop in ("QFieldSync/action", "QFieldSync/cloud_action"):
        layer.setCustomProperty(prop, "no_action")
        pg_layer.setCustomProperty(prop, "remove")

    # Join the PostgreSQL layer inside the mutually exclusive "Symbologie" group, so only
    # one of the two ever draws and no platform filter is needed.
    root = project.layerTreeRoot()
    pg_node = root.findLayer(pg_layer.id())
    if root.findLayer(layer.id()) is None:
        parent = pg_node.parent() if pg_node else root
        parent.insertLayer(
            parent.children().index(pg_node) + 1 if pg_node else 0, layer
        )

    # Whichever child is checked is what ships: packaging removes the PostgreSQL layer and
    # nothing re-checks what is left, and the cloud worker has no hook that could. So the
    # virtual layer is the checked one, which also means the desktop renders what the field
    # will get.
    if (node := root.findLayer(layer.id())) is not None:
        node.setItemVisibilityChecked(True)
    if pg_node is not None:
        pg_node.setItemVisibilityChecked(False)

    return layer, styles


def main():
    """Write the virtual layer into a project file.

    Run this after changing vw_sign_symbol.sql, and commit the result -- the project
    carries the SQL percent-encoded in the layer's datasource, so the two drift otherwise.
    test/test_virtual_layer_sql.py fails when they do.

        docker compose run --rm -e QT_QPA_PLATFORM=offscreen qgis \
            python3 /usr/src/project/virtual_layers/sign_symbol_layer.py \
            /usr/src/project/signalo.qgs
    """
    import argparse

    from qgis.core import QgsApplication, QgsProject

    parser = argparse.ArgumentParser(description=main.__doc__)
    parser.add_argument("project")
    args = parser.parse_args()

    app = QgsApplication([], False)
    app.setPrefixPath("/usr", True)
    app.initQgis()

    project = QgsProject.instance()
    if not project.read(args.project):
        raise SystemExit(f"cannot read project {args.project}")

    layer, styles = add_to_project(project)
    print(f"virtual layer : {layer.name()} ({layer.id()})")
    print(f"features      : {layer.featureCount()}")
    print(f"styles        : {styles}")

    if not project.write():
        raise SystemExit("failed to write project")
    print(f"wrote {args.project}")
    app.exitQgis()


if __name__ == "__main__":
    main()
