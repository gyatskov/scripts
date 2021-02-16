#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep '=' $SCRIPTPATH/config.ini)

declare -rx JOB_NAME="$1"
declare -rx JOB_ID="$2"

# Pipeline state of interest
readonly PIPELINE_STATE=FINISHED
# Pipeline result of interest
readonly PIPELINE_RESULT=FAILURE

# Filter pipelines to those that finished and failed
readonly JQ_FILTER=$(cat <<- EOM
    map(select(.state == "${PIPELINE_STATE}" and .result == "${PIPELINE_RESULT}"))
EOM
)

# Check relevance of each returned node and retrieve its log in case
$SCRIPTPATH/get-nodes.sh $JOB_NAME $JOB_ID | jq "${JQ_FILTER}"

