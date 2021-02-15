#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Returns each node's complete log in a pipeline
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

# Check relevance of each returned node and retrieve its log in case
$SCRIPTPATH/get-nodes.sh \
    | jq -r "${JQ_FILTER}" \
    | xargs -I{} bash -c 'nodeName=${1##*;}; nodeId=${1%%;*}; if(grep "${nodeName}" "$2"); then pipeline_log "$nodeId"; fi' -- {} "$JOBS_RELEVANT_NODES_FILE"

