#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

readonly LISTEN_ADDRESS=$1
readonly LISTEN_PORT=$2
readonly BASE_URL=$3

# Example
#LISTEN_ADDRESS=0.0.0.0
#LISTEN_PORT=9876
#BASE_URL=sharing-session

# Transcodes input to motion jpeg and streams it by the provided hostname and port
cvlc v4l2://$(ls /dev/video*) --sout "#transcode{vcodec=mjpg}:std{access=http,mux=mpjpeg,dst=$LISTEN_ADDRESS:$LISTEN_PORT/$BASE_URL}"

