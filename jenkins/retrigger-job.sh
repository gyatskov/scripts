#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrigger a given jenkins job specified by its ID
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly JOB_NAME="$1"
readonly JOB_ID="$2"

## Retrieves crumb using JSON API and downloads according cookie
function get_crumb_with_cookie()
{
    local -r _cookie_file_dst=$1
    curl --silent --cookie-jar "$_cookie_file_dst" -u $JENKINS_USER:$JENKINS_API_TOKEN \
        "$JENKINS_URL/crumbIssuer/api/json" \
        | jq '.crumbRequestField + ":" + .crumb' \
        | tr -d \"
}

readonly cookie_file="$(mktemp)"
readonly header="$(get_crumb_with_cookie $cookie_file)"
echo "$header, $cookie_file"

## Retriggers a jenkins job using a cookie file and Jenkins crumb
## @param cookie-file:path Path to cookie file
## @param header:string Crumb string, e.g. "Jenkins-Crumb:xxxxx"
function retrigger_with_cookie()
{
    local -r _cookie_file_src=$1
    local -r _header=$2

    curl --request POST \
        --location \
        --cookie "$_cookie_file_src" \
        --user $JENKINS_USER:$JENKINS_API_TOKEN  \
        --header $_header \
        --silent \
        --show-error \
        --output /dev/null \
        --write-out 'HTTP-Result: %{http_code}\n' \
        "$JENKINS_URL/job/$JOB_NAME/${JOB_ID}/gerrit-trigger-retrigger-this"
}

retrigger_with_cookie $cookie_file $header
rm $cookie_file
