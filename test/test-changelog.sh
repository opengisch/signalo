#!/usr/bin/env bash

set -e


return_code=0

for file in $(find datamodel/changelogs -type f); do
  if ! grep -q $(basename ${file}) datamodel/setup.sh; then
    echo "changelog file ${file} not found in datamodel/setup.sh"
    return_code=1
  fi
done

exit ${return_code}
