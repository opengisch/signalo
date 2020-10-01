#!/usr/bin/env python3
#
# -- View: vw_qgep_wastewater_structure

import argparse
import os
import psycopg2
from yaml import safe_load
from pirogue.utils import select_columns, insert_command, update_command, table_parts


def vw_qgep_wastewater_structure(srid: int,
                                 pg_service: str = None,
                                 extra_definition: dict = None):
    """
    Creates qgep_wastewater_structure view
    :param srid: EPSG code for geometries
    :param pg_service: the PostgreSQL service name
    :param extra_definition: a dictionary for additional read-only columns
    """
    if not pg_service:
        pg_service = os.getenv('PGSERVICE')
    assert pg_service
    extra_definition = extra_definition or {}

    variables = {'SRID': int(srid)}

    conn = psycopg2.connect("service={0}".format(pg_service))
    cursor = conn.cursor()

    view_sql = """
CREATE OR REPLACE VIEW siro_od.vw_sign_symbol AS

--SELECT
--    sign.*,
--    support.geometry
--FROM siro_od.sign
--LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
--LEFT JOIN siro_od.support ON support.id = frame.fk_support

SELECT
    sign.id,
    az_group.azimut,
    frame.rank AS frame_rank,
    sign.rank AS sign_rank,
    sign.fk_official_sign,
    img_fr,
    img_height,
    ROW_NUMBER () OVER (
    PARTITION BY az_group.azimut
    ) AS final_rank,
    support.geometry::geometry(Point,%(SRID)s)
FROM siro_od.sign
LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
LEFT JOIN siro_od.support ON support.id = frame.fk_support
LEFT JOIN siro_vl.official_sign ON official_sign.id = sign.fk_official_sign
LEFT JOIN generate_series(-5,355,10) az_group (azimut)
    ON sign.azimut >= az_group.azimut
    AND sign.azimut < az_group.azimut + 10
ORDER BY azimut, final_rank;