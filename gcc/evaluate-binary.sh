#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
##
## Evaluates the generated ELF by inspecting its memory sections
## Possible stack overlaps can be found this way.
##
## @note Work in progress

# Prefix for cross-compilation toolchain
readonly TOOLCHAIN_PREFIX=~/opt/gcc-arm-none-eabi-9-2019-q4-major/bin/arm-none-eabi-
# ELF file to be analyzed
readonly IMAGE_FILE=binary.elf

readonly relevant_addr="$1"

# Show sections
${TOOLCHAIN_PREFIX}readelf -S  $IMAGE_FILE

# Scan assembly for the relevant address
${TOOLCHAIN_PREFIX}objdump -dr $IMAGE_FILE

# Sort symbols numerically by address
${TOOLCHAIN_PREFIX}nm -n $IMAGE_FILE
