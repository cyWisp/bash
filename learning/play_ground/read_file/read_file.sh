#!/bin/zsh

cat $1 | while read line; do
	echo "content: ${line}"
done
