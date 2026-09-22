#!/usr/bin/python3
"""Assert that a packaged QField project is actually usable in the field.

Runs against a real package -- one built by package-qfield.py, or one a colleague built
through the QFieldSync dialog -- and checks the things that would silently ruin a field
campaign:

  * the offline symbology layer survived packaging and still resolves its sources;
  * the PostgreSQL symbology layer did NOT get shipped (it would be a frozen snapshot);
  * every source layer is now a GeoPackage, not a live database connection;
  * no symbols were lost on the way, and none of their values changed;
  * the layer draws whatever the platform, rather than only in QField;
  * every SVG the symbology reaches for is actually in the package;
  * and, the point of the whole exercise, adding a sign restacks the symbology.

The last check edits the package, so the package is copied to a temporary directory
first and the original is left untouched.

    docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
        /usr/src/project/scripts/check-qfield-package.py /usr/src/qfield-package/signalo.qgs
"""

import argparse
import json
import shutil
import sys
import tempfile
from pathlib import Path

from qgis.core import (
    QgsApplication,
    QgsExpression,
    QgsExpressionContext,
    QgsExpressionContextScope,
    QgsExpressionContextUtils,
    QgsProject,
    QgsSymbolLayer,
    QgsVectorLayerUtils,
    QgsVirtualLayerDefinition,
)
from qgis.PyQt.QtCore import QUrl

sys.path.insert(0, str(Path(__file__).parent))
from signalo_symbology import symbology_digest  # noqa: E402

MANIFEST_NAME = "signalo-package.json"
VIRTUAL_LAYER_NAME = "Vue signal (symbologie hors ligne)"
POSTGRES_LAYER_NAME = "Vue signal (symbologie)"


class Checks:
    def __init__(self):
        self.failures = []

    def check(self, ok, label, detail="", on_fail=""):
        note = detail or (on_fail if not ok else "")
        if not ok and detail and on_fail:
            note = f"{detail} -- {on_fail}"
        print(f"  {'ok  ' if ok else 'FAIL'}  {label}{f' -- {note}' if note else ''}")
        if not ok:
            self.failures.append(label)
        return ok


def undrawn_platforms(layer):
    """Platforms on which the packaged layer would draw nothing.

    The source project gates the virtual layer on `@qgis_platform != 'desktop'` so it does
    not fight the PostgreSQL layer. That gate must not survive packaging: the package has
    no PostgreSQL layer, and carrying the gate over means an empty map for anyone opening
    the package in QGIS Desktop to inspect it.
    """
    rules = [
        rule
        for rule in layer.renderer().rootRule().children()
        if rule.filterExpression()
    ]
    blind = []
    for platform in ("desktop", "mobile", "external"):
        context = QgsExpressionContext()
        context.appendScopes(QgsExpressionContextUtils.globalProjectLayerScopes(layer))
        scope = QgsExpressionContextScope()
        scope.setVariable("qgis_platform", platform)
        context.appendScope(scope)

        drawn = 0
        for feature in layer.getFeatures():
            context.setFeature(feature)
            if any(
                QgsExpression(rule.filterExpression()).evaluate(context)
                for rule in rules
            ):
                drawn += 1
        if rules and not drawn:
            blind.append(platform)
    return blind


