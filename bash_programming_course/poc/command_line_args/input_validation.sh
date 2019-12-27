#!/bin/bash

if [ $# < 1 ]; then
	printf "[!] Usage: %s <param_1 param_2 param_n...>\n" $0
	exit
else
	for p in $@; do
		printf "[*] Param: %s\n" $p
	done
fi



