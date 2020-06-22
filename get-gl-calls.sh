#!/usr/bin/env bash
# @author Gennadij Yatskov
#
# 1. Creates a text file with all occurences and line locations of gl*
# 2. Prints histogram
#

## grep options:
# -r : recursive
# -n : show line numbers
# -E : use extended regex
# -o : only matching text
# -c : count of occurences
# --include : include certain file name pattern
# --exclude-dir : exclude directory

FILENAME=ogl-calls-outside-ogl.txt
# \b : word boundary
# [:alnum:] : Alpha numeric character group (case insensitive)
REGEX='gl[A-Z]+([[:alnum:]_]+)\s*'
grep --exclude-dir=ogl --include "*.cpp" --include "*.h" -ron -E "$REGEX" ./ > $FILENAME
UNIQUE_GL_FUNS="$(cut -d ':' -f 3 $FILENAME | sort -u)"
paste <(echo "$UNIQUE_GL_FUNS") <(echo "$UNIQUE_GL_FUNS" | xargs -I '^'  grep -F -c '^' $FILENAME) | tr -d ' \(' | sort -k2n | tac

