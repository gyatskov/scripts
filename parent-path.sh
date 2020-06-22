#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

set -o nounset
set -o errexit

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
export parent_path
