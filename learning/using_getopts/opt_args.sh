#!/usr/bin/env bash

while getopts l:t: flag; do
  case "${flag}" in
    l) LOG_LEVEL=${OPTARG};;
    t) TYPE=${OPTARG};;
  esac
done

echo "log level: ${LOG_LEVEL}"
echo "type: ${TYPE}"


