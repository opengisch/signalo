#!/usr/bin/env bash

set -e

# load env vars
# https://stackoverflow.com/a/20909045/1548052
export $(grep -v '^#' .env | xargs)

BUILD=0
DEMO_DATA=0
SIGNALO_PG_PORT=${TWW_PG_PORT:-5432}

while getopts 'bdp:' opt; do
  case "$opt" in
    b)
      echo "Rebuild docker image"
      BUILD=1
      ;;

    d)
      echo "Load demo data"
      DEMO_DATA=1
      ;;

    p)
      echo "Overriding PG port to ${OPTARG}"
      TWW_PG_PORT=${OPTARG}
      ;;


    ?|h)
      echo "Usage: $(basename $0) [-bd] [-p PG_PORT]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [[ $BUILD -eq 1 ]]; then
  docker build -f .docker/Dockerfile --tag opengisch/signalo .
fi

docker rm -f signalo || true
docker run -d -p ${SIGNALO_PG_PORT}:5432 -v $(pwd):/src --name signalo opengisch/signalo -c log_statement=all
docker exec signalo init_db.sh wait
if [[ $DEMO_DATA -eq 1 ]]; then
  docker exec signalo init_db.sh build -d
fi
