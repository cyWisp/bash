#!/usr/bin/env bash

input_string="$1"

function log () {
  echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
}

function validate_user_input () {
  if [ -z "${input_string}" ]; then
    log "Please provide valid process name. Exiting."
    exit 1
  fi
}

function kill_duplicate_processes () {
  log "Enumerating duplicate processes."

  IFS=$'\n'
  declare -a processes=( $(ps aux | grep $1 | grep -v 'bash\|grep') )

  if [ "${#processes[@]}" -eq "0" ]; then
    log "No processes found matching search criteria. Exiting."
    exit 0
  else
    log "Duplicate processes found: ${#processes[@]}"
  fi

  for process in "${processes[@]}"; do
    pid="$(echo $process | awk -F ' ' '{print $2}')"
    process_name="$(echo $process | awk -F ' ' '{print $(NF-1)}')"

    log "Killing process ${process_name} | ${pid}"
    kill -s TERM $pid
  done
}

validate_user_input
kill_duplicate_processes $input_string