#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Retrigger a given jenkins job specified by its ID
##

set -o nounset
set -o errexit

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Load configuration
source <(grep = $SCRIPTPATH/config.ini)

readonly JOB_NAME="$1"
readonly JOB_ID="$2"

# TODO:

## Retrigger conditions:
## * none of the relevant nodes have been found in the run (broke too early)
## * none of the failed pipeline node names correspond to relevant nodes listed (other projects failed)
## * known false-alarms in the relevant nodes occured

## Input: (user name, Gerrit change number)
## 1. Look for last failed jenkins job
##      * If none exists, success or waiting for build
## 2. Get jenkins job id from last failed jenkins comment
## 3. Retrieve the failed job's nodes
## 4. Check all nodes
##      * If none of the relevant nodes have been found in the run (broke too early) => (print all failed nodes, retrigger)
##      * If none of the node names appear in the relevant nodes file
##        the failure is "somewhere" else => (print failed nodes, retrigger)
##      * If failure in relevant node but known false-positive
##          => (print false positive, retrigger)
##      * If failure in relevant node but not known false-positive
##          => (print error, do nothing)

