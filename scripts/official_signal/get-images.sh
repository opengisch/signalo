#!/usr/bin/env bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


SIGN_RANGES=(101-132 201-265 301-325 401-495 501-558)

rm -rf ${DIR}/temp

for SIGN_RANGE in "${SIGN_RANGES[@]}"; do
  wget https://www.astra.admin.ch/dam/astra/fr/dokumente/abteilung_strassenverkehrallgemein/verkehrsregeln/signale_${SIGN_RANGE}.zip.download.zip/signaux_${SIGN_RANGE}.zip
  unzip signaux_${SIGN_RANGE}.zip -d signaux_${SIGN_RANGE}
  for file in signaux_${SIGN_RANGE}/*.eps; do
    file=$(basename $file)
    echo $file
    output_pdf=${file%.eps}.pdf
    output_svg=${file%.eps}.svg
    epstopdf signaux_${SIGN_RANGE}/${file}
    pdf2svg signaux_${SIGN_RANGE}/${output_pdf} ${DIR}/../../images/official/${output_svg}
  done
  rm -rf signaux_${SIGN_RANGE}
done