#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Issue a query to Gerrit and return the results
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly GERRIT_QUERY="$1"

# Append additional parameters
ssh -p $GERRIT_PORT $GERRIT_USER@$GERRIT_HOST gerrit query "$GERRIT_QUERY" "${@:2}"
