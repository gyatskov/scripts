#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Clones cppcheck repository, builds the binary and copies it
## to the default install directory.
##
## Requirements:
##  * git
##  * cmake

set -o errexit

git clone https://github.com/danmar/cppcheck.git
cd cppcheck
sudo apt install libpcre3 libpcre3-dev

mkdir Release
cmake -BRelease -H. -DCMAKE_BUILD_TYPE=Release -DHAVE_RULES=ON -DUSE_MATCHCOMPILER=ON
sudo cmake --build Release --target install --parallel 8

