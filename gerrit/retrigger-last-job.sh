#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Unconditionally retriggers the last CI job of a gerrit change
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly GERRIT_CHANGE_ID=${1:-"$($SCRIPTPATH/get-change-id.sh)"}
readonly GERRIT_QUERY="$GERRIT_CHANGE_ID"

# Generates bash source code
readonly JQ_EXTRACTOR=$(cat <<- EOM
    "readonly _job_name="+.job_name,
    "readonly _job_id="+.job_id
EOM
)

# Evaluates extracted bash code
eval "$($SCRIPTPATH/get-last-build.sh | jq -r "$JQ_EXTRACTOR")"
# Retriggers job
$SCRIPTPATH/../jenkins/retrigger-job.sh "${_job_name}" "${_job_id}"
