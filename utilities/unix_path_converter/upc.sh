#!/usr/bin/env bash


echo "$1" | sed 's/\\/\//g' | sed -E -e 's|([A-Za-z]):|/mnt/\L\1|g' -e 's|\\|/|g'
