#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Installs gcc-8 and adds it as a system alternative
##
## @note Intended to be used on older Ubuntu versions

set -o errexit

sudo apt-get install build-essential software-properties-common -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update
sudo apt install gcc-snapshot

sudo apt install gcc-8 g++-8 -y

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 800
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800

