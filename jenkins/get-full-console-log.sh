#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Get the complete console log of a build

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

function usage()
{
    echo "Usage: $0 <jenkins-job-name> <jenkins-job-id>"
    echo ""
    echo "Examples:"
    echo "Get full console log in pipeline 'code-review' with id 123456:"
    echo "$0 code-review 123456"
    echo ""
}

if [[ $# -ne 2 ]]; then
    usage
    exit 1
fi

readonly JOB_NAME="$1"
readonly JOB_ID="$2"

curl -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/job/$JOB_NAME/$JOB_ID/consoleText"
