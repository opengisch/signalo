#!/usr/bin/env python3
#
# -- View: vw_sign_symbol

import argparse
import os
import psycopg2
from pirogue.utils import select_columns, insert_command, update_command, table_parts


def vw_sign_symbol(srid: int, pg_service: str = None):
    """
    Creates sign_symbol view
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
                {sign_columns}
                , azimut.azimut
                , {frame_columns}
                , sign.rank AS sign_rank
                , support.id AS support_id
                , support.geometry::geometry(Point,%(SRID)s) AS support_geometry
                , official_sign.value_de as _symbol_value_de
                , official_sign.value_fr as _symbol_value_fr
                , official_sign.value_it as _symbol_value_it
                , official_sign.value_ro as _symbol_value_ro
                , CASE 
                  WHEN fk_sign_type = 11 THEN official_sign.img_de 
                  WHEN fk_sign_type = 12 THEN 'marker.svg' 
                  WHEN fk_sign_type = 13 THEN 'mirror.svg' 
                  WHEN fk_sign_type = 14 THEN 'street-plate.svg' 
                END as _img_de
                , CASE 
                  WHEN fk_sign_type = 11 THEN official_sign.img_fr
                  WHEN fk_sign_type = 12 THEN 'marker.svg' 
                  WHEN fk_sign_type = 13 THEN 'mirror.svg' 
                  WHEN fk_sign_type = 14 THEN 'street-plate.svg' 
                END as _img_fr
                , CASE 
                  WHEN fk_sign_type = 11 THEN official_sign.img_it
                  WHEN fk_sign_type = 12 THEN 'marker.svg' 
                  WHEN fk_sign_type = 13 THEN 'mirror.svg' 
                  WHEN fk_sign_type = 14 THEN 'street-plate.svg' 
                END as _img_it
                , CASE 
                  WHEN fk_sign_type = 11 THEN official_sign.img_ro
                  WHEN fk_sign_type = 12 THEN 'marker.svg' 
                  WHEN fk_sign_type = 13 THEN 'mirror.svg' 
                  WHEN fk_sign_type = 14 THEN 'street-plate.svg' 
                END as _img_ro
                , CASE 
                  WHEN fk_sign_type = 11 THEN official_sign.img_height
                  WHEN fk_sign_type = 12 THEN 130
                  WHEN fk_sign_type = 13 THEN 100
                  WHEN fk_sign_type = 14 THEN 100
                END as _symbol_height
                , CASE 
                  WHEN fk_sign_type = 11 THEN official_sign.img_width
                  WHEN fk_sign_type = 12 THEN 70
                  WHEN fk_sign_type = 13 THEN 100
                  WHEN fk_sign_type = 14 THEN 130
                END as _symbol_width
            FROM siro_od.sign
                LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
                LEFT JOIN siro_od.azimut ON azimut.id = frame.fk_azimut
                LEFT JOIN siro_od.support ON support.id = azimut.fk_support
                LEFT JOIN siro_vl.official_sign ON official_sign.id = sign.fk_official_sign
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
            LEFT JOIN ordered_shifted_recto_signs osrs ON osrs.support_id = jt.support_id AND osrs.frame_id = jt.frame_id AND jt.sign_rank = osrs.sign_rank 
            WHERE jt.verso IS TRUE   
        ;
        
        ALTER VIEW siro_od.vw_sign_symbol ALTER verso SET DEFAULT false;
    """.format(
        sign_columns=select_columns(
            pg_cur=cursor, table_schema='siro_od', table_name='sign',
            remove_pkey=False, indent=4, skip_columns=['rank', 'fk_frame']
        ),
        frame_columns=select_columns(
            pg_cur=cursor, table_schema='siro_od', table_name='frame',
            remove_pkey=False, indent=4,
            prefix='frame_'
        ),
        vl_official_sign_columns=select_columns(
            pg_cur=cursor, table_schema='siro_vl', table_name='official_sign',
            remove_pkey=False, indent=4, prefix='vl_official_sign_'
        ),
    )

    trigger_insert_sql = """
    CREATE OR REPLACE FUNCTION siro_od.ft_vw_sign_symbol_INSERT()
      RETURNS trigger AS
    $BODY$
    BEGIN
    
    IF NEW.frame_id IS NULL THEN
        {insert_frame}
    END IF;

    {insert_sign}

      RETURN NEW;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_sign_symbol_INSERT ON siro_od.vw_sign_symbol;

    CREATE TRIGGER vw_sign_symbol_INSERT INSTEAD OF INSERT ON siro_od.vw_sign_symbol
      FOR EACH ROW EXECUTE PROCEDURE siro_od.ft_vw_sign_symbol_INSERT();
    """.format(
        insert_frame=insert_command(
            pg_cur=cursor, table_schema='siro_od', table_name='frame', remove_pkey=True, indent=4,
            skip_columns=[], returning='id INTO NEW.frame_id', prefix='frame_'
        ),
        insert_sign=insert_command(
            pg_cur=cursor, table_schema='siro_od', table_name='sign', remove_pkey=True, indent=4,
            skip_columns=[], remap_columns={'fk_frame': 'frame_id', 'rank': 'sign_rank'}, returning='id INTO NEW.id'
        )
    )
    
    trigger_update_sql = """
    CREATE OR REPLACE FUNCTION siro_od.ft_vw_siro_sign_symbol_UPDATE()
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

    DROP TRIGGER IF EXISTS ft_vw_siro_sign_symbol_UPDATE ON siro_od.vw_sign_symbol;

    CREATE TRIGGER vw_sign_symbol_UPDATE INSTEAD OF UPDATE ON siro_od.vw_sign_symbol
      FOR EACH ROW EXECUTE PROCEDURE siro_od.ft_vw_siro_sign_symbol_UPDATE();
    """.format(
        update_sign=update_command(
            pg_cur=cursor, table_schema='siro_od', table_name='sign',
            indent=4, skip_columns=[], remap_columns={'fk_frame': 'frame_id', 'rank': 'sign_rank'}
        ),
        update_frame=update_command(
            pg_cur=cursor, table_schema='siro_od', table_name='frame', prefix='frame_',
            indent=4, skip_columns=[], remap_columns={}
        )
    )
    
    trigger_delete_sql = """
    CREATE OR REPLACE FUNCTION siro_od.ft_vw_sign_symbol_DELETE()
      RETURNS trigger AS
    $BODY$
    DECLARE
      _sign_count integer;
    BEGIN
      DELETE FROM siro_od.sign WHERE id = OLD.id;
      SELECT count(id) INTO _sign_count FROM siro_od.sign WHERE fk_frame = OLD.frame_id;
      IF _sign_count = 0 THEN
        DELETE FROM siro_od.frame WHERE id = OLD.frame_id;
      END IF;   
    RETURN OLD;
    END; $BODY$ LANGUAGE plpgsql VOLATILE;

    DROP TRIGGER IF EXISTS vw_sign_symbol_DELETE ON siro_od.vw_sign_symbol;

    CREATE TRIGGER vw_sign_symbol_DELETE INSTEAD OF DELETE ON siro_od.vw_sign_symbol
      FOR EACH ROW EXECUTE PROCEDURE siro_od.ft_vw_sign_symbol_DELETE();
    """

    for sql in (view_sql, trigger_insert_sql, trigger_update_sql, trigger_delete_sql):
        try:
            cursor.execute(sql, variables)
        except psycopg2.Error as e:
            print("*** Failing:\n{}\n***".format(sql))
            raise e
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