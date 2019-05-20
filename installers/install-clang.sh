#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Installs clang8 on Ubuntu 16.04
##

sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main"
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
sudo apt-get update
sudo apt-get install clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 clang-tidy-8

sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-8.0 800
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8.0 800

