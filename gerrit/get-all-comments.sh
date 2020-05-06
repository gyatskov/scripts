#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Get all comments for current patchset of a given change.
## This could be used to retrieve all of Jenkins results and job URLs.
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly GERRIT_QUERY=''
readonly JQ_FILTER='.comments[]?.message'

readonly CHANGE_ID=$1

ssh -p $GERRIT_PORT $GERRIT_USER@$GERRIT_HOST gerrit query "$GERRIT_QUERY" --comments --format json $CHANGE_ID | jq "$JQ_FILTER"
