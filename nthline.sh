#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
sed -n ${LINE}p

#or 

awk "NR==${LINE}"
