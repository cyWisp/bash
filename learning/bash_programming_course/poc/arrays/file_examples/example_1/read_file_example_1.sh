#!/bin/bash

if [ "$#" != "1"  ]; then
	printf "[!] Usage: ./%s <FILE>\n" $0
	exit 0
elif [ -e $1 ]; then
	:
else
	printf "[x] %s does not exist!\n" $1
fi

printf "File contents: \n"

file_contents=()

cat $1 | while read line; do
	file_contents+=( $line )
done

for x in ${file_contents[@]}; do
	printf"%s\n" $x
done
