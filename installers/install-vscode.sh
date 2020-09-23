#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Downloads the x64 .deb binary and installs it
##
## Requirements:
##  * curl

readonly FILENAME=vscode-latest.deb
readonly URL='https://go.microsoft.com/fwlink/?LinkID=760868'

curl -L -o   "$FILENAME" "$URL"
sudo dpkg -i "$FILENAME"

# Installs vscode plugins specified in text file
xargs -a vscode-plugins.txt -I{} code --install-extension {}
