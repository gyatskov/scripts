#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##

readonly HOST="$1"

function download_index() {
	local url=$1

	wget $url/index.html
}

## @note Really dependent on the actual index structure
function parse_index() {
	local in_file=$1

	grep -Po '(?<!./)[[:digit:]]{4}.+\.patch\b' $in_file
}


## Downloads each entry in a text file
## using wget.
function download_patches() {
	local url=$1
	local file_list=$2

	xargs -a patch_list.txt -I{} wget $url/{};
}


download_index   "$HOST"
parse_index      index.html > patch_list.txt
download_patches "$HOST" patch_list.txt
