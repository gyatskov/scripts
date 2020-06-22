#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

readonly NEEDLE_DIR=$1
readonly HAYSTACK_DIR=$2

while read line; do
  echo "$line:"
  rg -c "$line" "$HAYSTACK_DIR"
done < <(find "$NEEDLE_DIR" -type f)
