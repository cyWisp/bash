#!/bin/bash

test_file="./test.txt"

if [ -s "$test_file" ]; then
	echo "File is not empty"
else
	echo "File is empty"
fi
