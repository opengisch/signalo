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
                , {frame_columns}
                , sign.rank AS sign_rank
                , support.id AS support_id
                , support.geometry::geometry(Point,%(SRID)s) AS support_geometry
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
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS TRUE THEN 'mirror.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS FALSE THEN 'mirror-noframe.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_de
                      ELSE NULL::text
                  END AS _img_de
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_fr
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS TRUE THEN 'mirror.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS FALSE THEN 'mirror-noframe.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_fr
                      ELSE NULL::text
                  END AS _img_fr
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_it
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS TRUE THEN 'mirror.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS FALSE THEN 'mirror-noframe.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_it	 
                      ELSE NULL::text
                  END AS _img_it
                , CASE
                      WHEN sign.complex IS TRUE THEN 'complex.svg'::text
                      WHEN sign.fk_sign_type = 11 THEN vl_official_sign.img_ro
                      WHEN sign.fk_sign_type = 12 THEN 'marker.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS TRUE THEN 'mirror.svg'::text
                      WHEN sign.fk_sign_type = 13 AND sign.mirror_red_frame IS FALSE THEN 'mirror-noframe.svg'::text
                      WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'::text
                      WHEN sign.fk_sign_type = 15 THEN vl_user_sign.img_ro	 
                      ELSE NULL::text
                  END AS _img_ro
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
        ordered_recto_signs AS (
            SELECT
                joined_tables.*
                , ROW_NUMBER () OVER ( PARTITION BY support_id, azimut ORDER BY frame_rank, sign_rank ) AS _final_rank
            FROM joined_tables
            WHERE verso IS FALSE
            ORDER BY support_id, azimut, _final_rank
        ),
        ordered_shifted_recto_signs AS (
            SELECT
                ordered_recto_signs.*
                , COALESCE(SUM( _symbol_height ) OVER ( PARTITION BY support_id, azimut ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ), 0) AS _symbol_shift
                , NULLIF(FIRST_VALUE(id) OVER (PARTITION BY support_id, azimut, frame_rank ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), id) AS _previous_sign_in_frame
                , NULLIF(LAST_VALUE(id) OVER ( PARTITION BY support_id, azimut, frame_rank ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), id) AS _next_sign_in_frame
                , NULLIF(FIRST_VALUE(frame_id) OVER ( PARTITION BY support_id, azimut ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ), frame_id) AS _previous_frame
                , NULLIF(LAST_VALUE(frame_id) OVER ( PARTITION BY support_id, azimut ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ), frame_id) AS _next_frame
            FROM
                ordered_recto_signs
            ORDER BY
                support_id, azimut, _final_rank
        )
            SELECT * FROM ordered_shifted_recto_signs
        UNION
            SELECT jt.*, osrs._final_rank, osrs._symbol_shift, NULL::uuid AS previous_sign_in_frame, NULL::uuid AS next_sign_in_frame, NULL::uuid AS previous_frame, NULL::uuid AS next_frame
            FROM joined_tables jt
            -- the sign on verso, has rank+1
            LEFT JOIN ordered_shifted_recto_signs osrs ON osrs.support_id = jt.support_id AND osrs.frame_id = jt.frame_id AND jt.sign_rank-1 = osrs.sign_rank
            WHERE jt.verso IS TRUE
        ;

        ALTER VIEW signalo_app.vw_sign_symbol ALTER verso SET DEFAULT false;
        ALTER VIEW signalo_app.vw_sign_symbol ALTER complex SET DEFAULT false;
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

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION signalo_app.ft_vw_sign_symbol_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN

    IF NEW.frame_id IS NULL THEN
        {insert_frame}
    END IF;

    {insert_sign}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_sign_symbol_INSERT ON signalo_app.vw_sign_symbol;

    CREATE TRIGGER vw_sign_symbol_INSERT INSTEAD OF INSERT ON signalo_app.vw_sign_symbol
      FOR EACH ROW EXECUTE PROCEDURE signalo_app.ft_vw_sign_symbol_INSERT();
    """.format(
        insert_frame=insert_command(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="frame",
            remove_pkey=True,
            indent=4,
            skip_columns=["_edited"],
            returning="id INTO NEW.frame_id",
            prefix="frame_",
        ),
        insert_sign=insert_command(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="sign",
            remove_pkey=True,
            indent=4,
            skip_columns=["_edited"],
            remap_columns={"fk_frame": "frame_id", "rank": "sign_rank"},
            returning="id INTO NEW.id",
        ),
    )

    trigger_update_sql = """
    CREATE OR REPLACE FUNCTION signalo_app.ft_vw_signalo_sign_symbol_UPDATE()
      RETURNS trigger AS
    $BODY$
    DECLARE
    BEGIN
      {update_sign}
      {update_frame}
      RETURN NEW;
    END;
    $BODY$
    LANGUAGE plpgsql;

    DROP TRIGGER IF EXISTS ft_vw_signalo_sign_symbol_UPDATE ON signalo_app.vw_sign_symbol;

    CREATE TRIGGER vw_sign_symbol_UPDATE INSTEAD OF UPDATE ON signalo_app.vw_sign_symbol
      FOR EACH ROW EXECUTE PROCEDURE signalo_app.ft_vw_signalo_sign_symbol_UPDATE();
    """.format(
        update_sign=update_command(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="sign",
            indent=4,
            skip_columns=["_edited"],
            remap_columns={"fk_frame": "frame_id", "rank": "sign_rank"},
        ),
        update_frame=update_command(
            pg_cur=cursor,
            table_schema="signalo_db",
            table_name="frame",
            prefix="frame_",
            indent=4,
            skip_columns=["_edited"],
            remap_columns={},
        ),
    )

    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION signalo_app.ft_vw_sign_symbol_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      _sign_count integer;
    BEGIN
      DELETE FROM signalo_db.sign WHERE id = OLD.id;
      SELECT count(id) INTO _sign_count FROM signalo_db.sign WHERE fk_frame = OLD.frame_id;
      IF _sign_count = 0 THEN
        DELETE FROM signalo_db.frame WHERE id = OLD.frame_id;
      END IF;
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_sign_symbol_DELETE ON signalo_app.vw_sign_symbol;

    CREATE TRIGGER vw_sign_symbol_DELETE INSTEAD OF DELETE ON signalo_app.vw_sign_symbol
      FOR EACH ROW EXECUTE PROCEDURE signalo_app.ft_vw_sign_symbol_DELETE();
    """

    for sql in (view_sql, trigger_insert_sql, trigger_update_sql, trigger_delete_sql):
        try:
            cursor.execute(sql, variables)
        except psycopg2.Error as e:
            print(f"*** Failing:\n{sql}\n***")
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
