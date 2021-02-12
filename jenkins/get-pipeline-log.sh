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
source <(grep '=' $SCRIPTPATH/config.ini)

declare -rx JOB_NAME="$1"
declare -rx JOB_ID="$2"

# Pipeline state of interest
readonly PIPELINE_STATE=FINISHED
# Pipeline result of interest
readonly PIPELINE_RESULT=FAILURE

# Filter pipelines with the above variables and transform into '<node_id>;<node_name>' tuple lines
readonly JQ_FILTER=$(cat <<- EOM
    .[]
    | select(.result == "${PIPELINE_RESULT}" and .state == "${PIPELINE_STATE}")
    | {displayName, id, result, state} | (.id+";"+.displayName)
EOM
)

# Retrieves log of one particular pipeline node
#
# @param pipeline_node Node id
#
function node_log()
{
    local -r _pipeline_node=$1
    local -r _node_log_url="${JENKINS_URL}/blue/rest/organizations/jenkins/pipelines/${JOB_NAME}/runs/${JOB_ID}/nodes/${_pipeline_node}/log/?start=0&download=true"
    echo "$_node_log_url" 1>&2
    curl -u "${JENKINS_USER}:${JENKINS_API_TOKEN}" \
        --show-error \
       "$_node_log_url"
}
# Make function accessible in subshell
export -f pipeline_log

# Check relevance of each returned node and retrieve its log in case
pipeline_nodes \
    | jq -r "${JQ_FILTER}" \
    | xargs -I{} bash -c 'nodeName=${1##*;}; nodeId=${1%%;*}; if(grep "${nodeName}" "$2"); then pipeline_log "$nodeId"; fi' -- {} "$JOBS_RELEVANT_NODES_FILE"

