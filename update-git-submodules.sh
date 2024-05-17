#!/usr/bin/env bash

git submodule foreach sh -c 'pwd -P; git fetch --all -p && (git checkout master || git checkout main) && git pull'
