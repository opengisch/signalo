#!/usr/bin/env bash


set -e


docker build -f .docker/Dockerfile --tag opengisch/siro .

docker rm siro || true

# start the server
# -v mounts the source, so that changes to the datamodel don't require rebuild
# --rm delete the container when it stops (the data won't be persisted !)
docker run -d -p 5432:5432 -v "$(pwd):/src" --name siro opengisch/siro

docker exec -e PGSERVICE=siro_build siro "init_db.sh build"