def svg_paths(layer, project_dir):
    """Resolve the SVG every feature would actually draw, and say which are missing.

    The sign symbology builds its paths relative to the project (`'images/' || ...`), so a
    package without the images directory beside the project renders nothing while every
    structural check still passes. Evaluating the data-defined property per feature is the
    only way to know the files are really there.
    """
    name_property = getattr(QgsSymbolLayer, "PropertyName", None)
    if name_property is None:
        name_property = QgsSymbolLayer.Property.Name

    symbols = [
        rule.symbol()
        for rule in layer.renderer().rootRule().children()
        if rule.symbol()
    ]
    context = QgsExpressionContext()
    context.appendScopes(QgsExpressionContextUtils.globalProjectLayerScopes(layer))

    referenced = set()
    # Statically configured SVGs, which no amount of feature iteration would reveal --
    # this is how a path hardcoded to somebody's laptop hides in a project.
    for symbol in symbols:
        for symbol_layer in symbol.symbolLayers():
            path = getattr(symbol_layer, "path", lambda: "")()
            if path:
                referenced.add(path)

    for feature in layer.getFeatures():
        context.setFeature(feature)
        for symbol in symbols:
            for symbol_layer in symbol.symbolLayers():
                prop = symbol_layer.dataDefinedProperties().property(name_property)
                if not prop.isActive():
                    continue
                path = prop.valueAsString(context, "")[0]
                if path:
                    referenced.add(path)

    # QGIS can embed an SVG in the project as `base64:<data>` instead of pointing at a
    # file. Those need no packaging -- they already travel with the project.
    referenced = {path for path in referenced if not path.startswith("base64:")}

    missing = sorted(
        path
        for path in referenced
        if not (
            Path(path) if Path(path).is_absolute() else project_dir / path
        ).is_file()
    )
    return referenced, missing


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "project", help="the packaged .qgs inside the package directory"
    )
    args = parser.parse_args()

    app = QgsApplication([], False)
    app.setPrefixPath("/usr", True)
    app.initQgis()

    source = Path(args.project)
    if not source.is_file():
        sys.exit(f"no packaged project at {source}")

    # The last check writes a feature, so work on a copy.
    work = Path(tempfile.mkdtemp(prefix="signalo-package-"))
    shutil.copytree(source.parent, work / "package")
    packaged = work / "package" / source.name

    project = QgsProject.instance()
    if not project.read(str(packaged)):
        sys.exit(f"cannot read packaged project {packaged}")

    checks = Checks()
    print(f"checking {source}")

    layers = list(project.mapLayers().values())
    virtual = next((l for l in layers if l.name() == VIRTUAL_LAYER_NAME), None)
    postgres_symbology = [l for l in layers if l.name() == POSTGRES_LAYER_NAME]

    checks.check(virtual is not None, "offline symbology layer is present")
    checks.check(
        not postgres_symbology,
        "postgres symbology layer was removed",
        (
            "still present -- it would ship a frozen snapshot"
            if postgres_symbology
            else ""
        ),
    )

    live = sorted({l.name() for l in layers if l.providerType() == "postgres"})
    checks.check(not live, "no layer still points at postgres", ", ".join(live))

    # Views in signalo_app are derived data whose write logic lives in INSTEAD OF
    # triggers, and neither the derivation nor the triggers survive into GeoPackage. An
    # offlined copy is therefore a snapshot that goes stale the moment anything is edited
    # -- which is the whole reason the sign symbology needed a virtual layer. Not a
    # failure, because whether that matters depends on the view, but worth seeing.
    app_views = sorted(
        l.name()
        for l in layers
        if "signalo_app"
        in str(
            l.customProperty("remoteSource")
            or l.customProperty("QFieldSync/remoteSource")
            or ""
        )
    )
    if app_views:
        print(f"  ..    offlined app views (frozen snapshots): {', '.join(app_views)}")

    if virtual is None:
        return report(checks, work, app)

    checks.check(virtual.isValid(), "offline symbology layer is valid")

    # Every layer_ref= in the virtual layer's URI must still resolve inside the package.
    # Parsed with the provider's own parser rather than by splitting the URI: the first
    # parameter follows "?" instead of "&", so naive splitting silently skips a source.
    definition = QgsVirtualLayerDefinition.fromUrl(
        QUrl.fromEncoded(virtual.source().encode())
    )
    refs = [s.reference() for s in definition.sourceLayers() if s.isReferenced()]
    unresolved = [r for r in refs if project.mapLayer(r) is None]
    checks.check(
        bool(refs) and not unresolved,
        f"all {len(refs)} source references resolve",
        ", ".join(unresolved),
    )
    sources = [project.mapLayer(r) for r in refs if project.mapLayer(r) is not None]
    not_ogr = sorted({l.name() for l in sources if l.providerType() != "ogr"})
    checks.check(not not_ogr, "all sources are geopackage", ", ".join(not_ogr))

    count = virtual.featureCount()
    manifest_path = source.parent / MANIFEST_NAME
    if manifest_path.is_file():
        manifest = json.loads(manifest_path.read_text())
        checks.check(
            count == manifest["virtual_layer_features"],
            "no symbols lost in packaging",
            f"{count} packaged vs {manifest['virtual_layer_features']} before",
        )
        # Counts alone would miss a conversion that keeps every row but changes what is
        # drawn, so compare the symbology values themselves.
        digest = symbology_digest(virtual)
        checks.check(
            digest == manifest["symbology_digest"],
            "symbology values are unchanged by packaging",
            digest[:12],
            on_fail=f"expected {manifest['symbology_digest'][:12]}; run "
            "project/virtual_layers/diff_vw.py to see which rows",
        )
    else:
        print(f"  ..    no {MANIFEST_NAME}; skipping the before/after comparison")
    checks.check(count > 0, "the package contains symbols", f"{count}")

    blind = undrawn_platforms(virtual)
    checks.check(
        not blind,
        "the packaged layer draws on every platform",
        on_fail=f"draws nothing when @qgis_platform is {', '.join(blind)}",
    )

    referenced, missing = svg_paths(virtual, packaged.parent)
    checks.check(
        bool(referenced) and not missing,
        "every sign image is in the package",
        (
            f"{len(referenced)} distinct svg paths"
            if referenced
            else "no svg path resolved -- the symbology would draw nothing"
        ),
        on_fail=f"{len(missing)} missing, e.g. {', '.join(missing[:3])}",
    )

    # The point of the whole exercise: edit offline, symbology follows.
    sign_layer = next((l for l in layers if l.name() == "Signal"), None)
    if sign_layer is not None and count:
        target = next(f for f in virtual.getFeatures() if f["_verso"] in (0, False))
        azimut = target["_azimut_rectified"]
        sign_id = str(target["pk"]).rsplit("-", 1)[0]
        fk_frame = next(
            f["fk_frame"] for f in sign_layer.getFeatures() if str(f["id"]) == sign_id
        )
        before = sorted(
            (str(f["pk"]), f["_final_rank"], f["_symbol_shift"])
            for f in virtual.getFeatures()
            if f["_azimut_rectified"] == azimut
        )

        sign_layer.startEditing()
        feature = QgsVectorLayerUtils.createFeature(sign_layer)
        feature["fk_frame"] = fk_frame
        feature["fk_sign_type"] = 11
        feature["fk_official_sign"] = "1.01"
        feature["fk_hanging_mode"] = "recto"
        feature["rank"] = 99
        added = sign_layer.addFeature(feature) and sign_layer.commitChanges()

        virtual.reload()
        after = sorted(
            (str(f["pk"]), f["_final_rank"], f["_symbol_shift"])
            for f in virtual.getFeatures()
            if f["_azimut_rectified"] == azimut
        )
        checks.check(
            added and before != after,
            "adding a sign offline restacks the symbology",
            f"azimut {azimut}: {len(before)} -> {len(after)} symbols",
        )
    else:
        checks.check(False, "the Signal layer is present to edit")

    return report(checks, work, app)


def report(checks, work, app):
    shutil.rmtree(work, ignore_errors=True)
    ok = not checks.failures
    print("\nPACKAGE OK" if ok else f"\nPACKAGE FAILED: {', '.join(checks.failures)}")
    app.exitQgis()
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
