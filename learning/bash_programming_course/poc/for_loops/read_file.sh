#!/bin/bash
input_file=$(cat ./test.txt)

printf "file: \n${input_file}"

for line in $input_file
do
	echo "$line"
done
