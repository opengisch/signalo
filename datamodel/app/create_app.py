#!/usr/bin/env python3

import argparse
import logging
import os
import sys
from pathlib import Path

import psycopg
from pirogue import SimpleJoins
from pum import HookBase
from yaml import safe_load

sys.path.append(os.path.join(os.path.dirname(__file__)))
from vw_sign_symbol import vw_sign_symbol

logger = logging.getLogger(__name__)


class Hook(HookBase):
    def run_hook(
        self,
        connection: psycopg.Connection,
        SRID: int = 2056,
    ):
        """
        Creates the application schema signalo_app for SIGNALO application data.
        :param connection: the psycopg connection to the database.
        :param SRID: the EPSG code for geometry columns
        """

        self.execute(Path("datamodel") / "app" / "create_schema.sql")
        self.execute(Path("datamodel") / "app" / "vw_validation.sql")
        self.execute(Path("datamodel") / "app" / "vw_azimut_edit.sql")

        vw_sign_symbol(connection=connection, srid=SRID)

        SimpleJoins(
            safe_load(open("datamodel/app/vw_sign_export.yaml")), connection=connection
        ).create()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    parser.add_argument(
        "--drop_schema",
        help="Drop existing signalo_app schema before creating it",
        action="store_true",
    )
    args = parser.parse_args()

    pg_service = args.pg_service
    if not pg_service:
        pg_service = os.getenv("PGSERVICE")
    assert pg_service

    with psycopg.connect(f"service={pg_service}") as connection:
        if args.drop_schema:
            connection.execute("DROP SCHEMA IF EXISTS signalo_app CASCADE;")
        hook = Hook()
        hook._prepare(connection=connection, parameters={"SRID": args.srid})
        hook.run_hook(
            connection=connection,
            SRID=args.srid,
        )
