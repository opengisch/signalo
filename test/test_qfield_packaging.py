"""Project settings that decide whether a QField package draws anything.

These are one-line project properties with no visible effect on the desktop, which makes
them easy to lose in a project rewrite and impossible to notice until someone is standing
in a field looking at an empty map.
"""

import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

PROJECT_PATH = Path(__file__).resolve().parents[1] / "project" / "signalo.qgs"

# The directory holding the sign SVGs, relative to the project.
IMAGE_DIR = "images"


def qfieldsync_list(key):
    """Read a QStringList from the project's QFieldSync property scope.

    Note the scope is case sensitive and the project carries two: `QFieldSync`, written by
    the plugin and read by the cloud worker, and `qfieldsync`, written by QField itself.
    Only the first one is consulted at packaging time.
    """
    root = ET.parse(PROJECT_PATH).getroot()
    scope = root.find("properties/QFieldSync")
    if scope is None:
        return None
    entry = scope.find(key)
    if entry is None:
        return None
    return [value.text for value in entry.findall("value")]


class TestPackagedDirectories(unittest.TestCase):
    """images/ must travel with the package, and the project is the only place to say so.

    The sign symbology resolves its SVGs relative to the project directory. A package
    without images/ beside the .qgs is valid, has every feature, reports no error -- and
    draws no signs at all.

    Two different pieces of code decide what gets copied, and they do not read the same
    setting. QFieldCloud's packaging worker reads both lists:

        attachment_dirs, _ = project.readListEntry("QFieldSync", "attachmentDirs", ["DCIM"])
        data_dirs, _ = project.readListEntry("QFieldSync", "dataDirs", [])
        OfflineConverter(..., attachment_dirs=attachment_dirs + data_dirs, ...)

    while the QFieldSync plugin's cloud converter, which builds the cloud project in the
    first place, copies only `Preferences().value("attachmentDirs")` and ignores dataDirs
    entirely. Neither passes dirs_to_copy and neither loads plugins, so declaring the
    directory in the project is the only hook there is.

    `images` therefore lives in attachmentDirs, which is the one list both of them read.
    This was found the hard way: a cloud project was built without images/ and drew an
    empty map, while the cable package -- which used to pass its own dirs_to_copy -- looked
    perfectly healthy.
    """

    def test_images_are_declared_as_a_copied_directory(self):
        attachment_dirs = qfieldsync_list("attachmentDirs") or []
        data_dirs = qfieldsync_list("dataDirs") or []

        self.assertIn(
            IMAGE_DIR,
            attachment_dirs + data_dirs,
            "neither QFieldSync/attachmentDirs nor QFieldSync/dataDirs lists 'images', so "
            "a package will not contain the sign SVGs and QField will draw no signs",
        )
        self.assertIn(
            IMAGE_DIR,
            attachment_dirs,
            "'images' is only in QFieldSync/dataDirs. The packaging worker would copy it, "
            "but the cloud converter reads attachmentDirs alone, so a project converted to "
            "QFieldCloud would have no sign images",
        )

    def test_the_source_images_directory_exists(self):
        self.assertTrue(
            (PROJECT_PATH.parent / IMAGE_DIR).is_dir(),
            f"{IMAGE_DIR}/ is declared in QFieldSync/attachmentDirs but is not next to the "
            "project, so nothing would be copied",
        )


if __name__ == "__main__":
    unittest.main()
