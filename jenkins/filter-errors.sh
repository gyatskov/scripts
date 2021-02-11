#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Returns all errors not listed in the provided false-positives file
##
## Examples include:
##  * Tests failing sporadically
##  * Connection timeouts
##  * System shutdowns
##
## TODO: Match by node, either through files or more logic
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep '=' $SCRIPTPATH/config.ini)

declare -rx LOG_FILE="$1"
declare -rx FALSE_POSITIVES_FILE="$2"

# PCRE style pattern for errors
readonly ERROR_MATCHER='[eE]rror: (.+)$'

if ! command -v combine &> /dev/null; then
    echo "Requires 'combine' utility from 'moreutils'"
    exit 1
fi

# Prints list of all errors
function filter_all_errors()
{
    grep -P "$ERROR_MATCHER" "$LOG_FILE"
}

# Return just false positives
# Ignores node names in brackets
function false_positives()
{
    grep -vPx '\[.+\]' "$FALSE_POSITIVES_FILE"
}

# Prints list of "real" errors
function filter_real_errors()
{
    filter_all_errors | grep -vF -f <(false_positives)
}

combine <(filter_real_errors) not "$FALSE_POSITIVES_FILE"
