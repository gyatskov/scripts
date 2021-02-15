#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrieves all pipeline nodes for a given job name and ID.
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep '=' $SCRIPTPATH/config.ini)

declare -rx JOB_NAME="$1"
declare -rx JOB_ID="$2"

# Retrieves all pipeline nodes
function pipeline_nodes()
{
    local -r _nodes_url="${JENKINS_URL}/blue/rest/organizations/jenkins/pipelines/${JOB_NAME}/runs/${JOB_ID}/nodes/"
    curl -u "${JENKINS_USER}:${JENKINS_API_TOKEN}"  \
        --silent \
        --show-error \
        "$_nodes_url"
}

pipeline_nodes
