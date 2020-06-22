#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

readonly parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly queryfile=$parent_path/clang-query-method-defs-in-headers.txt

find ./ -iname "*.h" -exec clang-query -p /sv -f $queryfile {} \; 

