#!/usr/bin/env bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# create downloads (use get-images.sh instead)
#echo "#!/usr/bin/env bash" > ${DIR}/download.sh
#cat ${DIR}/wiki_list.dat | gsed -r 's@^(.*)\|([0-9](:?\.[0-9]+)+a?) (.*)$@wget -O  images/official/\2.svg https://fr.wikipedia.org/wiki/Repr%C3%A9sentation_de_la_signalisation_routi%C3%A8re_en_Suisse_et_au_Liechtenstein#/media/Fichier:$(echo "\1" | gsed s/ /_/g)@' >> ${DIR}/download.sh
#chmod +x ${DIR}/download.sh

# create insert SQL
cat ${DIR}/wiki_list.dat | gsed "s/’/'/; s/'/''/g" | gsed -r 's@^(.*)\|([0-9](\.[0-9]+)+a?) (.*)$@INSERT INTO siro_vl.official_sign (id, value_en, value_fr, value_de, img) VALUES (\x27\2\x27, \x27\x27, \x27\4\x27, \x27\x27, §\2§);@' > ${DIR}/insert.sql
gsed -i -r 's/§([0-9])\.([0-9]+a?)(\.[0-9])?§/\x27\1\2\3.svg\x27/' ${DIR}/insert.sql


