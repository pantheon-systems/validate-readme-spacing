#!/bin/sh
set -e

curl -sL https://git.io/autotag-install | sh --

# fetch all tags and history:
git fetch --tags --unshallow --prune

if [ $(git rev-parse --abbrev-ref HEAD) != "main" ]; then
  # ensure a local 'main' branch exists at 'refs/heads/main'
  git branch --track main origin/main
fi

./bin/autotag -b main
git push --tags
gh release create ${GITHUB_REF#refs/*/} -t ${GITHUB_REF#refs/*/} --generate-notes -d