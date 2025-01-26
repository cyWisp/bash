#!/usr/bin/env bash

DB_SCHEMA_PATH="db/schema/app"
DB_PAYLOAD_PATH="frontEnd/payload/app"

function usage () {
  echo "Run database migrations for portal and/or payload."
  echo "Usage: $0 [-d <string> [portal | payload | all]]" 1>&2; exit 1;
}

function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2"
}

function portal_migrations {
    log "Running portal migrations..."
    (
        cd $DB_SCHEMA_PATH || exit
        npm i
        npm start
    )
}


function payload_migrations {
    log "Running payload migrations..."
    (
        cd $DB_PAYLOAD_PATH || exit
        npm i
        npm run migrate
    )
}


function db_ops () {
  if [ -z "${1}" ]; then
    usage

  elif [ "${1}" == "portal" ]; then
    portal_migrations && wait $!

  elif [ "${1}" == "payload" ]; then
    payload_migrations && wait $!

  elif [ "${1}" == "all" ]; then
    portal_migrations && wait $!
    payload_migrations && wait $!

  else
    usage

  fi
}


while getopts ":d:" input; do
  case "${input}" in
    d)
      d=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done

db_ops $d
