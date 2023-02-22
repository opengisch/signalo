#!/usr/bin/env bash

TABLES=( sign azimut frame support )

export PGSERVICE=pg_signalo

for TABLE in "${TABLES[@]}"; do
  pg_dump --data-only -t signalo_db.${TABLE} --column-inserts | gsort | gsed '/^INSERT/!d' > data_model/demo_data/${TABLE}_content.sql
done
