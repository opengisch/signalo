#!/usr/bin/env bash

set -e


return_code=0

for _IMG_DIR in (editable original); do
  DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../images/official/${_IMG_DIR}

  _LANGUAGES=(de fr it ro)
  for _LANGUAGE in "${_LANGUAGES[@]}"; do
    IMAGES=$(psql -t -c "SELECT img_${_LANGUAGE} FROM siro_vl.official_sign")
    for IMAGE in ${IMAGES}; do
      if [[ ! -f ${DIR}/${IMAGE} ]]; then
        FID=$(psql -t -c "SELECT id FROM siro_vl.official_sign WHERE img_${_LANGUAGE} = '${IMAGE}'")
        echo "*** Image ${IMAGE} (id:${FID}) does not exist in ./images/official/editable"
        return_code=1
      fi
    done
  done

  for IMAGE in ${DIR}/*.svg; do
    COUNT=$(psql -t -c "SELECT COUNT(id) FROM siro_vl.official_sign WHERE img_de='${IMAGE}' OR  img_fr='${IMAGE}' OR  img_it='${IMAGE}' OR  img_ro='${IMAGE}'")
    if [[ ${COUNT} -ne "0" ]]; then
      echo "*** Image ${IMAGE} is not used once in siro_vl.official_sign"
      return_code=1
    fi
  done
done

exit ${return_code}

