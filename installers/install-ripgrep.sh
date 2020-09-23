#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Installs ripgrep either using Debian/Ubuntu package
## manager or downloading the package and installing it.

set -o errexit
set -o nounset

# @see https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself/4774063
readonly SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Package name pattern to be checked in package manager
readonly _package_name_search_pattern='^ripgrep$'

readonly _release_file_search_pattern='ripgrep_.+_amd64\.deb'
readonly _github_repo_name='BurntSushi/ripgrep'
readonly _file_glob='ripgrep_*_amd64.deb'

# Check package manager
if [[ $(apt-cache search --names-only "$_package_name_search_pattern") ]]; then
    sudo apt install ripgrep
else
    # Download deb file and install it directly
    $SCRIPTPATH/../github/latest-release-url.sh $_github_repo_name $_release_file_search_pattern | wget -qi -
    sudo dpkg --install $_file_glob
fi

