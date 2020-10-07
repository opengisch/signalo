#!/usr/bin/env bash

DB_BASE_NAME=siro

set -e

if [ ! "$#" == "0" ]; then
  if [ ! "$1" == "wait" ] && [ ! "$1" == "build" ] && [ ! "$1" == "build_demo" ]; then
    echo "arg must be one of : 'wait' 'build' 'build_demo'"
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
  COUNT=0
  printf "initializing DB…"
  until [[ -f ${PGDATA}/entrypoint-done-flag ]] || [[ $(( COUNT++ )) -eq 10 ]]; do
    printf " 🐘"
    sleep 3
  done
  echo ""
  echo "Initialization complete !"
  exit 0
fi

if [ "$#" == "0" ] || [ "$1" == "build" ]; then

  # we expect the service to have the same name than the DB
  recreate_db "${PGSERVICE}"
  echo '----------------------------------------'
  echo "Building database normally (passing argument: ${@:2})"

  ./data_model/setup.sh ${@:2}

  echo "Done ! Database ${PGSERVICE}_build can now be used."
  echo '----------------------------------------'

fi

if [ "$1" == "build_demo" ]; then

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
