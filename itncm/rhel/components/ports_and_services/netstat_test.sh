#!/bin/bash

netstat -aon | while read line; do
	$first_field=$(line | awk '{print $1}')
	echo "$first_field"
done
