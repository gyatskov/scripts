#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Extracts the URL of the latest binary
##
## Usage: $0 <github-project-name> <artifact-pattern>
## Example: latest-release-url.sh BurntSushi/ripgrep 'ripgrep_.+_amd64\.deb'
##
## Requirements:
##  * curl
##  * jq

function latest_release_url()
{
    # E.g. 'BurntSushi/ripgrep'
    local -r _project=$1

    # E.g. 'ripgrep_.+_amd64\.deb'
    local -r _artifact_pattern=$2

curl -sL "https://api.github.com/repos/$_project/releases/latest" | jq -r '.assets[].browser_download_url' \
    | grep -E "$_artifact_pattern"
}

_project="$1"
_artifact_pattern="$2"

latest_release_url "$_project" "$_artifact_pattern"

