#!/usr/bin/env python3
#
# -- View: vw_sign_symbol

import argparse
import os

import psycopg
from pirogue.utils import insert_command, select_columns, table_parts, update_command


def vw_sign_symbol(connection: psycopg.Connection, srid: int):
    """
    Creates sign_symbol view
    :param srid: EPSG code for geometries
    :param pg_service: the PostgreSQL service name
    """
    cursor = connection.cursor()

    view_sql = """
        CREATE OR REPLACE VIEW signalo_app.vw_sign_symbol AS

        WITH joined_tables AS (
            SELECT
                sign.id,
                {sign_columns}
                , {azimut_columns}
                , {frame_columns}
                , {support_columns}
                , COALESCE(vl_official_sign.directional_sign, vl_user_sign.directional_sign, vl_marker_type.directional_sign, FALSE) AS directional_sign
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_de
                    WHEN sign.fk_sign_type = 12 THEN vl_marker_type.value_de
                    ELSE vl_official_sign.value_de
                  END AS _symbol_value_de
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_fr
                    WHEN sign.fk_sign_type = 12 THEN vl_marker_type.value_fr
                    ELSE vl_official_sign.value_fr
                  END AS _symbol_value_fr
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_it
                    WHEN sign.fk_sign_type = 12 THEN vl_marker_type.value_it
                    ELSE vl_official_sign.value_it
                  END AS _symbol_value_it
                , CASE
                    WHEN sign.fk_sign_type = 15 THEN vl_user_sign.value_ro
                    WHEN sign.fk_sign_type = 12 THEN vl_marker_type.value_ro
                    ELSE vl_official_sign.value_ro
                  END AS _symbol_value_ro
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_de
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_de
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_de
                      ELSE NULL::text
                  END AS _img_de
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_fr
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_fr
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_fr
                      ELSE NULL::text
                  END AS _img_fr
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_it
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_it
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_it
                      ELSE NULL::text
                  END AS _img_it
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_ro
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_ro
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_ro
                      ELSE NULL::text
                  END AS _img_ro
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_de_right
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_de_right
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_de_right
                      ELSE NULL::text
                  END AS _img_de_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_fr_right
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_fr_right
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_fr_right
                      ELSE NULL::text
                  END AS _img_fr_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_it_right
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_it_right
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_it_right
                      ELSE NULL::text
                  END AS _img_it_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_ro_right
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_ro_right
                      WHEN sign.fk_sign_type = 13 THEN 'mirror'||CASE WHEN sign.fk_mirror_shape=12 THEN '-circular' ELSE '' END||CASE WHEN NOT mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_ro_right
                      ELSE NULL::text
                  END AS _img_ro_right
                , CASE
                      WHEN sign.complex IS TRUE THEN 106
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_height
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_height
                      WHEN sign.fk_sign_type = 13 THEN 80
                      WHEN sign.fk_sign_type = 14 THEN 50
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_height
                      ELSE NULL::integer
                  END AS _symbol_height
                , CASE
                      WHEN sign.complex IS TRUE THEN 121
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_width
                      WHEN sign.fk_sign_type = 12 THEN vl_marker_type.img_width
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
                LEFT JOIN signalo_db.vl_marker_type ON vl_marker_type.id = sign.fk_marker_type
        ),


        -- recto NOT ordered by mounting point
        ordered_recto_signs_not_grouped_by_mounting_point AS (
            SELECT
                joined_tables.*
                , azimut_azimut AS _azimut_rectified
                , azimut_offset_x AS _azimut_offset_x_rectified
                , azimut_offset_y AS _azimut_offset_y_rectified
                , sign_natural_direction_or_left AS _natural_direction_or_left_rectified
                , false::bool AS _verso
                , ROW_NUMBER () OVER ( PARTITION BY support_id, azimut_azimut ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables
            WHERE sign_fk_hanging_mode != 'verso' AND support_group_by_mounting_point IS FALSE
            ORDER BY support_id, azimut_azimut, _rank
        ),
        -- recto ordered by mounting point
        ordered_recto_signs_grouped_by_mounting_point AS (
            SELECT
                joined_tables.*
                , azimut_azimut AS _azimut_rectified
                , azimut_offset_x AS _azimut_offset_x_rectified
                , azimut_offset_y AS _azimut_offset_y_rectified
                , sign_natural_direction_or_left AS _natural_direction_or_left_rectified
                , false::bool AS _verso
                , ROW_NUMBER () OVER ( PARTITION BY support_id, azimut_azimut, frame_fk_mounting_point ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables
            WHERE sign_fk_hanging_mode != 'verso' AND support_group_by_mounting_point IS TRUE
            ORDER BY support_id, azimut_azimut, frame_fk_mounting_point, _rank
        ),
        -- verso NOT ordered by mounting point (RECTO-VERSO are duplicated)
        ordered_verso_signs_not_grouped_by_mounting_point AS (
            SELECT
                jt.*
                , jt.azimut_azimut+180 AS _azimut_rectified
                , COALESCE(az.offset_x, jt.azimut_offset_x_verso) AS _azimut_offset_x_rectified
                , COALESCE(az.offset_y, jt.azimut_offset_y_verso) AS _azimut_offset_y_rectified
                , NOT sign_natural_direction_or_left AS _natural_direction_or_left_rectified
                , true::bool AS _verso
                , 1000 + ROW_NUMBER () OVER ( PARTITION BY support_id, jt.azimut_azimut ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables jt
            LEFT JOIN signalo_db.azimut az ON az.azimut = ((jt.azimut_azimut+180) % 360) AND az.fk_support = support_id
            WHERE sign_fk_hanging_mode != 'recto' AND support_group_by_mounting_point IS FALSE
            ORDER BY support_id, jt.azimut_azimut, _rank
        ),
        -- verso ordered by mounting point (RECTO-VERSO are duplicated)
        ordered_verso_signs_grouped_by_mounting_point AS (
            SELECT
                jt.*
                , jt.azimut_azimut+180 AS _azimut_rectified
                , COALESCE(az.offset_x, jt.azimut_offset_x_verso) AS _azimut_offset_x_rectified
                , COALESCE(az.offset_y, jt.azimut_offset_y_verso) AS _azimut_offset_y_rectified
                , NOT sign_natural_direction_or_left AS _natural_direction_or_left_rectified
                , true::bool AS _verso
                , 1000 + ROW_NUMBER () OVER ( PARTITION BY support_id, jt.azimut_azimut, frame_fk_mounting_point ORDER BY frame_rank, sign_rank ) AS _rank
            FROM joined_tables jt
            LEFT JOIN signalo_db.azimut az ON az.azimut = ((jt.azimut_azimut+180) % 360) AND az.fk_support = support_id
            WHERE sign_fk_hanging_mode != 'recto' AND support_group_by_mounting_point IS TRUE
            ORDER BY support_id, jt.azimut_azimut, frame_fk_mounting_point, _rank
        ),

        ordered_signs_not_grouped_by_mounting_point AS (
           SELECT * FROM ordered_recto_signs_not_grouped_by_mounting_point
           UNION
           SELECT * FROM ordered_verso_signs_not_grouped_by_mounting_point
        ),
        ordered_signs_grouped_by_mounting_point AS (
           SELECT * FROM ordered_recto_signs_grouped_by_mounting_point
           UNION
           SELECT * FROM ordered_verso_signs_grouped_by_mounting_point
        ),

        ordered_shifted_signs_not_grouped_by_mounting_point AS (
            SELECT
                ordered_signs_not_grouped_by_mounting_point.*
                , ROW_NUMBER () OVER ( PARTITION BY support_id, _azimut_rectified ORDER BY _rank ) AS _final_rank
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ), 0) AS _symbol_shift
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified), 0) AS _group_height
                , MAX(_symbol_width) OVER ( PARTITION BY support_id, _azimut_rectified ) AS _group_width
                , NULLIF(FIRST_VALUE(id) OVER (PARTITION BY support_id, _azimut_rectified, frame_rank ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), id) AS _previous_sign_in_frame
                , NULLIF(LAST_VALUE(id) OVER ( PARTITION BY support_id, _azimut_rectified, frame_rank ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS _next_sign_in_frame
                , NULLIF(FIRST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame_id) AS _previous_frame
                , NULLIF(LAST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame_id) AS _next_frame
            FROM
                ordered_signs_not_grouped_by_mounting_point
        ),
        ordered_shifted_signs_grouped_by_mounting_point AS (
            SELECT
                ordered_signs_grouped_by_mounting_point.*
                , ROW_NUMBER () OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point ORDER BY _rank ) AS _final_rank
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ), 0) AS _symbol_shift
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point), 0) AS _group_height
                , MAX(_symbol_width) OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point ) AS _group_width
                , NULLIF(FIRST_VALUE(id) OVER (PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point, frame_rank ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), id) AS _previous_sign_in_frame
                , NULLIF(LAST_VALUE(id) OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point, frame_rank ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS _next_sign_in_frame
                , NULLIF(FIRST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame_id) AS _previous_frame
                , NULLIF(LAST_VALUE(frame_id) OVER ( PARTITION BY support_id, _azimut_rectified, frame_fk_mounting_point ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame_id) AS _next_frame
            FROM
                ordered_signs_grouped_by_mounting_point
        ),

        union_view AS (
                SELECT
                    ossng.*
                FROM ordered_shifted_signs_not_grouped_by_mounting_point ossng
            UNION
                SELECT
                    ossg.*
                FROM ordered_shifted_signs_grouped_by_mounting_point ossg
        )

            SELECT
                uv.id || '-' || _verso::int AS pk
                , uv.*
                , MAX(_group_height) OVER ( PARTITION BY uv.support_id, azimut_azimut, _verso ) AS _max_shift_for_azimut
                , CASE
                    WHEN directional_sign IS TRUE AND (frame_fk_mounting_point, _natural_direction_or_left_rectified) IN (
                        ('left', TRUE),
                        ('center', FALSE),
                        ('right', FALSE)
                    ) THEN '_right'
                    ELSE ''
                  END AS _img_direction
            FROM union_view uv;
    """.format(
        srid=srid,
        sign_columns=select_columns(
            connection=connection,
            table_schema="signalo_db",
            table_name="sign",
            remove_pkey=True,
            prefix="sign_",
            indent=4,
            skip_columns=[
                "fk_frame",
                "needs_validation",
                "_last_modification_platform",
            ],
        ),
        frame_columns=select_columns(
            connection=connection,
            table_schema="signalo_db",
            table_name="frame",
            remove_pkey=False,
            prefix="frame_",
            indent=4,
            skip_columns=[
                "needs_validation",
                "_last_modification_platform",
                "fk_azimut",
            ],
        ),
        azimut_columns=select_columns(
            connection=connection,
            table_schema="signalo_db",
            table_name="azimut",
            remove_pkey=False,
            indent=4,
            skip_columns=[
                "needs_validation",
                "_last_modification_platform",
                "fk_support",
            ],
            prefix="azimut_",
        ),
        support_columns=select_columns(
            connection=connection,
            table_schema="signalo_db",
            table_name="support",
            remove_pkey=False,
            indent=4,
            skip_columns=["needs_validation", "_last_modification_platform"],
            prefix="support_",
        ),
    )

    try:
        cursor.execute(view_sql)
    except psycopg.Error as e:
        with open("~view.sql", "w") as f:
            f.write(view_sql)
        print(f"*** Failing:\n{view_sql}\n***")
        raise e
