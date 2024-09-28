#!/usr/bin/env bash

output=$(tmux ls 2>&1 | awk -F ' ' '{printf("%s %s %s", $1, $2, $3)}')

if ! [ "${output}" == "no server running" ]; then
  echo "yep"
else
  echo "nope"
fi

