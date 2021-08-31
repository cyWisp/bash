#!/bin/bash

if [ "$#" != "1" ]; then
	printf "[!] Usage: %s <remote_host>\n" $1
	exit 0
else
	remote_host=$1
fi

command_output=$(ping -c 1 $remote_host | grep PING | awk '{print $3}' | tail -c +2 | head -c -2)


if [ "$?" -eq "0" ]; then
	printf "[*] Host Reachable: %s\n" ${command_output}
else
	echo "[x] Host Unreachable!"
fi



