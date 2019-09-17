#!/usr/bin/env bash

FILE=$1
WORD_TO_REPLACE=$2
REPLACEMENT_WORD=$3

# Check if the file exists
if [ -e ${FILE} ]
then
	# if the file exists,
	# replace the word given in the second argument with the word given
	# for the third argument
	sed -i -e s/${2}/${3}/g ${1}
	printf "[*] Replaced '${2}' with '${3}' in '${1}'...\n "	
else
	# if the file does not exist, display a message
	# and exit
	echo "[x] File does not exist..."
	echo "Please try again..."
fi


