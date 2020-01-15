#!/bin/bash

netstat_output=$(sudo netstat -antp | grep LISTEN)

echo "${netstat_output}" | while read line; do
    echo "${line}"
done
