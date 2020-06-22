#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##

set -eu

SELECTION=''

function @selection () {
    local prompt="$1"
    local list="$2"

    echo "Select ${prompt}:"
    select result in ${list}
    do
        SELECTION="${result}"
        break
    done
}

readonly ROOT_DIRECTORY="$1"
readonly LINK_NAME="$2"


# Looks only for files (not symlinks) to avoid infinite recursion
files=$(find "$ROOT_DIRECTORY/" -type f -name "compile_commands.json")
@selection "Compile commands file" "${files}"

echo "Creating (overwriting) symlink in /sv to ${SELECTION}"
ln -f -s "${SELECTION}" "$LINK_NAME"

