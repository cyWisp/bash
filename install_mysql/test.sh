#!/bin/bash

temp_pw="/home/$(whoami)/mysql_temp_pw"
test_text=$(grep 'name' ./test.txt)

echo "${temp_pw}"
echo "${test_text}"
