#!/usr/bin/env bash

declare -a arr=(
  "portal"
  "payload"
  "all"
)

function validate () {
  local_arr="$1"

  for i in "${local_arr[@]}"; do
    echo $i
  done
}



validate "${arr[@]}"

