#!/bin/bash

# Defining an array that contains both string and numeric literals
my_array=("rob" "dan" 4 8 "mike" 32 "todd" 128)

# storing the third element in a variable
# Bash arrays are also zero-indexed
third_element=${my_array[2]}

# Looping through the array using the seq command
for x in seq $(seq 1 8); do
	printf "%s\n" ${my_array[$x]}
done

# Looping through the array using the "in" keyword
# And the @ (all) index

for x in ${my_array[@]}; do
	echo "${x}"
done



