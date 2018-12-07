#!/usr/bin/env bash

# Storing the output of a command in a variable

HOST_NAME=$(hostname)
OS=$(uname)
RIGHT_NOW=$(date)

echo "The hostname of this machine is ${HOST_NAME}..."
echo "The operating system is ${OS}..."
echo "The current time and date is ${RIGHT_NOW}..."

