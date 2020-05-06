#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrieve all change IDs of a specific user with a given status
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

readonly OWNER="$1"
readonly STATUS="$2"

readonly REMAINING_PARAMETERS=${@:3}

# From the changes that don't contain the DRAFT keyword (case sensitive), select the job id (number)
readonly JQ_FILTER='select(.subject | test("DRAFT") | not )? | .number'

# Appends remaining parameters passed to the script to the get-all-changes-of-user arguments
#
${SCRIPTPATH}/get-all-changes-of-user.sh $OWNER $STATUS --format json $REMAINING_PARAMETERS | jq -r "${JQ_FILTER}"
