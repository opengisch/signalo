#!/usr/bin/env bash

set -e


return_code=0

_IMG_DIRS=(editable original)
for _IMG_DIR in "${_IMG_DIRS[@]}"; do
  echo "checking $_IMG_DIR"
  DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../project/images/official/${_IMG_DIR}

  _LANGUAGES=(de fr it ro)
  for _LANGUAGE in "${_LANGUAGES[@]}"; do
    echo "language $_LANGUAGE"
    LINES=$(psql --no-align --tuples-only -c "SELECT id, img_${_LANGUAGE}, img_${_LANGUAGE}_right, directional_sign FROM signalo_db.vl_official_sign")
    while read -r LINE; do
      FID=$(echo "$LINE" | cut -d\| -f1)
      IMAGE=$(echo "$LINE" | cut -d\| -f2)
      IMAGE_RIGHT=$(echo "$LINE" | cut -d\| -f3)
      DIRECTIONAL=$(echo "$LINE" | cut -d\| -f4)
      if [[ $DIRECTIONAL == "t" ]]; then
        if [[ -z $IMAGE_RIGHT ]]; then
          echo "*** For sign '${FID}', img_${_LANGUAGE}_right should be specified since it's directional."
          return_code=1
        fi
        IMAGES=("$IMAGE" "$IMAGE_RIGHT")
      else
        IMAGES=("$IMAGE")
      fi
      for _IMAGE in "${IMAGES[@]}"; do
        if [[ ! -f ${DIR}/${_IMAGE} ]]; then
          echo "*** Image ${_IMAGE} (id:${FID}) does not exist in ./project/images/official/${_IMG_DIR}"
          return_code=1
        fi
      done
    done <<< $LINES;
  done

  echo "files"
  for FILE in ${DIR}/*.svg; do
    IMAGE=$(basename ${FILE})
    COUNT=$(psql -t -c "SELECT COUNT(id) FROM signalo_db.vl_official_sign WHERE img_de='${IMAGE}' OR img_fr='${IMAGE}' OR img_it='${IMAGE}' OR img_ro='${IMAGE}' OR img_de_right='${IMAGE}' OR img_fr_right='${IMAGE}' OR img_it_right='${IMAGE}' OR img_ro_right='${IMAGE}'")
    if [[ ${COUNT} -ne "1" ]]; then
      echo "*** Image ${IMAGE} is not used once in signalo_db.vl_official_sign (or maybe more than once, checkout)"
      return_code=1
    elif [[ ${_IMG_DIR} = editable ]]; then
      ih=$(exiftool -ImageHeight ${FILE} | sed "s/.*: //;s/pt//g")
      iw=$(exiftool -ImageWidth ${FILE} | sed "s/.*: //;s/pt//g")
      tsize=$(psql -t -c "SELECT img_width,img_height FROM signalo_db.vl_official_sign WHERE img_de='${IMAGE}' OR img_fr='${IMAGE}' OR img_it='${IMAGE}' OR img_ro='${IMAGE}' OR img_de_right='${IMAGE}' OR img_fr_right='${IMAGE}' OR img_it_right='${IMAGE}' OR img_ro_right='${IMAGE}'")
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
