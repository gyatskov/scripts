#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrieve progressive job log
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly JOB_NAME="$1"
readonly JOB_ID="$2"

# Progressive log output
function progressive_log()
{
    local -r _line_start=$1
    curl -u "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
        "$JENKINS_URL/job/$JOB_NAME/${JOB_ID}/logText/progressiveText?start=$_line_start"
}

readonly line_start=$1
progressive_log $line_start
