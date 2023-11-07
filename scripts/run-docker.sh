#!/usr/bin/env bash

set -e

docker build -f .docker/Dockerfile --tag opengisch/signalo .
docker run -d -p 5433:5432 -v $(pwd):/src  --name signalo opengisch/signalo
docker exec signalo init_db.sh wait
docker exec signalo init_db.sh build -d
