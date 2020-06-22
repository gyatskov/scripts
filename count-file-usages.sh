#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
git ls-files |  grep -E '\.h$'   | xargs -I'{}' bash -c 'echo -n "{} : " && grep -rl {} | wc -l' > used-h-files.txt
git ls-files |  grep -E '\.cpp$' | xargs -I'{}' bash -c 'echo -n "{} : " && grep -rl {} | wc -l' > used-cpp-files.txt

