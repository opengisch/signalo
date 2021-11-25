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

from qgis.core import Qgis, QgsMessageLog

DEBUG = True


def debug_info(info="", level: Qgis.MessageLevel = Qgis.MessageLevel.Info):
    if DEBUG:
        QgsMessageLog.logMessage(info, "signalo renderer", level)