#!/usr/bin/env bash

BASE_IMAGE="postgres:"
VOLUME_NAME='pgdata'


function log () {
  echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
}


function validate_user_input () {
  if [ -z "${1}" ]; then
    log "Please provide valid image name. Exiting."
    exit 1
  fi
}


function check_error () {
  if [ $1 -ne 0 ]; then
    log "[x]" "Previous operation returned a non-zero status - exiting..."
    log "[x]" "Failed at ${2}."
    exit 1
  fi
}


function pull_image () {
  validate_user_input $1

  log "Pulling ${BASE_IMAGE}${1}."
  docker pull "${BASE_IMAGE}${1}"

  check_error $? "pull_image"

}


function verify_volume () {
  volume_created="$(docker volume ls | grep $VOLUME_NAME | awk -F ' ' '{print $1}')"

  if [ -z "${volume_created}" ]; then
    log "Failed to create volume ${VOLUME_NAME}"
    log "Exiting."
    exit 1
  else
    log "Volume created successfully."
  fi

}


function create_volume () {
  log "Creating volume ${VOLUME_NAME}."
  docker volume create $VOLUME_NAME

  check_error $? "create_volume"
  verify_volume

}


function create_and_run_container () {
  log "Creating and running container."

  docker run --name postgres-dev \
  -e POSTGRES_PASSWORD="password" \
  -v "${VOLUME_NAME}:/var/lib/postgresql/data" \
  -p 5432:5432 \
  -d \
  "${BASE_IMAGE}${1}"
}


pull_image $1
create_volume
create_and_run_container $1
