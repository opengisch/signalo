#!/usr/bin/env bash

# GNU prefix command for bsd/mac os support (gsed, gsplit)
GP=
if [[ "$OSTYPE" == *bsd* ]] || [[ "$OSTYPE" =~ darwin* ]]; then
  GP=g
fi

PGSERVICE=pg_signalo psql -c "SELECT CONCAT(ROW_TO_JSON(t), ',') FROM (SELECT * FROM signalo_db.vl_official_sign) t" | tail -n +3 | ${GP}head -n -2 > official-signs.json
# remove last extra comma
truncate -s -2 official-signs.json
# make a list
echo -e "[\n$(cat official-signs.json)\n]" > official-signs.json
