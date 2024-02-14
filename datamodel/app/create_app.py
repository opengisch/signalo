#!/usr/bin/env python3

import argparse
import os
import sys

import psycopg2
from pirogue import SimpleJoins
from yaml import safe_load

sys.path.append(os.path.join(os.path.dirname(__file__)))

from vw_sign_symbol import vw_sign_symbol


def run_sql(file_path: str, pg_service: str, variables: dict = {}):
    sql = open(file_path).read()
    conn = psycopg2.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql, variables)
    conn.commit()
    conn.close()


def create_views(srid: int, pg_service: str):
    """
    Creates the views for QGEP
    :param srid: the EPSG code for geometry columns
    :param pg_service: the PostgreSQL service, if not given it will be determined from environment variable in Pirogue
    """

    variables = {"SRID": srid}

    run_sql("datamodel/app/drop_schema.sql", pg_service, variables)

    run_sql("datamodel/app/create_schema.sql", pg_service, variables)

    run_sql("datamodel/app/vw_edited_support.sql", pg_service, variables)
    run_sql("datamodel/app/vw_azimut_edit.sql", pg_service, variables)

    vw_sign_symbol(pg_service=pg_service, srid=srid)

    SimpleJoins(
        safe_load(open("datamodel/app/vw_sign_export.yaml")), pg_service
    ).create()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    args = parser.parse_args()

    pg_service = args.pg_service
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service

    create_views(args.srid, pg_service)
