#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Abandon a list of commits
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep '=' "$SCRIPTPATH/config.ini")

readonly MESSAGE='Change outdated'

readonly CHANGE_LIST_FILE="$1"

xargs $CHANGE_LIST_FILE -I'{}' ssh -p $GERRIT_PORT $GERRIT_USER@$GERRIT_HOST gerrit review "$CHANGE_AND_PS" --abandon --message "\"$MESSAGE\"" || true
