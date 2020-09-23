#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Installs up-to-date emacs version and spacemacs on top
##
## @note Intended to be used on older Ubuntu versions
##
## Requirements:
##  * git

set -o errexit

sudo add-apt-repository ppa:ubuntu-elisp/ppa
sudo apt-get update
sudo apt install emacs-snapshot

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
