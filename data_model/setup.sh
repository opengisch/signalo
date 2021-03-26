#!/bin/bash

# This script will create a clean datastructure for the QGEP project based on
# the SIA 405 datamodel.
# It will create a new schema qgep in a postgres database.
#
# Environment variables:
#
#  * PGSERVICE
#      Specifies the postgres database to be used
#        Defaults to pg_qgep
#
#      Examples:
#        export PGSERVICE=pg_qgep
#        ./db_setup.sh

# Exit on error
set -e

SRID=2056

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ -z ${PGSERVICE} ]]; then
  PGSERVICE=pg_siro
fi


while getopts ":drfs:p:" opt; do
  case $opt in
    f)
      force=True
      ;;
    r)
      roles=True
      ;;
    d)
      demo_data=True
      ;;
    s)
      SRID=$OPTARG
      echo "-s was triggered, SRID: $SRID" >&2
      ;;
    p)
      PGSERVICE=$OPTARG
      echo "-p was triggered, PGSERVICE: $PGSERVICE" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


if [[ $force == True ]]; then
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS siro_od CASCADE";
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS siro_vl CASCADE";
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS siro_sys CASCADE";
fi
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/schema.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/durability.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/sign_type.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/frame_type.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/frame_fixing_type.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/support_type.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/support_base_type.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/status.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/lighting.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/coating.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/official_sign.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/mirror_shape.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/marker_type.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/value_lists/official_sign_content.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/ordinary_data/owner.sql
psql "service=${PGSERVICE}" -v SRID=${SRID} -v ON_ERROR_STOP=1 -f ${DIR}/ordinary_data/support.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/ordinary_data/azimut.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/ordinary_data/frame.sql
psql "service=${PGSERVICE}" -v SRID=${SRID} -v PROJECT_EXTENT="ST_Polygon('LINESTRING(2474690 1290547, 2827252 1290547, 2827252 1045122, 2474690 1045122, 2474690 1290547)'::geometry, ${SRID})" -v ON_ERROR_STOP=1 -f ${DIR}/ordinary_data/sign.sql

if [[ $demo_data == True ]]; then
  echo "*** inserting demo_data"
  # for now demo data is the test data
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/owner_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/support_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/azimut_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/frame_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/sign_content.sql
fi

${DIR}/views/create_views.py --pg_service ${PGSERVICE} --srid=${SRID}

VERSION=$(cat ${DIR}/../CURRENT_VERSION.txt)
pum baseline -p ${PGSERVICE} -t siro_sys.pum_info -d ${DIR}/delta/ -b ${VERSION}