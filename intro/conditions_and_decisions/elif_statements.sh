#!/usr/bin/env bash

MY_VAR="csh"

if [ "$MY_VAR" = "bash" ]
then
	echo "You seem to like the bash shell..."
elif [ "$MY_VAR" = "csh" ]
then
	echo "You seem to like the csh shell..."
else
	echo "You don't seem like either csh or bash..."
fi
