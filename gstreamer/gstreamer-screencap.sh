#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## @brief Different functions for recording screen contents using gstreamer
##

set -o nounset
set -o errexit

readonly FRAME_RATE=60

# Stream to window
function streamScreenToWindowPoorly()
{
gst-launch-1.0 ximagesrc startx=0 use-damage=0 \
    ! video/x-raw,framerate=$FRAME_RATE/1               \
    ! videoscale method=0                      \
    ! video/x-raw,width=1280,height=960        \
    ! ximagesink
}


# Stream to file
function streamScreenToFilePoorly()
{
local -r fileBasename="screen-$(date +%Y.%m.%d_%H-%M-%S)"
local -r fileExtension="mkv"
local -r fileName="${fileBasename}.${fileExtension}"

gst-launch-1.0 ximagesrc startx=0 use-damage=0   \
    ! "video/x-raw,framerate=$FRAME_RATE/1"               \
    ! videoscale method=0                        \
    ! "video/x-raw,width=1920,height=1080,nthreads=8"       \
    ! jpegenc                                    \
    ! filesink location="${fileName}"
}


# Stream screen to file but smoothly:
function streamScreenToFile()
{
local -r fileBasename="screen-$(date +%Y.%m.%d_%H-%M-%S)"
local -r fileExtension="mkv"
local -r fileName="${fileBasename}.${fileExtension}"

local -r XID=0
gst-launch-1.0 ximagesrc xid=$XID \
    ! video/x-raw,framerate=$FRAME_RATE/1 \
    ! queue \
    ! videoconvert \
    ! videorate \
    ! queue \
    ! x264enc \
    ! queue \
    ! avimux name=mux \
    ! queue \
    ! filesink location="${fileName}"
}

# Stream window to file smoothly
function streamWindowToFile()
{
local -r windowName=$1

local -r fileBasename="${windowName}-$(date +%Y.%m.%d_%H-%M-%S)"
local -r fileExtension="avi"
local -r fileName="${fileBasename}.${fileExtension}"

gst-launch-1.0 ximagesrc xname="$windowName" \
    ! video/x-raw,framerate=$FRAME_RATE/1 \
    ! queue \
    ! videoconvert \
    ! videorate \
    ! queue \
    ! x264enc \
    ! queue \
    ! avimux name=mux \
    ! queue \
    ! filesink location="${fileName}"
}
