#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Clones ccls repository, builds the binary and copies it
## to the default install directory.
##
## Requirements:
##  * git
##  * cmake

set -o errexit

git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

mkdir Release
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release
sudo cmake --build Release --target install --parallel 8
