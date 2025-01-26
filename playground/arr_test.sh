#!/usr/bin/env zsh

declare DEPS=(
    "one"
    "two"
    "three"
)


for i in "${DEPS[@]}"; do
    echo $i
done



