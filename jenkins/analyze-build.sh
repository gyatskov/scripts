#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Analyzes a build and returns "non-trivial" errors by filtering out
## the false positives.
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
declare -rx SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

function usage()
{
    echo "Usage: $0 <jenkins-job-name> <jenkins-job-id> <false-positives-config.json>"
    echo ""
    echo "Examples:"
    echo "Analyze build specific build in pipeline 'code-review' with id 123456:"
    echo "$0 code-review 123456 /home/user/config/config.json"
    echo ""
}

if [[ $# -lt 3 ]]; then
    usage
    exit 1
fi

declare -rx JOB_NAME="$1"
declare -rx JOB_ID="$2"
# TODO: Make file optional:
#       Not providing this argument shall retrieve all nodes
declare -rx JOBS_FALSE_POSITIVES_FILE="$3"

# Joins the configured nodes and the nodes returned by the REST API
readonly JQ_FILTER_JOIN=$(cat <<- 'EOM'
    .[0] as $configured_nodes | .[1] as $returned_nodes
    | $returned_nodes
    | map(select ([.displayName] | inside($configured_nodes | .nodes | map(.node_name))))
EOM
)

# Internal separator
readonly SEPARATOR=,

readonly JQ_FILTER_MAP=$(cat <<- EOM
    map( (.id | tostring) + "$SEPARATOR" + (.displayName) )[]
EOM
)

## Filters a json object with provided "node_name"
##
## @param job_node_name Node name of interest
##
function _get_node()
{
    local -r _job_node_name=$1
    local -r JQ_FILTER_NODE_NAME=$(cat <<- EOM
        .nodes | map(select(.node_name == "$_job_node_name"))[]
EOM
    )
    jq "$JQ_FILTER_NODE_NAME"
}
export -f _get_node

## Analyzes a node's results by filtering errors
##
## @param job_node_id Node id to be analyzed
## @param job_node_name Name of node to be analyzed
##
function _analyze_node()
{
    local -r _job_node_id=$1
    local -r _job_node_name=$2

    local -r _filtered_node_file=$(mktemp -p /tmp filtered_node.XXX)
    (_get_node $_job_node_name < $JOBS_FALSE_POSITIVES_FILE) > $_filtered_node_file

    local -r _root_node_file=$(mktemp -p /tmp root_node.XXX)
    (_get_node "root" < $JOBS_FALSE_POSITIVES_FILE) > $_root_node_file

    $SCRIPTPATH/get-node-log.sh $JOB_NAME $JOB_ID $_job_node_id  \
        | $SCRIPTPATH/filter-errors.sh "$_root_node_file" \
        | $SCRIPTPATH/filter-errors.sh "$_filtered_node_file"
}
export -f _analyze_node

## Convenience method for analyzing a node's results
##
## @param pair Node description as a pair "<id>$SEPARATOR<name>"
##
function analyze_node()
{
    local -r _pair="$1"
    local -r _job_node_id=${_pair%%,*}
    local -r _job_node_name=${_pair##*,}

    echo "Remaining errors for $_job_node_name ($_job_node_id):"
    _analyze_node $_job_node_id $_job_node_name
}
export -f analyze_node

# 1. Get all failed nodes in build
# 2. Filter failed and configured nodes
# 3. For each failed and configured node:
#       3.1 Get node's log
#       3.2 Filter real errors
#       3.3 Print any real errors

jq -s "$JQ_FILTER_JOIN" -- $JOBS_FALSE_POSITIVES_FILE <($SCRIPTPATH/get-nodes-failed.sh $JOB_NAME $JOB_ID) \
    | jq -rc "$JQ_FILTER_MAP" \
    | xargs -I{} bash -c 'analyze_node $1' -- {}

## Retrigger conditions:
## * If ignore_unmatched_nodes:
##  * if none of the relevant nodes have been found in the run (broke too early)
##  * if none of the failed pipeline node names correspond to relevant nodes listed (other projects failed)
##  * if known false-alarms in the relevant nodes occured

## Input: (user name, Gerrit change number)
## 1. Look for last failed jenkins job
##      * If none exists, success or waiting for build
## 2. Get jenkins job id from last failed jenkins comment
## 3. Retrieve the failed job's nodes
## 4. Check all nodes
##      * If none of the relevant nodes have been found in the run (broke too early) => (print all failed nodes, retrigger)
##      * If none of the node names appear in the relevant nodes file
##        the failure is "somewhere" else => (print failed nodes, retrigger)
##      * If failure in relevant node but known false-positive
##          => (print false positive, retrigger)
##      * If failure in relevant node but not known false-positive
##          => (print error, do nothing)

