#!/bin/bash
# -*- coding: utf-8 -*-
#
# Extract rpm file
# memo scripts
# $ rpm2cpio some.rpm | cpio -idvm
#
set -e

USAGE="usage: $0 RPM_FILE [OUTPUT_DIR]"
REQUIRE_COMMANDS="rpm2cpio cpio"
CPIO_OPTS=${CPIO_OPTS:-'-idvm'}
for cmd in $REQUIRE_COMMANDS; do
    if ! which "$cmd" 2>&1 > /dev/null; then
        echo "requires commad : $REQUIRE_COMMANDS" 1>&2
        exit 1
    fi
done

RPM_FILE=$1
OUTPUT=${2:-"."}

[[ $# -lt 1 ]] && echo $USAGE 1>&2 && exit 1
[[ ! -r "$1" ]] && echo "No such file : $1" 1>&2 && exit 1
[[ "$OUTPUT" != "." ]] && [[ ! -d $OUTPUT ]] && mkdir -p $OUTPUT

cd $OUTPUT
rpm2cpio "$RPM_FILE" | cpio $CPIO_OPTS

exit 0
