# -*- coding: utf-8 -*-
"""
/***************************************************************************

 QGIS Signalo Plugin
 Copyright (C) 2021 Denis Rouzaud

 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""


import os
from PyQt5.QtCore import QCoreApplication, QLocale, QSettings, QTranslator
from PyQt5.QtWidgets import QWidget
from qgis.core import Qgis, QgsApplication, QgsVectorLayer, QgsProject
from qgis.gui import QgisInterface, QgsMessageBarItem
from .core.signalosymbollayermetadata import SignaloSymbolLayerMetadata


class SignaloPlugin:

    def __init__(self, iface: QgisInterface):
        self.iface = iface

        # initialize translation
        qgis_locale = QLocale(QSettings().value('locale/userLocale'))
        locale_path = os.path.join(os.path.dirname(__file__), 'i18n')
        self.translator = QTranslator()
        self.translator.load(qgis_locale, 'signalo-qgis-plugin', '_', locale_path)
        QCoreApplication.installTranslator(self.translator)

        # a virtual layer with all the info to render the individual signs
        #self.sign_layer = QgsVectorLayer('Point?crs=epsg:2056&field=id:string&field=path:string', 'sign', 'memory')
        # QgsProject.instance().addMapLayer(self.sign_layer, False)

        self.symbol_metadata = SignaloSymbolLayerMetadata()

        self.registry = QgsApplication.instance().symbolLayerRegistry()
        assert self.registry.addSymbolLayerType(self.symbol_metadata)

    def initGui(self):
        pass

    def unload(self):
        assert self.registry.removeSymbolLayerType(self.symbol_metadata)
        # QgsProject.instance().removeMapLayer(self.sign_layer.id())

    def show_message(self, title: str, msg: str, level: Qgis.MessageLevel, widget: QWidget = None):
        if widget:
            self.widget = widget
            self.item = QgsMessageBarItem(title, msg, self.widget, level, 7)
            self.iface.messageBar().pushItem(self.item)
        else:
            self.iface.messageBar().pushMessage(title, msg, level)

