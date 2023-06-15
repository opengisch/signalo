#!/usr/bin/env bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Download zips from https://www.astra.admin.ch/astra/fr/home/documentation/regles-de-la-circulation/signaux.html
# Extract them and set location:
NEW_IMAGE_PATH=${DIR}/../../project/images/_inbox
TO_IMPORT_PATH=${DIR}/../../project/images/_to_import

mkdir -p ${TO_IMPORT_PATH}

cd ${TO_IMPORT_PATH}

for subdir in $(find ${NEW_IMAGE_PATH} -type d -maxdepth 1 -mindepth 1); do
  echo "scanning $subdir..."
  for file in ${subdir}/*.eps; do
    bfile=$(basename $file)
    output_pdf=${bfile%.eps}.pdf
    output_svg=${bfile%.eps}.svg
    output_svg_left=${bfile%.eps}-l.svg
    output_svg_right=${bfile%.eps}-r.svg
    output_svg_left_one=${bfile%.eps}-1-l.svg
    if [[ ! -f ${DIR}/../../project/images/official/original/${output_svg} && \
          ! -f ${DIR}/../../project/images/official/original/${output_svg_left} && \
          ! -f ${DIR}/../../project/images/official/original/${output_svg_right} && \
          ! -f ${DIR}/../../project/images/official/original/${output_svg_left_one} ]]; then
      echo "new image: $output_svg"
      cp ${file} .
      epstopdf ${bfile}
      pdf2svg ${output_pdf} ${output_svg}
    fi
  done
done

rm ${TO_IMPORT_PATH}/*.eps
rm ${TO_IMPORT_PATH}/*.pdf
