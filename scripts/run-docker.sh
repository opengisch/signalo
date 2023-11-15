#!/usr/bin/env bash

set -e

BUILD=0

while getopts 'b' opt; do
  case "$opt" in
    b)
      echo "Processing option 'a'"
      BUILD=1
      ;;

    ?|h)
      echo "Usage: $(basename $0) [-b]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
if [[ $BUILD -eq 1 ]]; then
  docker build -f .docker/Dockerfile --tag opengisch/signalo .
fi

docker rm -f signalo || true
docker run -d -p 5433:5432 -v $(pwd):/src  --name signalo opengisch/signalo
docker exec signalo init_db.sh wait
docker exec signalo init_db.sh build -d
