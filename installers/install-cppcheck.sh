#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##

git clone https://github.com/danmar/cppcheck.git
sudo apt install libpcre3 libpcre3-dev
cd cppcheck
mkdir build

make SRCDIR=build CFGDIR=cfg HAVE_RULES=yes -j8 CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function"
ln -s $(realpath cppcheck) /usr/local/bin/cppcheck
