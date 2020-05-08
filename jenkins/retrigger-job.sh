#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrigger a given jenkins job specified by its ID
##
## Main idea taken from here:
## https://github.com/mdlavin/gerrit-jenkins-retrigger-bot/blob/master/retrigger.sh
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly JOB_NAME="$1"
readonly JOB_ID="$2"


readonly COOKIES=`mktemp`
# -L : follow redirects
# -s : silent mode
readonly CURL_OPTIONS="-L -s --cookie $COOKIES --cookie-jar $COOKIES"

# @TODO: Keep cookies or use the ones from installed browsers
function login()
{
    echo -n "Jenkins password for $JENKINS_USER: "
    read -s JENKINS_PASSWORD
    curl $CURL_OPTIONS ${JENKINS_URL}/login > /dev/null
    curl $CURL_OPTIONS --data "j_username=${JENKINS_USER}&j_password=${JENKINS_PASSWORD}" ${CURL_OPTIONS} ${JENKINS_URL}/j_acegi_security_check > /dev/null
    unset JENKINS_PASSWORD
}

function retrigger()
{
    local -r JENKINS_RETRIGGER_LINK="$JENKINS_URL/job/$JOB_NAME/${JOB_ID}/gerrit-trigger-retrigger-this"

    curl $CURL_OPTIONS $JENKINS_RETRIGGER_LINK
}

login
retrigger
