#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## @note Full path is necessary!
##

set -eu

readonly FILE=$1
readonly INCLUDES_DIR=$2
readonly DATABASE_DIR=$3

cppast \
    --database_dir $DATABASE_DIR \
    --std c++11 \
    -I $INCLUDES_DIR \
    ${FILE}

