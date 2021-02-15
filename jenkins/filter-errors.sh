#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Returns all errors not listed in a provided false-positives configuration file.
##
## Examples include:
##  * Tests failing sporadically
##  * Connection timeouts
##  * System shutdowns
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep '=' $SCRIPTPATH/config.ini)

declare -rx FALSE_POSITIVES_FILE="$1"

# Interpret second argument as input file
# Or use stdin instead if pipe has been opened
if [ $# -gt 1 ]; then
    declare -rx LOG_FILE="$2"
else
    if [ -p /dev/stdin ]; then
        declare -rx LOG_FILE="/dev/stdin"
    else
        >&2 echo "No data piped to script"
        exit 1
    fi
fi


if [ ! -e "$LOG_FILE" ]; then
    >&2 echo "Log file does not exist: ${LOG_FILE}"
    exit 1
fi
if [ ! -e "$FALSE_POSITIVES_FILE" ]; then
    >&2 echo "False positives file does not exist: ${FALSE_POSITIVES_FILE}"
    exit 1
fi

# Prints PCRE style pattern for errors
function problem_matchers()
{
    jq -r '.problem_matchers[]'
}

# Prints all false positive fixed substrings
function false_fixed_substrings()
{
    jq -r '.false_fixed_substrings[]'
}

# Prints all false positive regex patterns
function false_patterns()
{
    jq -r '.false_patterns[]'
}

# Prints list of all errors
function filter_all_errors()
{

    local -r _problem_matchers=$(mktemp -p /tmp problem_matchers.XXX)
    (problem_matchers < $FALSE_POSITIVES_FILE) > $_problem_matchers
    grep -P -f $_problem_matchers
}

# Filters (discards) lines matching fixed substrings
# Ignores node names in brackets
function filter_false_positives_fixed()
{
    local -r _false_fixed_substrings=$(mktemp -p /tmp false_fixed_substrings.XXX)
    (false_fixed_substrings < $FALSE_POSITIVES_FILE) > $_false_fixed_substrings
    grep -vF -f $_false_fixed_substrings
}

# Filters (discards) lines matching patterns
# Ignores node names in brackets
function filter_false_positives_patterns()
{
    local -r _false_patterns=$(mktemp -p /tmp false_patterns.XXX)
    (false_patterns < $FALSE_POSITIVES_FILE) > $_false_patterns
    grep -vP -f $_false_patterns
}

# Prints list of "real" errors
function filter_real_errors()
{
    filter_false_positives_fixed | filter_false_positives_patterns
}

filter_all_errors < $LOG_FILE | filter_real_errors

