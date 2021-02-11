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
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep '=' $SCRIPTPATH/config.ini)

declare -rx LOG_FILE="$1"
declare -rx FALSE_POSITIVES_FILE="$2"

if ! command -v combine &> /dev/null; then
    >&2 echo "Requires 'combine' utility from 'moreutils'"
    exit 1
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
function problem_matcher()
{
    jq -r '.problem_matcher' -- "$FALSE_POSITIVES_FILE"
}

# Prints all false positive fixed substrings
function false_fixed_substrings()
{
    jq -r '.false_fixed_substrings[]' -- "$FALSE_POSITIVES_FILE"
}

# Prints all false positive regex patterns
function false_patterns()
{
    jq -r '.false_patterns[]' -- "$FALSE_POSITIVES_FILE"
}

# Prints list of all errors
function filter_all_errors()
{
    local -r _log_file="$1"

    grep -P "$(problem_matcher)" -- "$_log_file"
}

# Filters (discards) lines matching fixed substrings
# Ignores node names in brackets
function filter_false_positives_fixed()
{
    local -r _patterns_file="$1"
    local -r _input_file="$2"
    grep -vF -f "$_patterns_file" -- "$_input_file"
}

# Filters (discards) lines matching patterns
# Ignores node names in brackets
function filter_false_positives_patterns()
{
    local -r _patterns_file="$1"
    local -r _input_file="$2"
    grep -vP -f "$_patterns_file" -- "$_input_file"
}

# Prints list of "real" errors
function filter_real_errors()
{
    local -r _log_file="$1"

    local -r ffs="$(mktemp)"
    local -r fp="$(mktemp)"
    false_fixed_substrings > "$ffs"
    false_patterns > "$fp"

    local -r without_ffs="$(mktemp)"

    filter_false_positives_fixed    "$ffs" "$_log_file" > $without_ffs
    filter_false_positives_patterns "$fp"  "$without_ffs"
}

filter_all_errors "$LOG_FILE" > all_errors.log
filter_real_errors all_errors.log

#combine <(filter_real_errors) not "$FALSE_POSITIVES_FILE"
