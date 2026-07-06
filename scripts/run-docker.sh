#!/usr/bin/env bash

set -euo pipefail

# load env vars
# https://stackoverflow.com/a/20909045/1548052
if [ -f .env ]; then
  echo "Loading .env file"
  export $(grep -v '^#' .env | xargs)
elif [ -f .env.example ]; then
  echo "Loading .env.example file since .env is missing"
  export $(grep -v '^#' .env.example | xargs)
fi


PUM_GH_SHA=${PUM_GH_SHA:-}

BUILD=0
DEMO_DATA=
LOAD=

while getopts 'bdql:' opt; do
  case "$opt" in
    b)
      echo "Rebuild docker image"
      BUILD=1
      ;;

    d)
      echo "Load demo data"
      DEMO_DATA="-d ${DEMO_DATA_NAME}"
      ;;

    q)
      echo "enable QGIS"
      export COMPOSE_PROFILES=qgis
      ;;

    l)
      echo "Load heavy test data (${OPTARG}x official signs)"
      LOAD="${OPTARG}"
      ;;
    ?|h)
      echo "Usage: $(basename $0) [-bdq] [-l MULTIPLIER]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

 docker compose down -v  --remove-orphans || true

if [[ $BUILD -eq 1 ]]; then
  docker compose build --no-cache
fi

docker compose up -d

docker compose run --rm pum --version

until docker compose exec db pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "Creating database ${DB_NAME}"
docker compose exec db sh -c "createdb -U postgres ${DB_NAME}"
docker compose run --rm pum -vvv -p ${PGSERVICE} -d datamodel install -p SRID 2056 ${DEMO_DATA}

if [[ -n "${LOAD}" ]]; then
  echo "Generating heavy test data (${LOAD}x official signs)"
  docker compose run --rm \
    -e PGSERVICE=${PGSERVICE} \
    -e PGSERVICEFILE=/.pg_service.conf \
    --entrypoint python3 \
    pum /pum/scripts/all-signs.py "${LOAD}"
fi
