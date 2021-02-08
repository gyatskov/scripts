#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Traverses all headers in a directory recursively and runs clang-query on them
##

readonly parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# File with clang-query instructions
readonly query_file=$1
# Directory containing compile_commands.json
readonly build_path=$2

find ./ -iname "*.h" -exec clang-query -p "${build_path}" -f "$query_file" {} \;

