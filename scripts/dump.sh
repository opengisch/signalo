#!/usr/bin/env bash

docker exec signalo pg_dump --format=plain --exclude-schema=public --column-inserts --file=dump.sql signalo