#!/usr/bin/python3

from qgis.core import QgsProject, QgsApplication

app = QgsApplication([], True)
app.setPrefixPath("/usr", True)
app.initQgis()


def print_message(message, tag, level):
    print('{tag}: {message}'.format(tag=tag, message=message))


app.messageLog().messageReceived.connect(print_message)

project = QgsProject.instance()

project.read('project/signalo.qgs')
project.generateTsFile('en')