#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Get Jenkins build ID of the latest executed build
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Gerrit change ID
readonly CHANGE_ID=$1

# Detector for jenkins entries in the gerrit comments
readonly JENKINS_ENTRY_REGEX='Patch Set ([[:digit:]]+)\:(.+)Build '
# Detectors for job ID and job result
readonly JENKINS_JOB_REGEX='(/[[:digit:]]+/|ABORTED|FAILURE|SUCCESS)'


# Prints the last job's ID and status in two lines after each other
${SCRIPTPATH}/get-all-comments.sh "$CHANGE_ID" | grep -E "${JENKINS_ENTRY_REGEX}" | tail -n 1 | grep -oE "${JENKINS_JOB_REGEX}" | tr -d '/'
