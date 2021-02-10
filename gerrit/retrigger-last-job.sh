#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retriggers the last CI job of a gerrit change unconditionally
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly GERRIT_CHANGE_ID=$1
readonly RETRIGGER_ONLY_IF_FAILED="${2:-}"
readonly GERRIT_QUERY="$GERRIT_CHANGE_ID"

# Regex that implies a successful build
readonly SUCCESS_REGEX=' : SUCCESS$'
# Regex pattern with named capture group "job_id"
readonly JOB_PATTERN='job/([a-z0-9-]+)/(?<job_id>[0-9]+)/'
# Name of the system account used for CI
readonly GERRIT_CI_REVIEWER_NAME='Jenkins'
# Last failed Jenkins job ID as field "job_id"

readonly JQ_FILTER=$(cat <<- EOM
    select(has("number") and has("comments"))
    | {
       subject:      (.subject),
       number:       (.number),
       last_jenkins: [
                      .comments[]
                      | select(.reviewer.name == "${GERRIT_CI_REVIEWER_NAME}"
                                and not (.message | test("${SUCCESS_REGEX}"))) .message
                     ][-1]
      }
      | select(.last_jenkins)
      .last_jenkins
      | capture("${JOB_PATTERN}")
EOM
)

$SCRIPTPATH/get-all-comments-filtered.sh "${GERRIT_QUERY}" "${JQ_FILTER}"

