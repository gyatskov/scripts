#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

set -e
set -o nounset

readonly LISTEN_ADDRESS=$1
readonly LISTEN_PORT=$2
readonly BASE_URL=$3

# Example
#LISTEN_ADDRESS=0.0.0.0
#LISTEN_PORT=9876
#BASE_URL=sharing-session

cvlc screen://:chroma=mjpg:screen-fps=5.000000:live-caching=300 --sout "#transcode{vcodec=mjpg,scale=0.5}:std{access=http{mime=multipart/x-mixed-replace},mux=mpjpeg,dst=${LISTEN_ADDRESS}:${LISTEN_PORT}/$BASE_URL}"
