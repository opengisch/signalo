"""Build the offline sign-symbology virtual layer.

This layer is deliberately NOT part of the committed project. signalo.qgs carries only the
PostgreSQL symbology layer, and this one is created in memory at packaging time by
project/scripts/package-qfield.py.

It used to live in the project, and cost 28% of signalo.qgs to do so -- almost entirely a
second copy of the 11 named styles, which then had to be kept in step with the original.
It also had to be hidden behind `@qgis_platform != 'desktop'` so it would not draw on top
of the PostgreSQL layer, and that filter then had to be stripped again during packaging or
the package rendered an empty map on desktop. Building it at packaging time removes the
duplicate styles and both halves of that switch.

The trade-off: a package built through the QFieldSync dialog rather than package-qfield.py
has no offline symbology at all. project/scripts/check-qfield-package.py fails loudly on
such a package.
"""

import re
from pathlib import Path

from qgis.core import (
    QgsDataSourceUri,
    QgsMapLayerDependency,
    QgsMapLayerStyle,
    QgsVectorLayer,
    QgsVirtualLayerDefinition,
)

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


def copy_styles(source, target):
    """Copy every named style from the PostgreSQL layer, adjusted for the field.

    Two adjustments, both of which only make sense on the packaged copy: packaging config
    is stripped out of the styles, and the SVG paths are anchored on @project_path.
    """
    src_mgr, dst_mgr = source.styleManager(), target.styleManager()
    original = src_mgr.currentStyle()
    for name in src_mgr.styles():
        xml = QFIELDSYNC_OPTION.sub("", src_mgr.style(name).xmlData())
        xml = xml.replace(RELATIVE_IMAGE_PREFIX, ANCHORED_IMAGE_PREFIX)
        if name not in dst_mgr.styles():
            dst_mgr.addStyle(name, QgsMapLayerStyle(xml))
        else:
            dst_mgr.setCurrentStyle(name)
            QgsMapLayerStyle(xml).writeToLayer(target)
    dst_mgr.setCurrentStyle(original)
    return len(src_mgr.styles())


def add_to_project(project):
    """Create the virtual layer, style it, and place it in the layer tree.

    Returns (layer, style_count). The project is modified in memory only -- writing it is
    the caller's business, and package-qfield.py only ever writes the packaged copy.
    """
    layer = QgsVectorLayer(
        build_definition(project).toString(), VIRTUAL_LAYER_NAME, "virtual"
    )
    if not layer.isValid():
        raise RuntimeError(f"virtual layer is invalid: {layer.error().summary()}")

    pg_layer = find_by_table(project, SYMBOL_VIEW_TABLE)
    project.addMapLayer(layer, False)
    styles = copy_styles(pg_layer, layer)

    layer.setDependencies(
        {QgsMapLayerDependency(find_by_table(project, t).id()) for t in REFRESH_ON}
    )
    layer.setReadOnly(True)

    # Package the virtual layer, drop the PostgreSQL one it replaces.
    layer.setCustomProperty("QFieldSync/action", "no_action")
    pg_layer.setCustomProperty("QFieldSync/action", "remove")

    # Sit where the PostgreSQL layer sat, so the legend looks the same in the field.
    root = project.layerTreeRoot()
    pg_node = root.findLayer(pg_layer.id())
    parent = pg_node.parent() if pg_node else root
    parent.insertLayer(parent.children().index(pg_node) + 1 if pg_node else 0, layer)
    if (node := root.findLayer(layer.id())) is not None:
        node.setItemVisibilityChecked(True)

    return layer, styles
