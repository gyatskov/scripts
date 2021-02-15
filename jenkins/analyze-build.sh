#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrigger a given jenkins job specified by its ID in case
## it failed due to false positives.
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly JOB_NAME="$1"
readonly JOB_ID="$2"
# TODO: Make file optional:
#       Not providing this argument shall retrieve all nodes
declare -r JOBS_FALSE_POSITIVES_FILE="$3"

readonly JQ_FILTER=$(cat <<- 'EOM'
    .[0] as $configured_nodes | .[1] as $returned_nodes | $returned_nodes | map(select ([.displayName] | inside($configured_nodes | .nodes | map(.node_name))))
EOM
)

# 1. Get all nodes in build
# 2. Filter failed and configured nodes
# 3. For each failed and configured node:
#       3.1 Get node's log
#       3.2 Filter real errors
#       3.3 Print any real errors

jq -s "$JQ_FILTER" -- $JOBS_FALSE_POSITIVES_FILE <($SCRIPTPATH/get-nodes-failed.sh $JOB_NAME $JOB_ID) | jq 'map(.displayName)'
exit 0
$SCRIPTPATH/filter-errors.sh <($SCRIPTPATH/get-pipeline-log.sh "$JOB_NAME" "$JOB_ID") $JOBS_FALSE_POSITIVES_FILE

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

