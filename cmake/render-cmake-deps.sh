#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##

readonly TARGET_NAME="$1"

dot ./$TARGET_NAME             -T svg -o $TARGET_NAME.svg
dot ./$TARGET_NAME.dependers   -T svg -o $TARGET_NAME-dependers.svg

