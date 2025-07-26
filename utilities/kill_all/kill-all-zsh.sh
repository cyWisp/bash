#!/usr/bin/env zsh

TARGET_PROCESS="ssh-agent"
SCRIPT_NAME="./kill_all.sh"
LOG_PATH="/Users/d0zzzr/Desktop/results.txt"

function log () {
  echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
}

function validate_user_input () {
  if [ -z "${TARGET_PROCESS}" ]; then
    log "Please provide valid process name. Exiting."
    exit 1
  fi
}

function kill_duplicate_processes () {
  log "Enumerating duplicate processes."

  IFS=$'\n'
  declare -a processes=( $(ps aux | grep $1 | grep -v 'zsh\|grep') )

  echo "PROCESSES $processes"

  if [ "${#processes[@]}" -eq "0" ]; then
    log "No processes found matching search criteria. Exiting."
    exit 0
  else
    log "Duplicate processes found: ${#processes[@]}"
  fi

  for process in "${processes[@]}"; do
    if [[ "${process}" != *"${SCRIPT_NAME}"* ]]; then

      pid="$(echo $process | awk -F ' ' '{print $2}')"
      process_name="$(echo $process | awk -F ' ' '{print $(NF-1)}')"

      log "Killing process ${process_name} | ${pid}"
      kill -s TERM $pid
  fi
  done
}

validate_user_input
kill_duplicate_processes $TARGET_PROCESS > $LOG_PATH