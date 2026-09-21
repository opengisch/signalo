"""Shared definition of "the same sign symbology".

Imported by both package-qfield.py and check-qfield-package.py so the two can never
disagree about what packaging is supposed to preserve. Deliberately free of any
libqfieldsync dependency, so the checker can be run against a package someone built
through the QFieldSync dialog without installing the packaging library.
"""

import hashlib
import json

# The values that decide where a sign is drawn. Digesting them before and after packaging
# catches a conversion that keeps every row but quietly changes what is drawn -- a type
# coercion on the way into GeoPackage, say, which a feature count would never reveal.
SYMBOLOGY_FIELDS = (
    "_azimut_rectified",
    "_azimut_offset_x_rectified",
    "_azimut_offset_y_rectified",
    "_final_rank",
    "_symbol_shift",
    "_symbol_height",
    "_symbol_width",
    "_group_width",
    "_max_shift_for_azimut",
    "_verso",
    "_img_fr",
    "_img_direction",
)


def symbology_digest(layer):
    """A stable fingerprint of what the layer would draw, keyed on pk."""
    rows = sorted(
        (str(feature["pk"]), [str(feature[name]) for name in SYMBOLOGY_FIELDS])
        for feature in layer.getFeatures()
    )
    return hashlib.sha256(json.dumps(rows, sort_keys=True).encode()).hexdigest()
