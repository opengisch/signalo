#!/usr/bin/env python3
#
# -- View: vw_sign_symbol

import argparse
import os

import psycopg2
from pirogue.utils import insert_command, select_columns, table_parts, update_command


def vw_sign_symbol(srid: int, pg_service: str = None):
    """
    Creates sign_symbol view
    :param srid: EPSG code for geometries
    :param pg_service: the PostgreSQL service name
    """
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service

    variables = {"SRID": int(srid)}

    conn = psycopg2.connect(f"service={pg_service}")
    cursor = conn.cursor()

    view_sql = """
        CREATE OR REPLACE VIEW signalo_app.vw_sign_symbol AS

        WITH joined_tables AS (
            SELECT
                {sign_columns}
                , azimut.azimut
                , azimut.offset_x
                , azimut.offset_y
                , {frame_columns}
                , sign.rank AS sign_rank
                , support.id AS support_id
                , support.group_by_anchor
                , support.fk_support_type
                , support.geometry::geometry(Point,%(SRID)s) AS support_geometry
                , COALESCE(vl_official_sign.directional_sign, vl_user_sign.directional_sign, FALSE) AS directional_sign
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_de
                    ELSE vl_official_sign.value_de
                  END AS _symbol_value_de
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_fr
                    ELSE vl_official_sign.value_fr
                  END AS _symbol_value_fr
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_it
                    ELSE vl_official_sign.value_it
                  END AS _symbol_value_it
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_ro
                    ELSE vl_official_sign.value_ro
                  END AS _symbol_value_ro
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_de
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_de
                      ELSE NULL::text
                  END AS _img_de
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_fr
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_fr
                      ELSE NULL::text
                  END AS _img_fr
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_it
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_it
                      ELSE NULL::text
                  END AS _img_it
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_ro
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_ro
                      ELSE NULL::text
                  END AS _img_ro
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_de_right
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_de_right
                      ELSE NULL::text
                  END AS _img_de_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_fr_right
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_fr_right
                      ELSE NULL::text
                  END AS _img_fr_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_it_right
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_it_right
                      ELSE NULL::text
                  END AS _img_it_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_ro_right
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_ro_right
                      ELSE NULL::text
                  END AS _img_ro_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 106
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_height
                      WHEN sign.fk_sign_type = 12 THEN 130
                      WHEN sign.fk_sign_type = 13 THEN 80
                      WHEN sign.fk_sign_type = 14 THEN 50
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_height
                      ELSE NULL::integer
                  END AS _symbol_height
                , CASE
                      WHEN sign.complex IS TRUE THEN 121
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_width
                      WHEN sign.fk_sign_type = 12 THEN 70
                      WHEN sign.fk_sign_type = 13 THEN 100
                      WHEN sign.fk_sign_type = 14 THEN 100
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_width
                      ELSE NULL::integer
                  END AS _symbol_width
            FROM signalo_db.sign
                LEFT JOIN signalo_db.frame ON frame.id = sign.fk_frame
                LEFT JOIN signalo_db.azimut ON azimut.id = frame.fk_azimut
                LEFT JOIN signalo_db.support ON support.id = azimut.fk_support
                LEFT JOIN signalo_db.vl_official_sign ON vl_official_sign.id = sign.fk_official_sign
                LEFT JOIN signalo_db.vl_user_sign ON vl_user_sign.id = sign.fk_user_sign
        ),


        -- recto NOT ordered by anchor point
        ordered_recto_signs_not_grouped_by_anchor AS (
            SELECT
                joined_tables.*
                , azimut AS _azimut_rectified
                , offset_x AS _azimut_offset_x_rectified
                , offset_y AS _azimut_offset_y_rectified
                , frame_anchor AS _frame_anchor_rectified
                , false::bool AS _verso
                , ROW_NUMBER () OVER ( PARTITION BY support_id, azimut ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables
            WHERE hanging_mode != 'VERSO'::signalo_db.sign_hanging AND group_by_anchor IS FALSE
            ORDER BY support_id, azimut, _rank
        ),
        -- recto ordered by anchor point
        ordered_recto_signs_grouped_by_anchor AS (
            SELECT
                joined_tables.*
                , azimut AS _azimut_rectified
                , offset_x AS _azimut_offset_x_rectified
                , offset_y AS _azimut_offset_y_rectified
                , frame_anchor AS _frame_anchor_rectified
                , false::bool AS _verso
                , ROW_NUMBER () OVER ( PARTITION BY support_id, azimut, frame_anchor ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables
            WHERE hanging_mode != 'VERSO'::signalo_db.sign_hanging AND group_by_anchor IS TRUE
            ORDER BY support_id, azimut, frame_anchor, _rank
        ),
        -- verso NOT ordered by anchor point (RECTO-VERSO are duplicated)
        ordered_verso_signs_not_grouped_by_anchor AS (
            SELECT
                jt.*
                , jt.azimut+180 AS _azimut_rectified
                , COALESCE(az.offset_x, 0) AS _azimut_offset_x_rectified
                , COALESCE(az.offset_y, 0) AS _azimut_offset_y_rectified
                , CASE
                      WHEN frame_anchor = 'LEFT'::signalo_db.anchor THEN 'RIGHT'::signalo_db.anchor
                      WHEN frame_anchor = 'RIGHT'::signalo_db.anchor THEN 'LEFT'::signalo_db.anchor
                      ELSE 'CENTER'::signalo_db.anchor
                  END AS _frame_anchor_rectified
                , true::bool AS _verso
                , 1000 + ROW_NUMBER () OVER ( PARTITION BY support_id, jt.azimut ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables jt
            LEFT JOIN signalo_db.azimut az ON az.azimut = ((jt.azimut+180) %% 360) AND az.fk_support = support_id
            WHERE hanging_mode != 'RECTO'::signalo_db.sign_hanging AND group_by_anchor IS FALSE
            ORDER BY support_id, jt.azimut, _rank
        ),
        -- verso ordered by anchor point (RECTO-VERSO are duplicated)
        ordered_verso_signs_grouped_by_anchor AS (
            SELECT
                jt.*
                , jt.azimut+180 AS _azimut_rectified
                , COALESCE(az.offset_x, 0) AS _azimut_offset_x_rectified
                , COALESCE(az.offset_y, 0) AS _azimut_offset_y_rectified
                , CASE
                      WHEN frame_anchor = 'LEFT'::signalo_db.anchor THEN 'RIGHT'::signalo_db.anchor
                      WHEN frame_anchor = 'RIGHT'::signalo_db.anchor THEN 'LEFT'::signalo_db.anchor
                      ELSE 'CENTER'::signalo_db.anchor
                  END AS _frame_anchor_rectified
                , true::bool AS _verso
                , 1000 + ROW_NUMBER () OVER ( PARTITION BY support_id, jt.azimut, frame_anchor ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables jt
            LEFT JOIN signalo_db.azimut az ON az.azimut = ((jt.azimut+180) %% 360) AND az.fk_support = support_id
            WHERE hanging_mode != 'RECTO'::signalo_db.sign_hanging AND group_by_anchor IS TRUE
            ORDER BY support_id, jt.azimut, frame_anchor, _rank
        ),

        ordered_signs_not_grouped_by_anchor AS (
           SELECT * FROM ordered_recto_signs_not_grouped_by_anchor
           UNION
           SELECT * FROM ordered_verso_signs_not_grouped_by_anchor
        ),
        ordered_signs_grouped_by_anchor AS (
           SELECT * FROM ordered_recto_signs_grouped_by_anchor
           UNION
           SELECT * FROM ordered_verso_signs_grouped_by_anchor
        ),

        ordered_shifted_signs_not_grouped_by_anchor AS (
            SELECT
                ordered_signs_not_grouped_by_anchor.*
                , ROW_NUMBER () OVER ( PARTITION BY support_id, _azimut_rectified ORDER BY _rank ) AS _final_rank
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ), 0) AS _symbol_shift
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified), 0) AS _group_height
                , MAX(_symbol_width) OVER ( PARTITION BY support_id, _azimut_rectified ) AS _group_width
                , NULLIF(FIRST_VALUE(id) OVER (PARTITION BY support_id, _azimut_rectified, frame_rank ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), id) AS _previous_sign_in_frame
                , NULLIF(LAST_VALUE(id) OVER ( PARTITION BY support_id, _azimut_rectified, frame_rank ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS _next_sign_in_frame
                , NULLIF(FIRST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame_id) AS _previous_frame
                , NULLIF(LAST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame_id) AS _next_frame
            FROM
                ordered_signs_not_grouped_by_anchor
        ),
        ordered_shifted_signs_grouped_by_anchor AS (
            SELECT
                ordered_signs_grouped_by_anchor.*
                , ROW_NUMBER () OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified ORDER BY _rank ) AS _final_rank
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ), 0) AS _symbol_shift
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified), 0) AS _group_height
                , MAX(_symbol_width) OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified ) AS _group_width
                , NULLIF(FIRST_VALUE(id) OVER (PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified, frame_rank ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), id) AS _previous_sign_in_frame
                , NULLIF(LAST_VALUE(id) OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified, frame_rank ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS _next_sign_in_frame
                , NULLIF(FIRST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame_id) AS _previous_frame
                , NULLIF(LAST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified, _frame_anchor_rectified ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame_id) AS _next_frame
            FROM
                ordered_signs_grouped_by_anchor
        ),

        union_view AS (
                SELECT
                    ossng.*
                FROM ordered_shifted_signs_not_grouped_by_anchor ossng
            UNION
                SELECT
                    ossg.*
                FROM ordered_shifted_signs_grouped_by_anchor ossg
        )

            SELECT
                uv.id || '-' || _verso::int AS pk
                , uv.*
                , _symbol_height + MAX(_symbol_shift) OVER ( PARTITION BY uv.support_id, azimut, _verso ) AS _max_shift_for_azimut
                , CASE
                    WHEN directional_sign IS TRUE AND (_frame_anchor_rectified, natural_direction_or_left) IN (
                        ('LEFT', TRUE),
                        ('CENTER', FALSE),
                        ('RIGHT', FALSE)
                    ) THEN '_right'
                    ELSE ''
                  END AS _img_direction
            FROM union_view uv;
    """.format(
        sign_columns=select_columns(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="sign",
            remove_pkey=False,
            indent=4,
            skip_columns=["rank", "fk_frame", "_edited"],
        ),
        frame_columns=select_columns(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="frame",
            remove_pkey=False,
            indent=4,
            skip_columns=["_edited"],
            prefix="frame_",
        ),
        vl_official_sign_columns=select_columns(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="vl_official_sign",
            remove_pkey=False,
            indent=4,
            prefix="vl_official_sign_",
        ),
    )

    try:
        cursor.execute(view_sql, variables)
    except psycopg2.Error as e:
        with open("~view.sql", "w") as f:
            f.write(view_sql)
        print(f"*** Failing:\n{view_sql}\n***")
        raise e
    conn.commit()
    conn.close()


if __name__ == "__main__":
    # create the top-level parser
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--srid", help="EPSG code for SRID")
    parser.add_argument("-p", "--pg_service", help="the PostgreSQL service name")
    args = parser.parse_args()
    srid = args.srid or os.getenv("SRID")
    pg_service = args.pg_service or os.getenv("PGSERVICE")
    vw_sign_symbol(srid=srid, pg_service=pg_service)
