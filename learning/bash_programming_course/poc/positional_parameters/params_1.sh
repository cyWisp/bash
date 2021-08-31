#!/bin/bash

if [ $# != 2 ]; then
	echo "[x] Please provide at least one parameter!"
	echo "[!] Usage: $0 <param>"
else
	echo "Script name: $0"
	echo "Param: $1"
	echo "Param: $2"
fi
