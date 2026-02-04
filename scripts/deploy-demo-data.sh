#!/usr/bin/env bash

set -euxo pipefail

#docker build -f datamodel/.docker/Dockerfile --tag signalo:unstable .

docker rm -f signalo-demo-data-uploader || true

docker run -d -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -e PGSERVICE="signalo_remote_testing" \
  -v ~/.pg_service.conf:/etc/postgresql-common/pg_service.conf \
  --name signalo-demo-data-uploader signalo:unstable

DEMO_DATA="Lausanne"

docker exec signalo-demo-data-uploader psql -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS signalo_app CASCADE; DROP SCHEMA IF EXISTS signalo_db CASCADE;"
docker exec signalo-demo-data-uploader pum -vvv -p signalo_remote_testing -d datamodel install -p SRID 2056 --demo-data ${DEMO_DATA}
