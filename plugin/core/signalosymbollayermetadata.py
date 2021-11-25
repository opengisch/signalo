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

from qgis.core import Qgis, QgsSymbolLayerAbstractMetadata, QgsSymbolLayer, QgsVectorLayer
from qgis.gui import QgsSymbolLayerWidget
from .signalosymbol import SignaloSymbol


class SignaloSymbolLayerMetadata(QgsSymbolLayerAbstractMetadata):
    def __init__(self):
        super(SignaloSymbolLayerMetadata, self).__init__('SignaloMarker', 'Signalo Marker', Qgis.SymbolType.Marker)

    def createSymbolLayer(self, map: dict) -> QgsSymbolLayer:
        return SignaloSymbol()

    def createSymbolLayerWidget(self, layer: QgsVectorLayer) -> QgsSymbolLayerWidget:
        return None
