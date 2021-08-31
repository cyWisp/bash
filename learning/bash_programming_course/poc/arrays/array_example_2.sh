#!/bin/bash

function mult_by_two(){
	result=$(expr $1 \* 2)
	echo "$result"
}

nums=(1 2 3)
sols=()

for x in ${!nums[@]}; do
	solution=$(mult_by_two ${nums[$x]})
	sols+=( $solution )
done

for x in ${sols[@]}; do
	printf "%s\n" $x
done



