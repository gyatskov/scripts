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

function usage()
{
    echo "Usage: $0 <false-positives-config.json> [<log-file>]"
    echo ""
    echo "Examples:"
    echo "Parse existing log file:"
    echo "$0 /home/user/config/config.json build.log"
    echo ""
    echo "Pipe text log:"
    echo "get-log.sh | $0 /home/user/config/config.json"
    echo ""
}

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
        usage
        exit 1
    fi
fi


if [ ! -e "$LOG_FILE" ]; then
    >&2 echo "Log file does not exist: ${LOG_FILE}"
    usage
    exit 1
fi
if [[ ! -e "$FALSE_POSITIVES_FILE" || ! -s "$FALSE_POSITIVES_FILE" ]]; then
    >&2 echo "False positives file not existing or empty: ${FALSE_POSITIVES_FILE}"
    usage
    exit 1
fi

# Prints extended regex error patterns
##
## @param <stdin> JSON stream to be filtered
function problem_matchers()
{
    jq -r '.problem_matchers[]'
}

# Prints all false positive fixed substrings
##
## @param <stdin> JSON stream to be filtered
function false_fixed_substrings()
{
    jq -r '.false_fixed_substrings[]'
}

## Prints all false positive regex patterns
##
## @param <stdin> JSON stream to be filtered
function false_patterns()
{
    jq -r '.false_patterns[]'
}

## Catches all errors found by the problem matchers
##
## @param <stdin> Stream to be filtered
function filter_all_errors()
{

    local -r _problem_matchers=$(mktemp -p /tmp problem_matchers.XXX)
    (problem_matchers < $FALSE_POSITIVES_FILE) > $_problem_matchers
    if [[ -s $_problem_matchers ]]; then
        grep -E -f $_problem_matchers
    else
        cat
    fi
}

## Discards lines matching fixed patterns
##
## @param <stdin> Text stream to be filtered
function filter_false_positives_fixed()
{
    local -r _false_fixed_substrings=$(mktemp -p /tmp false_fixed_substrings.XXX)
    (false_fixed_substrings < $FALSE_POSITIVES_FILE) > $_false_fixed_substrings
    if [[ -s $_false_fixed_substrings ]]; then
        grep -vF -f $_false_fixed_substrings
    else
        cat
    fi
}

## Discards lines matching extended regex patterns
##
## @param <stdin> Text stream to be filtered
function filter_false_positives_patterns()
{
    local -r _false_patterns=$(mktemp -p /tmp false_patterns.XXX)
    (false_patterns < $FALSE_POSITIVES_FILE) > $_false_patterns
    if [[ -s $_false_patterns ]]; then
        grep -vE -f $_false_patterns
    else
        cat
    fi
}

## Discards all false positives specified by fixed and regex patterns
##
## @param <stdin> Text stream to be filtered
function filter_real_errors()
{
    filter_false_positives_fixed | filter_false_positives_patterns
}

# Stream explicitly to filter_all_errors
filter_all_errors < $LOG_FILE | filter_real_errors

