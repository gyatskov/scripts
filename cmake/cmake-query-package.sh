#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
readonly PACKAGE_NAME="$1"

cmake --find-package -DNAME="$PACKAGE_NAME" -DCOMPILER_ID=GNU -DLANGUAGE=C -DMODE=EXIST

