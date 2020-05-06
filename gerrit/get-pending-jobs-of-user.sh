#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrieve all Jenkins build IDs of a specific user's pending changes
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

readonly OWNER="$1"
readonly STATUS="open"

## @note Pretty inefficient since for every change a new SSH connection is opened and closed
${SCRIPTPATH}/get-all-change-ids-of-user.sh $OWNER $STATUS  | xargs -I{} ${SCRIPTPATH}/get-last-build.sh {}
