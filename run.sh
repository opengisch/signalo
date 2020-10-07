#!/usr/bin/env bash


set -e


docker build -f .docker/Dockerfile --tag opengisch/siro .

docker rm -f siro || true

# start the server
# -v mounts the source, so that changes to the datamodel don't require rebuild
# --rm delete the container when it stops (the data won't be persisted !)
docker run -d -p 5432:5432 --name siro opengisch/siro

docker exec -e PGSERVICE=pg_siro siro sh -c "init_db.sh wait"
