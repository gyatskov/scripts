#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Compresses a video (recorded by vlc)

readonly FILE_IN=$1
readonly FILE_OUT=$2

ffmpeg -i "$FILE_IN" -vcodec msmpeg4v2 -q:v 1 -acodec copy "$FILE_OUT"

