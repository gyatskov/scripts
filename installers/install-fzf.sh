#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Clones fzf repository and installs it
##
## Requirements:
##  * git

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
