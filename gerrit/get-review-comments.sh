#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Gets all review comments for current patchset of a given change
##
## @TODO: Allow selecting patch set(s)
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly JQ_FILTER=$(cat <<- EOM
    select(has("comments")) | .patchSets | map({number, comments})
    | map(
        { number, "comments": [ select(.comments)
                              | .comments
                              | map({file, line, message, "reviewer": .reviewer.name })
                              ]
        }
    )
EOM
)

# Retrieve Change-Id from current commit message
readonly CURRENT_CHANGE_ID="$($SCRIPTPATH/get-change-id.sh)"

# Gerrit change ID, defaults to current commit
readonly CHANGE_ID="${1:-$CURRENT_CHANGE_ID}"
readonly GERRIT_QUERY="${CHANGE_ID}"

# TODO: Generalize and use the following script
#$SCRIPTPATH/get-all-comments-filtered.sh "${GERRIT_QUERY}" | jq "$JQ_FILTER"

$SCRIPTPATH/gerrit-query.sh "${GERRIT_QUERY}" --comments --patch-sets --format json \
    | jq "${JQ_FILTER}"

#ssh -p $GERRIT_PORT $GERRIT_USER@$GERRIT_HOST gerrit query "" --comments --current-patch-set --format json $CHANGE_ID | jq "$JQ_FILTER"
