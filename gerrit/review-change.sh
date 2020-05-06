#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Review a change on gerrit by providing a label and message

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

# E.g. 12345,5
readonly CHANGE_AND_PS="$1"
readonly MESSAGE="$2"
# E.g. 'Design-Quality'='-2'
readonly LABEL="$3"

ssh -p $GERRIT_PORT $GERRIT_USER@$GERRIT_HOST gerrit review "$CHANGE_AND_PS" --label "$LABEL" --strict-labels --message "\"$MESSAGE\""
