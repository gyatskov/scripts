#!/usr/bin/env bash
set -e

SHA=$(git rev-parse --short HEAD)

git reset HEAD^

git diff-tree --no-commit-id --name-only -r $SHA | while read -r f; do
  git add "$f"
  GIT_EDITOR="echo '0a\n$SHA $f\n\n.\nw' | ed -s" git commit -m "$SHA: ${f}"
done

