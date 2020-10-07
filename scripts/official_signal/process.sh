#!/usr/bin/env bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# create insert SQL for french (from wikipedia)
#cat ${DIR}/wiki_list.dat | gsed "s/’/'/; s/'/''/g" | gsed -r 's@^(.*)\|([0-9](\.[0-9]+)+a?) (.*)$@INSERT INTO siro_vl.official_sign (id, value_fr, img_de, img_fr, img_it, img_ro) VALUES (\x27\2\x27, \x27\4\x27, §\2§, §\2§, §\2§, §\2§);@' > ${DIR}/insert.sql
#gsed -i -r 's/§([0-9])\.([0-9]+a?)(\.[0-9])?§/\x27\1\2\3.svg\x27/g' ${DIR}/insert.sql
#gsed -i -r 's/\.([0-9])\.svg/-\1.svg/g' ${DIR}/insert.sql

export PGSERVICE=pg_siro
cat ${DIR}/list_de.dat | \
gsed -r 's/(«|»)/\x27\x27/g' | \
gsed -r 's/([0-9.]+) (.*?) \([Aa]rt\.? .*\) *$/UPDATE siro_vl.official_sign SET  value_de = \x27\2\x27 WHERE id LIKE \x27\1%\x27;/' | \
psql -v ON_ERROR_STOP=on

cat ${DIR}/list_it.dat | \
gsed -r 's/(«|»)/\x27\x27/g' | \
gsed -r 's/([0-9.]+) (.*?) \([Aa]rt\.? .*\) *$/UPDATE siro_vl.official_sign SET  value_it = \x27\2\x27 WHERE id LIKE \x27\1%\x27;/' | \
psql -v ON_ERROR_STOP=on


echo "revision"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Radfahrer'	, value_fr = 'Cyclistes'	, value_it = 'Ciclisti'		WHERE id LIKE '1.32%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Wegweiser «Route für Fahrräder» (Beispiel)'	, value_fr = 'Indicateur de direction «Itinéraire pour cyclistes» (exemple)'	, value_it = 'Indicatore di direzione «Percorso raccomandato per velocipedi» (Esempio)'		WHERE id LIKE '4.50.1%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Wegweiser «Route für Mountainbikes» (Beispiel)'	, value_fr = 'Indicateur de direction «Itinéraire pour vélos tout terrain» (exemple)'	, value_it = 'Indicatore di direzione «Percorso per mountain-bike» (Esempio)'		WHERE id LIKE '4.50.3%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Wegweiser «Route für fahrzeugähnliche Geräte» (Beispiel)'	, value_fr = 'Indicateur de direction «Itinéraire pour engins assimilés à des véhicules» (exemple)'	, value_it = 'Indicatore di direzione «Percorso per mezzi simili a veicoli» (Esempio)'		WHERE id LIKE '4.50.4%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Wegweiser in Tabellenform für einen einzigen Adressatenkreis (Beispiel)'	, value_fr = 'Indicateur de direction en forme de tableau destiné à un seul cercle d''usagers (exemple)'	, value_it = 'Indicatore di direzione a forma di tabella per una sola cerchia di utilizzatori (Esempio)'		WHERE id LIKE '4.50.5%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Wegweiser in Tabellenform für mehrere Adressatenkreise (Beispiel)'	, value_fr = 'Indicateur de direction en forme de tableau destiné à plusieurs cercles d''usagers (exemple)'	, value_it = 'Indicatore di direzione a forma di tabella per più cherchie di utilizzatori (Esempio)'		WHERE id LIKE '4.50.6%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Wegweiser ohne Zielangabe (Beispiel)'	, value_fr = 'Indicateur de direction sans destination (exemple)'	, value_it = 'Indicatore di direzione senza destinazione (Esempio)'		WHERE id LIKE '4.51.1%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Vorwegweiser ohne Zielangabe (Beispiel)'	, value_fr = 'Indicateur de direction avancé sans destination (exemple)'	, value_it = 'Indicatore di direzione avanzato senza destinazione (Esempio)'		WHERE id LIKE '4.51.2%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Bestätigungstafel (Beispiel)'	, value_fr = 'Plaque de confirmation (exemple)'	, value_it = 'Cartello di conferma (Esempio)'		WHERE id LIKE '4.51.3%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Endetafel (Beispiel)'	, value_fr = 'Plaque indiquant la fin d''un itinéraire (exemple)'	, value_it = 'Cartello di fine percorso (Esempio)'		WHERE id LIKE '4.51.4%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Kilometertafel'	, value_fr = 'Plaque indiquant le nombre de kilomètres'	, value_it = 'Cartello indicante i chilometri'		WHERE id LIKE '4.72%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Hektometertafel'	, value_fr = 'Plaque indiquant le nombre d''hectomètre'	, value_it = 's Cartello indicante gli ettometri'		WHERE id LIKE '4.73%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Feuerlöscher'	, value_fr = 'Extincteur'	, value_it = 'Estintore'		WHERE id LIKE '4.92%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Anzeige der allgemeinen Höchstgeschwindigkeiten'	, value_fr = 'Information sur les limitations générales de vitesse'	, value_it = 'Informazioni sui limiti generali di velocità'		WHERE id LIKE '4.93%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Richtung und Entfernung zum Nächsten Notausgang'	, value_fr = 'Direction et distance vers l''issue de secours la plus proche'	, value_it = 'Direzione della prossima uscita die sicurezza e distanza da essa'		WHERE id LIKE '4.94%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Notausgang'	, value_fr = 'Issue de secours'	, value_it = 'Uscita di sicurezza'		WHERE id LIKE '4.95%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Traktor'	, value_fr = 'Tracteur'	, value_it = 'Trattore'		WHERE id LIKE '5.36%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Spital mit Notfallstation'	, value_fr = 'Hôpital avec service d''urgence'	, value_it = 'Ospedale con pronto soccorso'		WHERE id LIKE '5.56%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Notfalltelefon'	, value_fr = 'Téléphone de secours'	, value_it = 'Telefono d''emergenza'		WHERE id LIKE '5.57%';"
psql -c"UPDATE siro_vl.official_sign SET		value_de = 'Feuerlöscher'	, value_fr = 'Extincteur'	, value_it = 'Estintore'		WHERE id LIKE '5.58%';"

pg_dump --data-only -t siro_vl.official_sign --column-inserts | gsort > output