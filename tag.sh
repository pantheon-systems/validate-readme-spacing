#!/bin/sh
set -eou pipefail

curl -sL https://git.io/autotag-install | sh --

# fetch all tags and history:
git fetch --tags --unshallow --prune

if [ $(git rev-parse --abbrev-ref HEAD) != "master" ]; then
  # ensure a local 'master' branch exists at 'refs/heads/master'
  git branch --track master origin/master
fi

./bin/autotag -b main
git push --tags