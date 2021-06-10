#!/bin/bash -l
set -euxo pipefail

# initialize report.json
mkdir ./lychee
echo > ./lychee/report.json

# check links with lychee
lychee \
--base-url https://basedosdados.github.io/mais/ \
--output lychee/report.json \
--format json \
*.md **/*.md

# capture lychee exit code
exit_code=$?

# return if the action should continue 
if [ $exit_code = 0 ]; then
    echo ::set-output name=continue::0
else
    echo ::set-output name=continue::1
fi

# Reference
# Lychee Action
# https://github.com/lycheeverse/lychee-action
# https://github.com/lycheeverse/lychee-action/blob/master/entrypoint.sh
