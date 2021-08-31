#!/bin/bash

test_file="./test.txt"

cat ${test_file} | while read line; do
	echo $line | awk '{print $NF}'
done
