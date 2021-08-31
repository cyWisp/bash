#!/usr/bin/env bash

MY_SHELL="bash"

#always make sure to enclose compared objects in quotes to avoid errors
if [ "$MY_SHELL" = "bash" ]
then
	echo "You sure seem to like the ${MY_SHELL} shell..."
else
	echo "Not sure which shell that is..."
fi
