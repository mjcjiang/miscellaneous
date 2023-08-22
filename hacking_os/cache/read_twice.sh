#!/bin/bash

if [[ -e testfile ]]; then
    rm -r testfile
fi

echo "$(date): start file creation"
dd if=/dev/zero of=testfile oflag=direct bs=1M count=1K
echo "$(date): end file creation"

echo "$(date): sleep 3 seconds"
sleep 3

echo "$(date): start first read"
cat testfile >/dev/null
echo "$(date): end first read"

echo "$(date): sleep 3 seconds"
sleep 3

echo "$(date): start send read"
cat testfile >/dev/null
echo "$(date): end send read"

rm -r testfile
