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

from qgis.PyQt.QtCore import Qt, QRectF, QPointF, QVariant
from qgis.PyQt.QtGui import QColor
from qgis.core import Qgis, QgsVectorLayer, QgsRenderContext, QgsExpressionContext, QgsExpressionContextUtils, QgsProperty, QgsMarkerSymbolLayer, QgsSymbolLayer, QgsSymbolRenderContext, QgsSimpleMarkerSymbolLayer, QgsSvgMarkerSymbolLayer, QgsFeature, QgsField, QgsFields, QgsUnitTypes
from .utils import debug_info

SUPPORT_COLOR = QColor('red')


class SignaloSymbol(QgsMarkerSymbolLayer):
    def __init__(self):
        super(SignaloSymbol, self).__init__()
        debug_info("creating signalo symbol")

        self.support_symbol = QgsSimpleMarkerSymbolLayer()  # Qgis.MarkerShape.Circle, 4, 0, Qgis.ScaleMethod.ScaleDiameter, SUPPORT_COLOR, SUPPORT_COLOR, Qt.BevelJoin)

        self.sign_symbol = QgsSvgMarkerSymbolLayer('')
        self.sign_symbol.setDataDefinedProperty(QgsSymbolLayer.PropertyName, QgsProperty.fromExpression('"path"'))

        # a virtual layer with all the info to render the individual signs
        self.sign_layer = QgsVectorLayer('Point?crs=epsg:2056&field=id:string&field=path:string','sign', 'memory')

    # QgsSymbolLayer interface
    def layerType(self) -> str:
        return "SignaloMarker"
    
    def clone(self) -> QgsSymbolLayer:
        return SignaloSymbol()
        
    def properties(self) -> dict:
        return dict()

    def sign_symbol_render_context(self, support_symbol_render_context: QgsSymbolRenderContext) -> QgsSymbolRenderContext:
        fields = QgsFields()
        fields.append(QgsField("path", QVariant.String, 'text'), QgsFields.OriginExpression)
        f = QgsFeature()
        f.setFields(self.sign_layer.fields())
        f.setAttribute('path', ['/Users/denis/Documents/signalisation_verticale/project/images/official/original/111.svg'])

        expression_context = QgsExpressionContext()
        expression_context.appendScopes(QgsExpressionContextUtils.globalProjectLayerScopes(self.sign_layer))
        expression_context.setFeature(f)

        sign_render_context = QgsRenderContext(support_symbol_render_context.renderContext())
        sign_render_context.setExpressionContext(expression_context)

        sign_context = QgsSymbolRenderContext(sign_render_context, QgsUnitTypes.RenderUnit.RenderMillimeters, 1, False, Qgis.SymbolRenderHints(), f, fields)
        return sign_context

    def startRender(self, context: QgsSymbolRenderContext):
        debug_info(f"start render")
        self.support_symbol.startRender(context)

        sign_context = self.sign_symbol_render_context(context)
        # self.sign_symbol.startRender(sign_context)

    def stopRender(self, context: QgsSymbolRenderContext):
        self.support_symbol.stopRender(context)
        sign_context = self.sign_symbol_render_context(context)
        self.sign_symbol.stopRender(sign_context)


    # QgsMarkerSymbolLayer interface
    def renderPoint(self, point: QPointF, context: QgsSymbolRenderContext):
        debug_info("renderPoint")
        support_feature = context.feature()
        if support_feature is None:
            debug_info("no feature -> exit")
            return

        debug_info(f"symbol for feature {support_feature['id']} at {support_feature.geometry().asWkt()}")

        #support_symbol = QgsSimpleMarkerSymbolLayer() #Qgis.MarkerShape.Circle, 4, 0, Qgis.ScaleMethod.ScaleDiameter, SUPPORT_COLOR, SUPPORT_COLOR, Qt.BevelJoin)
        self.support_symbol.renderPoint(point, context)

        sign_context = self.sign_symbol_render_context(context)

        #sign_render_context = sign_context.renderContext().expressionContext()
        #sign_render_context
        #sign_context.renderContext.setExpressionContext()

        self.sign_symbol.renderPoint(point, sign_context)

    def bounds(self, point: QPointF, context: QgsSymbolRenderContext) -> QRectF:
        debug_info("bounds")
        #support_symbol = QgsSimpleMarkerSymbolLayer() #Qgis.MarkerShape.Circle, 4, 0, Qgis.ScaleMethod.ScaleDiameter, SUPPORT_COLOR, SUPPORT_COLOR, Qt.BevelJoin)
        debug_info(self.support_symbol.bounds())
        return self.support_symbol.bounds()
        b = QRectF(4, 4)
        return b
