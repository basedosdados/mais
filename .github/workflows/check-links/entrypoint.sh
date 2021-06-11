#!/bin/bash -l
set -euxo pipefail

# initialize report.json
mkdir -p lychee
rm -f lychee/report.json
echo > lychee/report.json

# check links with lychee
# and capture its status code
lychee \
--base-url https://basedosdados.github.io/mais/ \
--output lychee/report.json \
--format json \
--no-progress \
*.md **/*.md && continue=0 || continue=1

# return if the action should continue
echo ::set-output name=continue::$continue

# Reference
# Lychee Action
# https://github.com/lycheeverse/lychee-action
# https://github.com/lycheeverse/lychee-action/blob/master/entrypoint.sh
