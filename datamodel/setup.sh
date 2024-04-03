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
  PGSERVICE=pg_signalo
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
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS signalo_db CASCADE";
fi
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0001/0001_1.sql

psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0002/0002_1_sign-5.00.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0003/0003_fix_img_size.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0004/0004_fix_img_size_followup.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0005/0005_fix_vls.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0006/0006_delete_en.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0006/0006_translate_de.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0006/0006_new_signs.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0006/0006_user_signs.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_01_anchor-point.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_02_support_photo2.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_03_add_signs_img.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_04_indexes.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_05_change_official.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_06_direction_user_signs.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_07_missing_left_right.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_08_477_signs.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_09_exceptes.sql
psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -v SRID=${SRID} -f ${DIR}/changelogs/0100/0100_10_dms.sql

if [[ $demo_data == True ]]; then
  echo "*** inserting demo_data"
  # for now demo data is the test data
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/owner_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/vl_user_sign_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/support_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/azimut_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/frame_content.sql
  psql "service=${PGSERVICE}" -v ON_ERROR_STOP=1 -f ${DIR}/demo_data/sign_content.sql
fi

${DIR}/app/create_app.py --pg_service ${PGSERVICE} --srid=${SRID}
