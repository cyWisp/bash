#!/bin/bash
#function backup_file(){
#	if [ -f $1 ]; then
#		BACK="~/Desktop/$(basename ${1}).$(date +%F).$$"
#		echo "Backing up $1 to ${BACK}"
#		cp $1 $BACK
#	fi
#}
#
#FILE=$1
#backup_file FILE
#
#if [ $? -eq 0 ]; then
#	echo "Backup succeeded!"
#fi

function testing(){
	if [ -f $1 ]; then
		echo "${1} is a file..."
	else
		echo "${1} is not a file..."
	fi
}

test_file=$1

testing $test_file
