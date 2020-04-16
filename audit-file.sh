#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Logs are written into /var/log/audit.log

readonly path="$1"

sudo auditctl -w "$path" -p wa

# Remove via:
#sudo auditctl -W "$path" -p wa
