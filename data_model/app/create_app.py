#!/usr/bin/env python3

import psycopg2
import argparse
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__)))

from vw_sign_symbol import vw_sign_symbol


def run_sql(file_path: str, pg_service: str, variables: dict = {}):
    sql = open(file_path).read()
    conn = psycopg2.connect("service={0}".format(pg_service))
    cursor = conn.cursor()
    cursor.execute(sql, variables)
    conn.commit()
    conn.close()


def create_views(srid: int,
                 pg_service: str):
    """
    Creates the views for QGEP
    :param srid: the EPSG code for geometry columns
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    """

    variables = {'SRID': srid}

    run_sql('data_model/views/drop_views.sql', pg_service, variables)

    run_sql('data_model/views/vw_edited_support.sql', pg_service, variables)
    vw_sign_symbol(pg_service=pg_service, srid=srid)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--pg_service', help='postgres service')
    parser.add_argument('-s', '--srid', help='SRID EPSG code, defaults to 2056', type=int, default=2056)
    args = parser.parse_args()

    create_views(args.srid, args.pg_service)
