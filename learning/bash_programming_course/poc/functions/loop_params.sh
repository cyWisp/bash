#!/bin/bash

function hello(){
	for name in $@; do
		echo "Hello ${name}..."
	done
}

hello "rob" "chris" "jason"
