#!/bin/bash

apt-get install -y imagemagick

rm -f update.sql
touch update.sql
for img in /src/images/official/*.svg; do
    echo $img
    file=$(basename ${img})
    convert ${img} img.png
    HEIGHT=$(identify -format '%h\n' img.png)
    WIDTH=$(identify -format '%w\n' img.png)
    SQL="UPDATE signalo_db.vl_official_sign SET img_width = img_height*${WIDTH}/${HEIGHT} WHERE img_de = '${file}' OR  img_fr = '${file}' OR  img_it = '${file}' OR  img_ro = '${file}';"
    echo "${SQL}" >> update.sql
    rm img.png
done

PGSERVICE=pg_signalo psql -v ON_ERROR_STOP=on -f update.sql