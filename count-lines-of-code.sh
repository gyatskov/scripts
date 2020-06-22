#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## @note Requires cloc ( https://github.com/AlDanial/cloc/releases/tag/1.82 )

readonly ROOT_DIRECTORY=$1

cloc --vcs=git "$ROOT_DIRECTORY"
