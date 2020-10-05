#!/usr/bin/env python3
#
# -- View: vw_qgep_wastewater_structure

import argparse
import os
import psycopg2
from pirogue.utils import select_columns, insert_command, update_command, table_parts


def vw_sign_symbol(srid: int, pg_service: str = None):
    """
    Creates qgep_wastewater_structure view
    :param srid: EPSG code for geometries
    :param pg_service: the PostgreSQL service name
    """
    if not pg_service:
        pg_service = os.getenv('PGSERVICE')
    assert pg_service

    variables = {'SRID': int(srid)}

    conn = psycopg2.connect("service={0}".format(pg_service))
    cursor = conn.cursor()

    view_sql = """
        CREATE OR REPLACE VIEW siro_od.vw_sign_symbol AS
        
        WITH joined_tables AS (      
            SELECT
                sign.id
                , azimut.azimut
                , {sign_columns}
                , sign.rank AS sign_rank
                , frame.id AS frame_id
                , frame.rank AS frame_rank
                , support.id AS support_id
                , support.geometry::geometry(Point,%(SRID)s) AS support_geometry
                , {vl_official_sign_columns}
            FROM siro_od.sign
                LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
                LEFT JOIN siro_od.azimut ON azimut.id = frame.fk_azimut
                LEFT JOIN siro_od.support ON support.id = azimut.fk_support
                LEFT JOIN siro_vl.official_sign ON official_sign.id = sign.fk_official_sign
        ),
        ordered_recto_signs AS (
            SELECT
                joined_tables.*
                , ROW_NUMBER () OVER ( PARTITION BY support_id, azimut ORDER BY frame_rank, sign_rank ) AS final_rank
            FROM joined_tables
            WHERE verso IS FALSE
            ORDER BY support_id, azimut, final_rank
        ),
        ordered_shifted_recto_signs AS (
            SELECT
                ordered_recto_signs.*
                , SUM( vl_official_sign_img_height ) OVER ( PARTITION BY support_id, azimut ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS shift
                , NULLIF(FIRST_VALUE(id) OVER (PARTITION BY support_id, azimut, frame_rank ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), id) AS previous_sign_in_frame
                , NULLIF(LAST_VALUE(id) OVER ( PARTITION BY support_id, azimut, frame_rank ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS next_sign_in_frame
                , NULLIF(FIRST_VALUE(frame_id) OVER ( PARTITION BY support_id, azimut ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame_id) AS previous_frame
                , NULLIF(LAST_VALUE(frame_id) OVER ( PARTITION BY support_id, azimut ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame_id) AS next_frame
            FROM
                ordered_recto_signs
            ORDER BY 
                support_id, azimut, final_rank
        )
            SELECT * FROM ordered_shifted_recto_signs
        UNION 
            SELECT jt.*, osrs.final_rank, osrs.shift, NULL::uuid AS previous_sign_in_frame, NULL::uuid AS next_sign_in_frame, NULL::uuid AS previous_frame, NULL::uuid AS next_frame
            FROM joined_tables jt
            LEFT JOIN ordered_shifted_recto_signs osrs ON osrs.support_id = jt.support_id AND osrs.frame_id = jt.frame_id AND jt.sign_rank = osrs.sign_rank 
            WHERE jt.verso IS TRUE   
        ;
    """.format(
        sign_columns=select_columns(
            pg_cur=cursor, table_schema='siro_od', table_name='sign',
            remove_pkey=True, indent=4, skip_columns=['rank']
        ),
        vl_official_sign_columns=select_columns(
            pg_cur=cursor, table_schema='siro_vl', table_name='official_sign',
            remove_pkey=False, indent=4, prefix='vl_official_sign_'
        ),
    )

    cursor.execute(view_sql, variables)
    conn.commit()
    conn.close()


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--srid', help='EPSG code for SRID')
    parser.add_argument('-p', '--pg_service', help='the PostgreSQL service name')
    args = parser.parse_args()
    srid = args.srid or os.getenv('SRID')
    pg_service = args.pg_service or os.getenv('PGSERVICE')
    vw_sign_symbol(srid=srid, pg_service=pg_service)