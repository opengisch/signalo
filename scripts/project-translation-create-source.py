#!/usr/bin/python3

from qgis.core import QgsApplication, QgsProject

app = QgsApplication([], True)
app.setPrefixPath("/usr", True)
app.initQgis()


def print_message(message, tag, level):
    print(f"{tag}: {message}")


app.messageLog().messageReceived.connect(print_message)

project = QgsProject.instance()

project.read("/usr/src/project/signalo.qgs")
project.generateTsFile("en")
