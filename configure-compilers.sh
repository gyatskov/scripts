#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

## Sets up gcc and clang as c/c++ compilers based on current alternatives
##
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 800
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-8 800

sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 1000
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-8 1000
