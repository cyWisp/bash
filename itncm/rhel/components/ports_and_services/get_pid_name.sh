#!/bin/bash

netstat_output=$(sudo netstat -antp | grep LISTEN)

echo "${netstat_output}" | while read line; do
    pid_num=$(echo ${line} | awk '{print $7}' | awk -F "/" '{print $1}')
    echo "$pid_num"
done
