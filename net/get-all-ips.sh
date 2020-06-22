#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
ip addr | grep -oP '(?<=inet )[\d.]+'

