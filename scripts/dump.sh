#!/usr/bin/env bash

docker exec signalo pg_dump --format=plain --exclude-schema=public --exclude-schema=app --column-inserts --file=dump-db.sql signalo
docker exec signalo pg_dump --format=plain --schema=app --column-inserts --file=dump-app.sql signalo