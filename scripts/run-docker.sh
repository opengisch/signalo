#!/usr/bin/env bash

set -e

# load env vars
# https://stackoverflow.com/a/20909045/1548052
export $(grep -v '^#' .env | xargs)

BUILD=0
DEMO_DATA=""
TEST=0
SIGNALO_PG_PORT=${SIGNALO_PG_PORT:-5432}
ROLES=""


show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]... [ARGUMENTS]..."
    echo
    echo "Description:"
    echo "  Build and run Docker container with SIGNALO application"
    echo
    echo "Options:"
    echo "  -h      Display this help message and exit"
    echo "  -b      Build Docker image"
    echo "  -d      Load demo data"
    echo "  -r      Create roles"
    echo "  -p      Override PG port"
    echo "  -t      Run tests"
}

while getopts 'bdrtp:h' opt; do
  case "$opt" in
    b)
      echo "Rebuild docker image"
      BUILD=1
      ;;

    d)
      echo "Load demo data"
      DEMO_DATA="-d"
      ;;

    p)
      echo "Overriding PG port to ${OPTARG}"
      TWW_PG_PORT=${OPTARG}
      ;;
    r)
      echo "Setting up roles"
      ROLES="-r"
      ;;
    t)
      echo "Run tests"
      TEST=1
      ;;
    ?|h)
      show_help
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
docker exec signalo init_db.sh build ${DEMO_DATA} ${ROLES}

if [[ $TEST -eq 1 ]]; then
  docker exec signalo pytest
fi
