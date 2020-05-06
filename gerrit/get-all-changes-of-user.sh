#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrieve all changes with of a specific user with a specific status
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

readonly OWNER="$1"
readonly STATUS="$2"

readonly GERRIT_QUERY="owner:$OWNER AND status:$STATUS"
readonly REMAINING_PARAMETERS=${@:3}

# Appends remaining parameters passed to the script
${SCRIPTPATH}/gerrit-query.sh "$GERRIT_QUERY" ${REMAINING_PARAMETERS}
