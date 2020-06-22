#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## @brief Runs a command for each commit in a given range
##

readonly CMD='git submodule update --init --recursive && make'
readonly START_REF=master

git rebase -i --exec "$CMD" "$START_REF"

