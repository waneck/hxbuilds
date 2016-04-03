#!/bin/bash

if [[ -z "$1" ]]; then
  echo "log.sh: needs file name"
  exit 1
fi

echo "" > "$1"

while read line; do
  echo "$line" >> "$1"
done


