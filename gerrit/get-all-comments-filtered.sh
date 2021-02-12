#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Get all comments for a given query as JSON.
## The query can be one or more changes.
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly GERRIT_QUERY="$1"

# Filter out the comments field
readonly JQ_FILTER=$(cat <<- EOM
    select(has("comments")) .comments
EOM
)

$SCRIPTPATH/get-all-comments.sh "$GERRIT_QUERY" | jq "$JQ_FILTER"
