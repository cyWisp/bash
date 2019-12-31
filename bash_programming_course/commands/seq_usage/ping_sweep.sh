#!/bin/bash

subnet=$(ifconfig | grep "wlp2s0" -A1 | grep inet | awk '{print $2}' | cut -d "." -f 1,2,3)
for i in $(seq 2 254); do
	reply=$(ping -c 1 -w 1 ${subnet}.$i) | grep "bytes from"
	if [ "$reply" = "" ]; then
		echo "[x] ${subnet}.${i} : DOWN"
	else
		echo "[*] ${subnet}.${i} : UP"
	fi
done

#success_file=$(cat "./success")
#fail_file=$(cat "./fail")
#
#result_success=$(grep "bytes from" ./success)
#if [ "$result_success" = "" ]; then
#	echo "fail"
#else
#	echo "success"
#fi



