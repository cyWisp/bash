#!/usr/bin/env bash

FIRST_NUM=10
SECOND_NUM=3

if [ -e "./test.txt" ]
then
	echo "File exists"
else
	echo "File does not exist"
fi

if [ ${FIRST_NUM} -gt ${SECOND_NUM} ]
then
	echo "${FIRST_NUM} is greater than ${SECOND_NUM}"
else
	echo "${SECOND_NUM} is greater than ${FIRST_NUM}"
fi
