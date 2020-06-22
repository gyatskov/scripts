#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Cherry picks all commits between base and top (inclusive)
##

readonly base=$1
readonly top=$2

git cherry-pick $(git merge-base $base $top)..$top

