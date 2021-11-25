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

from qgis.PyQt.QtCore import Qt, QRectF, QPointF
from qgis.PyQt.QtGui import QColor
from qgis.core import Qgis, QgsMarkerSymbolLayer, QgsSymbolLayer, QgsSymbolRenderContext, QgsSimpleMarkerSymbolLayer
from .utils import debug_info

SUPPORT_COLOR = QColor('red')


class SignaloSymbol(QgsMarkerSymbolLayer):
    def __init__(self):
        super(SignaloSymbol, self).__init__()
        debug_info("creating signalo symbol")

    # QgsSymbolLayer interface
    def layerType(self) -> str:
        return "SignaloMarker"
    
    def clone(self) -> QgsSymbolLayer:
        return SignaloSymbol()
        
    def properties(self) -> dict:
        return dict()

    # QgsMarkerSymbolLayer interface
    def renderPoint(self, point: QPointF, context: QgsSymbolRenderContext):
        support_feature = context.feature()
        if support_feature is None:
            debug_info(f"entering signalo renderer without feature")
            return

        debug_info(f"entering signalo renderer for feature {support_feature['id']} at {support_feature.geometry().asWkt()}")

        support_symbol = QgsSimpleMarkerSymbolLayer() #Qgis.MarkerShape.Circle, 4, 0, Qgis.ScaleMethod.ScaleDiameter, SUPPORT_COLOR, SUPPORT_COLOR, Qt.BevelJoin)
        support_symbol.renderPoint(point, context)

    def bounds(self, point: QPointF, context: QgsSymbolRenderContext) -> QRectF:
        debug_info("bounds")
        support_symbol = QgsSimpleMarkerSymbolLayer() #Qgis.MarkerShape.Circle, 4, 0, Qgis.ScaleMethod.ScaleDiameter, SUPPORT_COLOR, SUPPORT_COLOR, Qt.BevelJoin)
        debug_info(support_symbol.bounds())
        return support_symbol.bounds()
        b = QRectF(4, 4)
        return b
