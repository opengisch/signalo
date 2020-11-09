

layer = QgsProject.instance().mapLayer('support_347aa750_1661_498f_a7e8_017adc616ba0')

support = next(layer.getFeatures(QgsFeatureRequest(QgsExpression("id='00000000-0000-0000-0000-000000000001'"))))



for i in range(1,10):
    for j in range(1,10):
        support_new = QgsFeature(support)
        geom = support_new.geometry()
        geom.translate(i*50,j*50)
        support_new.setGeometry(geom)
        f = QgsVectorLayerUtils.duplicateFeature(layer, support_new, QgsProject.instance())
    print(i)