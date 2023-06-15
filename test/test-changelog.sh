#!/usr/bin/env bash

set -e


return_code=0

for file in $(find data_model/changelogs -type f); do
  if ! grep -q $(basename ${file}) data_model/setup.sh; then
    echo "changelog file ${file} not found in data_model/setup.sh"
    return_code=1
  fi
done

exit ${return_code}
