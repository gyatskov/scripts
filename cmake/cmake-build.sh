#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Generates project (make)files using cmake
##
## Provides custom parameters (if required) for a specific project.
##

set -eu

readonly PROJECT_ROOT_DIR="$1"
readonly BUILD_DIR="$2"
readonly BIN_DIR="$3"

#readonly GENERATOR="Ninja"
readonly GENERATOR="Unix Makefiles"
readonly BUILD_TYPE='debug'

#    -B "${BUILD_DIR}/${PROJECT}/${PLATFORM}/${BUILD_TYPE}/${SWC}" \
cmake "$PROJECT_ROOT_DIR" \
    -B "${BUILD_DIR}" \
    -S "${PROJECT_ROOT_DIR}" \
    -G "${GENERATOR}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
    -DCMAKE_INSTALL_PREFIX="$BIN_DIR"

