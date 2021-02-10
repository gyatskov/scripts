#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Gets change-id from current commit message
## and returns 0 only if it has been printed and found.
##

set -o nounset
set -o errexit

# Checks if the -P flag is supported
function is_gnu_grep()
{
    grep -P 'Pattern' <<< 'TextWithPattern' &>/dev/null
}

if (! is_gnu_grep); then
    echo "grep does not support -P flag"
    echo "Please install GNU grep"
    exit 1
fi

git log -n1 | grep -Po 'Change-Id:[[:space:]]*\K(.+)$'

