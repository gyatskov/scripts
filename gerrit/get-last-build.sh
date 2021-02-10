#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Get Jenkins build ID of the latest executed build
##
## If such a build exists, it can be either
##  * still running         (status: Started) or
##  * finished successfully (status: Successful) or
##  * failed                (status: Failed)
##
## The output can be further parsed using jq
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

# Retrieve Change-Id from current commit message
readonly CURRENT_CHANGE_ID="$($SCRIPTPATH/get-change-id.sh)"

# Gerrit change ID, defaults to current commit
readonly CHANGE_ID="${1:-$CURRENT_CHANGE_ID}"
readonly GERRIT_QUERY="${CHANGE_ID}"
# Regex pattern with named capture groups "status", "job_id", "result" where "status" and "result" have the same meaning
# The result part is optional since a job could be still building
readonly JOB_PATTERN='Build (?<status>[[:alpha:]]+)[[:space:]]+(.+)job/([a-z0-9-]+)/(?<job_id>[0-9]+)/( : (?<result>[[:alpha:]]+))?'

# Parses last comment from CI Reviewer account
# into {status: str, job_id: int [, result: str]  } object
readonly JQ_FILTER=$(cat <<- EOM
    select(has("number") and has("comments"))
    | {
       subject:      (.subject),
       number:       (.number),
       last_jenkins: [.comments[]
                      | select(.reviewer.name == "${GERRIT_CI_REVIEWER_NAME}")
                      .message][-1]
      }
      | select(.last_jenkins)
      .last_jenkins
      | capture("${JOB_PATTERN}")
EOM
)

$SCRIPTPATH/get-all-comments-filtered.sh "${GERRIT_QUERY}" "${JQ_FILTER}"

