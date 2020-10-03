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
        
        WITH ordered_signs AS (      
            SELECT
                sign.id
                , az_group.azimut_group
                , {sign_columns}
                , {vl_official_sign_columns}
                , ROW_NUMBER () OVER (
                    PARTITION BY fk_support, azimut_group ORDER BY frame.rank, sign.rank
                    ) AS final_rank
                , frame.id AS frame_id
                , support.id AS support_id
                , support.geometry::geometry(Point,%(SRID)s) AS support_geometry
            FROM siro_od.sign
            LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
            LEFT JOIN siro_od.support ON support.id = frame.fk_support
            LEFT JOIN siro_vl.official_sign ON official_sign.id = sign.fk_official_sign
            LEFT JOIN generate_series(-5,355,10) az_group (azimut_group)
                ON sign.azimut >= az_group.azimut_group
                AND sign.azimut < az_group.azimut_group + 10
            ORDER BY fk_support, azimut_group, fk_frame, final_rank
        ),
        ordered_shifted_signs AS (
            SELECT
                ordered_signs.*,
                SUM( vl_official_sign_img_height ) OVER rolling_window AS shift
            FROM
                ordered_signs
                WINDOW rolling_window AS ( PARTITION BY support_id, azimut_group ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
            ORDER BY support_id, azimut_group, frame_id, final_rank
        ),
        previous_sign_in_frame AS (
            SELECT
                ordered_signs.id,
                FIRST_VALUE(frame_id) OVER rolling_window AS frame_id,
                FIRST_VALUE(id) OVER rolling_window AS previous_sign_in_frame
            FROM   
                ordered_signs
                WINDOW rolling_window AS ( PARTITION BY support_id, azimut_group, frame_id ROWS 1 PRECEDING )
        ),
        next_sign_in_frame AS (
            SELECT
                ordered_signs.id,
                LAST_VALUE(frame_id) OVER rolling_window AS frame_id,
                LAST_VALUE(id) OVER rolling_window AS next_sign_in_frame
            FROM   
                ordered_signs
                WINDOW rolling_window AS ( PARTITION BY support_id, azimut_group, frame_id ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING )
        ),
        previous_frame AS (
            SELECT
                ordered_signs.id,
                FIRST_VALUE(frame_id) OVER rolling_window AS previous_frame
            FROM
                ordered_signs
                WINDOW rolling_window AS ( PARTITION BY support_id, azimut_group ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
        ),
        next_frame AS (
            SELECT
                ordered_signs.id,
                LAST_VALUE(frame_id) OVER rolling_window AS next_frame
            FROM
                ordered_signs
                WINDOW rolling_window AS ( PARTITION BY support_id, azimut_group ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
        )
        SELECT
            ordered_shifted_signs.*,
            previous_sign_in_frame.previous_sign_in_frame,
            next_sign_in_frame.next_sign_in_frame,
            previous_frame.previous_frame,
            next_frame.next_frame
        FROM
            ordered_shifted_signs
            LEFT JOIN previous_sign_in_frame ON previous_sign_in_frame.id = ordered_shifted_signs.id AND previous_sign_in_frame.previous_sign_in_frame != ordered_shifted_signs.id
            LEFT JOIN next_sign_in_frame ON next_sign_in_frame.id = ordered_shifted_signs.id AND next_sign_in_frame.next_sign_in_frame != ordered_shifted_signs.id
            LEFT JOIN previous_frame ON previous_frame.id = ordered_shifted_signs.id AND previous_frame.previous_frame != ordered_shifted_signs.frame_id
            LEFT JOIN next_frame ON next_frame.id = ordered_shifted_signs.id AND next_frame.next_frame != ordered_shifted_signs.frame_id
        ORDER BY support_id, azimut_group, final_rank
            
         
        
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