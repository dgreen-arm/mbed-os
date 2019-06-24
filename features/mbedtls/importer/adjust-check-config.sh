#!/bin/sh
#
# This file is part of mbed TLS (https://tls.mbed.org)
#
# Copyright (c) 2019, Arm Limited, All Rights Reserved
#
# Purpose
#
# Removes checks from check_config.h that aren't needed for Mbed OS
#
# Usage: adjust-check-config.sh [path to check_config file]
#
set -eu

if [ $# -ne 1 ]; then
    echo "Usage: $0 path/to/check_config.h" >&2
    exit 1
fi

FILE=$1

conf() {
    $SCRIPT -f $FILE --force $@
}

remove_code() {
    MATCH_PATTERN=$(IFS=""; printf "%s" "$*")

    perl -0pi -e "s/$MATCH_PATTERN//g" "$FILE"
}

remove_code                                                                                 \
    "#if defined\(MBEDTLS_PSA_INJECT_ENTROPY\) &&              \\\\\n"                      \
    "    !defined\(MBEDTLS_NO_DEFAULT_ENTROPY_SOURCES\)\n"                                  \
    "#error \"MBEDTLS_PSA_INJECT_ENTROPY is not compatible with actual entropy sources\"\n" \
    "#endif\n"                                                                              \
    "\n"
