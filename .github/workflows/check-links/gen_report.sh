#!/bin/bash -l
set -euxo pipefail

pwd ### DEBUG

echo $@ ### DEBUG

# check links with lychee
lychee \
--base-url https://basedosdados.github.io/mais/ \
--output lychee/report.json \
--format json \
*.md **/*.md

# capture lychee exit code
exit_code=$?

# return lychee exit code
echo ::set-output name=exit_code::$exit_code

# Reference
# Lychee Action
# https://github.com/lycheeverse/lychee-action
# https://github.com/lycheeverse/lychee-action/blob/master/entrypoint.sh
