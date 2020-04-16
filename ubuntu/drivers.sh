#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## @warning The alternatives of cc and c++ MUST use the gcc toolchain.
##


# Devices which can use additional drivers
sudo ubuntu-drivers devices

# Available drivers
sudo ubuntu-drivers list

# Installs recommended drivers
sudo ubuntu-drivers autoinstall
