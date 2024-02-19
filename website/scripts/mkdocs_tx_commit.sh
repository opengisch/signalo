#!/usr/bin/env bash

set -e

if [[ $(git diff --exit-code mkdocs.yml) ]]; then
  git config --global user.email "github-actions[bot]@users.noreply.github.com"
  git config --global user.name "github-actions[bot]"

  echo "detected changes in mkdocs.yml"
  if [[ ${GITHUB_EVENT_NAME} == "pull_request" ]]; then
    # on PR push to the same branch
    gh pr checkout ${{ github.event.pull_request.number }}
    git add mkdocs.yml
    git commit -m "Update mkdocs.yml translation"
    git push
  else
    # on push/workflow_dispatch create a pull request
    git checkout ${GITHUB_REF_NAME}
    BRANCH="update-mkdocs-tx-$RANDOM"
    pre-commit install
    git checkout -b ${BRANCH}
    git add mkdocs.yml
    pre-commit run --files mkdocs.yml || true
    git commit -m "Update mkdocs.yml translation" --no-verify
    git push -u origin $BRANCH
    echo "gh pr create -B ${GITHUB_REF_NAME} -H ${BRANCH} --title 'Update mkdocs translations' --body 'run from mkdocs_tx'"
    gh pr create -B ${GITHUB_REF_NAME} -H ${BRANCH} --title 'Update mkdocs translations' --body 'run from mkdocs_tx'
  fi
else
  echo "no change mkdocs.yml"
fi
