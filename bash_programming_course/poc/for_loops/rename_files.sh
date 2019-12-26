#!/bin/bash

# This script will rename all text files in the current directory
# To reflect the current date and the original filename
# Concatenated with a "-"

text_files=$(ls *.txt)
current_date=$(date +%F)

for f in $text_files; do
	echo "Renaming ${f} to ${current_date}-${f}"
	mv ${f} ${current_date}-${f}
done

echo "[*] Done..."
