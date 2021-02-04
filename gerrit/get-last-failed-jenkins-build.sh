#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Get the last Jenkins comment for all changes of a given Gerrit user
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly GERRIT_OWNER=$1
readonly GERRIT_STATUS=open
readonly GERRIT_QUERY="owner:$GERRIT_OWNER AND status:$GERRIT_STATUS"

# Plain-text string that implies a failed build
readonly FAIL_SUBSTR=' : FAILURE'
# Regex pattern with named capture group "job_id"
readonly JOB_PATTERN='job/([a-z0-9-]+)/(?<job_id>[0-9]+)/'
# Name of the system account used for CI
readonly CI_REVIEWER_NAME='Jenkins'
# Last failed Jenkins job ID as field "job_id"

## Examples for jq filters

## Parse everything
#readonly JQ_FILTER='.'

## Parse such objects that have a 'number' and 'comments'
#readonly JQ_FILTER='select(has("number") and has("comments"))'

## Create an object with the fields 'number', 'comments' having as values the input number and comments whose author is Jenkins, respectively
#readonly JQ_FILTER='{number: (.number), comments: (.comments[]? | select(.reviewer.name == "Jenkins"))}'

## Create an object with the field 'last_comment' with the last comment message
#readonly JQ_FILTER='{last_comment: [.comments[]?.message][-1]}'

## Create an object with the field 'last_comment' with the last comment message whose author is Jenkins
#readonly JQ_FILTER='{last_comment: [.comments[]? | select(.reviewer.name == "Jenkins") .message][-1]}'

# Combination of the above filters
#readonly JQ_FILTER='select(has("number") and has("comments")) | {subject: (.subject), number: (.number), last_jenkins: [.comments[] | select(.reviewer.name == "Jenkins") .message][-1]}'

readonly JQ_FILTER=$(cat <<- EOM
    select(has("number") and has("comments"))
    | {
       subject:      (.subject),
       number:       (.number),
       last_jenkins: [.comments[] | select(.reviewer.name == "${CI_REVIEWER_NAME}" and (.message | test("${FAIL_SUBSTR}"))) .message][-1]
      }
      | select(.last_jenkins)
      .last_jenkins
      | capture("${JOB_PATTERN}")
EOM
)

$SCRIPTPATH/get-all-comments-filtered.sh "${GERRIT_QUERY}" "${JQ_FILTER}"

