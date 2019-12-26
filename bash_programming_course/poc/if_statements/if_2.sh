#!/bin/bash

my_shell="bash"

if [ "$my_shell" = "csh" ]
then
	echo "you seem to like the csh shell..."
elif [ "$my_shell" = "zsh" ]
then
	echo "you seem to like the zsh shell..."
else
	echo "you seem to like the bash shell..."
fi
