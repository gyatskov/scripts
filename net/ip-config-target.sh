#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Needs to be run from the target device
##

set -eu

TARGET_ETH_INTERFACE=$1
HOST_ETH_ADDRESS=$2
ETH_NETMASK=$3
ETH_NETSIZE=$4

# Example:
#TARGET_ETH_INTERFACE=enx00909e9a9e6e
#HOST_ETH_ADDRESS=192.168.0.23
#ETH_NETMASK=192.168.0.0
#ETH_NETSIZE=24

sudo ip route add "${ETH_NETMASK}/${ETH_NETSIZE}" dev "${TARGET_ETH_INTERFACE}"
sudo ip addr  add "${HOST_ETH_ADDRESS}"           dev "${TARGET_ETH_INTERFACE}"

