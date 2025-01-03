#!/usr/bin/env zsh

LOG_FILE_PATH="app.log"

function clear_log () {
  if [ -e "${LOG_FILE_PATH}" ]; then
    rm $LOG_FILE_PATH
  fi
}

function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2" | tee -a $LOG_FILE_PATH

}

function check_error () {
  if [ "${1}" -ne 0 ]; then
    log "[x]" "Previous operation returned a non-zero status - exiting..."

    if [ -n "${2}" ]; then
      log "[x]" "Failed at ${2}."
      exit 1
    fi
  fi
}

function return_non_zero () {
  return 1
}

function return_zero () {
  return 0
}

clear_log

log "testing clear log again"
log "this is another line"

