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
declare -rx JOB_NODE_ID="$3"

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
        --silent \
        --show-error \
       "$_node_log_url"
}

node_log "$JOB_NODE_ID"

