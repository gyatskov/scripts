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

function usage()
{
    echo "Usage: $0 <jenkins-job-name> <jenkins-job-id> [line-start=0]"
    echo ""
    echo "Examples:"
    echo "Get progressive log in pipeline 'code-review' with id 123456 from line 500:"
    echo "$0 code-review 123456 500"
    echo ""
    echo "Get progressive log in pipeline 'code-review' with id 123456 completely:"
    echo "$0 code-review 123456"
}

if [[ $# -lt 2 ]]; then
    usage
    exit 1
fi

readonly JOB_NAME="$1"
readonly JOB_ID="$2"
readonly LINE_START="${3:-0}"

# Progressive log output
function progressive_log()
{
    local -r _line_start=$1
    curl -u "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
        "$JENKINS_URL/job/$JOB_NAME/${JOB_ID}/logText/progressiveText?start=${_line_start}"
}

progressive_log $LINE_START
