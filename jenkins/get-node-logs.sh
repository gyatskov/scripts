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
declare -rx RETRIGGER_CONFIG_FILE="$3"

# Pipeline state of interest
readonly PIPELINE_STATE=FINISHED
# Pipeline result of interest
readonly PIPELINE_RESULT=FAILURE

function ignore_unmentioned()
{
    jq -r '.ignore_unmentioned_nodes' -- "${RETRIGGER_CONFIG_FILE}"
}

# Retrieves logs for all nodes
#
# @param pipeline_node Node id
#
function node_logs()
{
    # Retrieve all nodes
    $SCRIPTPATH/get-pipelines.sh "$JOB_NAME" "$JOB_ID" | jq '.' > nodes.json

    # Decide based on config what to process
    if [ "$(ignore_unmentioned)" == "true" ]; then
        jq -r '.nodes[] .node_name' -- "${RETRIGGER_CONFIG_FILE}" > relevant_node_names.txt
    else
        jq -r '.[] .displayName' -- nodes.json > relevant_node_names.txt
    fi

    while read -r node_name; do
        local _node_id=$(jq -r ".[] | select(.displayName == \"$node_name\") .id" -- nodes.json)

        $SCRIPTPATH/get-node-log.sh "$JOB_NAME" "$JOB_ID" "$_node_id" > "$JOB_NAME-$JOB_ID-$node_name.log"
    done < relevant_node_names.txt
}

node_logs
