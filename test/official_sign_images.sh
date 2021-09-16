#!/usr/bin/env bash

set -e


return_code=0

_IMG_DIRS=(editable original)
for _IMG_DIR in "${_IMG_DIRS[@]}"; do
  DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../project/images/official/${_IMG_DIR}

  _LANGUAGES=(de fr it ro)
  for _LANGUAGE in "${_LANGUAGES[@]}"; do
    IMAGES=$(psql -t -c "SELECT img_${_LANGUAGE} FROM signalo_db.vl_official_sign")
    for IMAGE in ${IMAGES}; do
      if [[ ! -f ${DIR}/${IMAGE} ]]; then
        FID=$(psql -t -c "SELECT id FROM signalo_db.vl_official_sign WHERE img_${_LANGUAGE} = '${IMAGE}'")
        echo "*** Image ${IMAGE} (id:${FID}) does not exist in ./project/images/official/${_IMG_DIR}"
        return_code=1
      fi
    done
  done

  for FILE in ${DIR}/*.svg; do
    IMAGE=$(basename ${FILE})
    COUNT=$(psql -t -c "SELECT COUNT(id) FROM signalo_db.vl_official_sign WHERE img_de='${IMAGE}' OR  img_fr='${IMAGE}' OR  img_it='${IMAGE}' OR  img_ro='${IMAGE}'")
    if [[ ${COUNT} -ne "1" ]]; then
      echo "*** Image ${IMAGE} is not used once in signalo_db.vl_official_sign"
      return_code=1
    elif [[ ${_IMG_DIR} = editable ]]; then
      ih=$(exiftool -ImageHeight ${FILE} | sed "s/.*: //;s/pt//g")
      iw=$(exiftool -ImageWidth ${FILE} | sed "s/.*: //;s/pt//g")
      tsize=$(psql -t -c "SELECT img_width,img_height FROM signalo_db.vl_official_sign WHERE img_de='${IMAGE}' OR  img_fr='${IMAGE}' OR  img_it='${IMAGE}' OR  img_ro='${IMAGE}'")
      tw=$(echo ${tsize} | cut -d\| -f1)
      th=$(echo ${tsize} | cut -d\| -f2)
      ir=$(echo "${ih}/${iw}" | bc -l)
      tr=$(echo "${th}/${tw}" | bc -l)
      d=$(echo "${tr}-${ir}" | bc -l)
      # echo "checking ${IMAGE}  ${tw} ${th} | ${iw} ${ih} | ${ir} ${tr} | ${d}"
      if [[ $(echo "0${d}*0${d} > 0.01" | bc) -eq 1  ]]; then
        echo "Size mismatch ${IMAGE} ${tw} ${th} | ${iw} ${ih} | ${ir} ${tr} | ${d}"
        return_code=1
      fi
    fi
  done
done

exit ${return_code}

