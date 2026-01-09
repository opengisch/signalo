#!/usr/bin/python3

import argparse

from qgis.core import QgsApplication, QgsProject

parser = argparse.ArgumentParser(description="Create QGIS project translation")
parser.add_argument("project")
parser.add_argument("-l", "--language", default="en")
args = parser.parse_args()

app = QgsApplication([], True)
app.setPrefixPath("/usr", True)
app.initQgis()


def print_message(message, tag, level):
    print(f"{tag}: {message}")


app.messageLog().messageReceived.connect(print_message)

project = QgsProject.instance()

assert project.read(args.project)
for layer in project.mapLayers().values():
    assert layer.isValid()
    print(f"Layer {layer.name()} is valid")
project.generateTsFile(args.language)
