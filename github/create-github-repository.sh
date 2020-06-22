#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##

GITHUB_ENDPOINT="$1"
GITHUB_TOKEN="$2"

COMPONENT_NAME="$3"
COMPONENT_DESCRIPTION="$4"

read -r -d '' PAYLOAD <<EOS
  {
      "name":         "$COMPONENT_NAME",
      "description":  "$COMPONENT_DESCRIPTION",
      "private":      false,
      "has_issues":   false,
      "has_projects": false,
      "has_wiki":     false
  }
EOS

echo "$PAYLOAD"

curl -X POST $GITHUB_ENDPOINT/user/repos \
     -H "Accept: application/vnd.github.full+json" \
     -H "Authorization: token $GITHUB_TOKEN" \
     --data "$PAYLOAD"

