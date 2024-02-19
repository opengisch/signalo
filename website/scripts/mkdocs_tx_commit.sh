#!/usr/bin/env bash

if [[ $(git diff --exit-code mkdocs.yml) ]]; then
  echo "detected changes in mkdocs.yml"
  if [[ ${GITHUB_EVENT} == "pull_request" ]]; then
    # on PR push to the same branch
    gh pr checkout ${{ github.event.pull_request.number }}
    git add mkdocs.yml
    git commit -m "Update mkdocs.yml translation"
    git push
  else
    # on push create a pull request
    git checkout ${GITHUB_HEADREF}
    git checkout -b update-mkdocs-tx
    git commit -m "Update mkdocs.yml translation"
    gh pr create -B update-mkdocs-tx -H update-mkdocs-tx --title 'Update mkdocs translations'
  fi
else
  echo "no change mkdocs.yml"
fi
