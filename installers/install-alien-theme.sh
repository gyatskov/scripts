#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Installs a symlink to the alien zsh theme in oh-my-zsh
##

set -e

git clone https://github.com/eendroroy/alien.git

cd alien
git submodule update --init --recursive
ln -s alien/alien.zsh-theme ~/.oh-my-zsh/themes/alien.zsh-theme

