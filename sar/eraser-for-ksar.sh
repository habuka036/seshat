#!/bin/bash
# -*- coding:utf-8 -*-
set -e

function delete_section() {
    local keyword=$1
    local file=$2

    local all_line=$(wc -l "$file" | cut -f 1 -d ' ')
    if grep -q "$keyword" "$file"; then
        local start_line=$(grep -n "$keyword" "$file" | cut -f 1 -d ':')
        local tail_line=`expr $all_line - $start_line + 1`
        if tail -n $tail_line "$file" | grep -q ^$; then
            local space_line=$(tail -n $tail_line "$file" | grep -n ^$ |head -1 | cut -f 1 -d ':')
            local end_line=`expr $start_line + $space_line - 2`
        else
            local end_line=$all_line
        fi
        sed -i -e "${start_line},${end_line}d" $file
    fi
}

if [ ! -f "$1" ]; then
    echo "Cannot access file: $1"
    exit 1
fi

tmpfile=$(mktemp)
echo "create $tmpfile"
cp "$1" $tmpfile

# delete AM/PM
sed -i "s/[AP]M//g" $tmpfile

# delete section
for i in "kbhugfree" "irec/s" "ihdrerr/s" "imsg/s" "ierr/s" "active/s" "idvendor"; do
    delete_section "$i" $tmpfile
done

mv $tmpfile "$1.new"
echo "create $1.new"
exit 0
