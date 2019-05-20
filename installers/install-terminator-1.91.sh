#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Installs terminator 1.91 on Ubuntu 16.04

sudo apt install intltool
./setup.py build
sudo ./setup.py install --record=install-files.txt
