#!/usr/bin/env bash

MY_VAR="csh"

if [ "$MY_VAR" = "bash" ]
then
	echo "You seem to like the bash shell..."
else
	echo "You don't seem to like the bash shell..."
	echo "I see you're more into the ${MY_VAR} shell..."
fi
