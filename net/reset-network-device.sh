#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

dev="$1"

sudo ip link set down dev "$dev"
sudo ip link set up  dev  "$dev"

