#!/bin/bash

file_name="./example_file.txt"

awk '{print $1}' ${file_name}
