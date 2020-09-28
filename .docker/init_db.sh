#!/usr/bin/env bash

DB_BASE_NAME=siro

set -e

if [ ! "$#" == "0" ]; then
  if [ ! "$1" == "wait" ] && [ ! "$1" == "release" ] && [ ! "$1" == "release_struct" ] && [ ! "$1" == "build" ] && [ ! "$1" == "build_pum" ]; then
    echo "arg must be one of : 'wait' 'release' 'release_struct' 'build' 'build_pum'"
    exit 1
  fi
fi

printf "waiting for postgres…"
until psql -U postgres -c '\q' > /dev/null 2>&1; do
  printf " 🐘"
  sleep 3
done
echo ""


recreate_db(){
  echo "Database $1 : recreating..."
  psql -U postgres -d postgres -o /dev/null -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$1'"
  dropdb -U postgres --if-exists $1
  createdb -U postgres $1
}

if [ "$1" == "wait" ]; then
  printf "initializing DB…"
  until [ -f ${PGDATA}/entrypoint-done-flag ]; do
    printf " 🐘"
    sleep 3
  done
  echo ""
  echo "Initialization complete !"
  # Let some time for postgres to restart...
  sleep 3
  exit 0
fi

if [ "$1" == "release" ]; then
  if [ "$2" == "" ]; then
    echo 'you must provide the release version as second argument'
    exit 1
  fi

  echo '----------------------------------------'
  echo "Installing demo data from release"

  FILE="/downloads/${2}.backup"

  if [ ! -f "$FILE" ]; then
    wget -nv https://github.com/opengisch/signalisation_verticale/releases/download/${2}/qgep_v${2}_structure_and_demo_data.backup -O $FILE
  fi

  recreate_db "${DB_BASE_NAME}_release"
  pg_restore -U postgres --dbname ${DB_BASE_NAME}_release --verbose --exit-on-error "$FILE"

  echo "Done ! Database can now be used."
  echo '----------------------------------------'

fi

if [ "$#" == "0" ] || [ "$1" == "build" ]; then

  recreate_db "${DB_BASE_NAME}_build"
  echo '----------------------------------------'
  echo "Building database normally"

  PGSERVICE=${DB_BASE_NAME}_build ./data_model/setup.sh ${@:2}

  echo "Done ! Database ${DB_BASE_NAME}_build can now be used."
  echo '----------------------------------------'

fi

if [ "$1" == "build_pum" ]; then

  recreate_db "${DB_BASE_NAME}_build_pum"
  echo '----------------------------------------'
  echo "Building database through pum migrations"

  pum restore -p ${DB_BASE_NAME}_build_pum -x --exclude-schema public --exclude-schema topology -- ./test_data/qgep_demodata_1.0.0.dump
  PGSERVICE=${DB_BASE_NAME}_build_pum psql -v ON_ERROR_STOP=on -f test_data/data_fixes.sql
  pum baseline -p ${DB_BASE_NAME}_build_pum -t ${DB_BASE_NAME}_sys.pum_info -d ./delta/ -b 1.0.0
  pum upgrade -p ${DB_BASE_NAME}_build_pum -t ${DB_BASE_NAME}_sys.pum_info -d ./delta/ -v int SRID 2056

  echo "Done ! Database ${DB_BASE_NAME}_build_pum can now be used."
  echo '----------------------------------------'

fi

# echo '----------------------------------------'
# echo "Updating postgis if needed"
# update-postgis.sh

echo "done" > ${PGDATA}/entrypoint-done-flag
