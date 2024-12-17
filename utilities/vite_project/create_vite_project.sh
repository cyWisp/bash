#!/usr/bin/env bash

function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2"
}

function check_error () {
  if [ $1 -ne 0 ]; then
    log "[x]" "Previous operation returned a non-zero status - exiting..."
    log "[x]" "Failed at ${2}."
    exit 1
  fi
}

function validate_user_input () {
  if [ -z "${1}" ]; then
    log "Please provide project name. Exiting."
    exit 1
  fi
}

function initialize () {
  log "Creating new vite project in current directory."
  npm create vite@latest $1 -- --template react-ts

  check_error $? "project initialization."

  cd $1
  npm i

  check_error $? "dependency installation"
}


validate_user_input $1
initialize $1

npm run dev


