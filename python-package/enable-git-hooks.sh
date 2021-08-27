#!/bin/bash

# go to repo top level
cd $(git rev-parse --show-toplevel)

# copy git hooks
cp -R utils/hooks/* .git/hooks/

# TODO: Adicionar git hooks ao bootstrap.sh
