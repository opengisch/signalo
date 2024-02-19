#!/usr/bin/env bash

if [[ $(git diff --exit-code mkdocs.yml) ]]; then
  git config --global user.email "qgisninja@gmail.com"
  git config --global user.name "Geo Ninja"

  echo "detected changes in mkdocs.yml"
  if [[ ${GITHUB_EVENT} == "pull_request" ]]; then
    # on PR push to the same branch
    gh pr checkout ${{ github.event.pull_request.number }}
    git add mkdocs.yml
    git commit -m "Update mkdocs.yml translation"
    git push
  else
    # on push create a pull request
    BRANCH="update-mkdocs-tx-$RANDOM"
    git checkout -b ${BRANCH}
    git add mkdocs.yml
    git commit -m "Update mkdocs.yml translation"
    git push -u origin ${BRANCH}
    gh pr create -B "${GITHUB_REF}" -H "${BRANCH}" --title 'Update mkdocs translations' --body 'run from mkdocs_tx'
  fi
else
  echo "no change mkdocs.yml"
fi
