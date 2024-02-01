#!/usr/bin/env bash

git submodule foreach sh -c 'git fetch --all -p && (git checkout master || git checkout main) && git pull'

