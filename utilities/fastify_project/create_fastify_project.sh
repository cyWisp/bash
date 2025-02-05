#!/usr/bin/env zsh


declare -a PACKAGES=(
  "@fastify/cors"
  "@types/node"
  "dotenv"
  "fastify"
  "knex"
  "pg"
  "pino"
  "ts-node"
)


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


function install_additional_dependencies () {
    log "Installing dependencies."

    for d in "${PACKAGES[@]}"; do
        npm i "${d}" --save-dev
    done

    check_error $? "additional dependencies"
}


function initialize () {
  log "Creating a new fastify project in $(pwd)"

  npm init -y && tsc --init
  check_error $? "Initialization"

}

function create_project_structure () {
  log "Creating project structure."

  mkdir -p src/db
  check_error "Project structure"
}




validate_user_input $1
initialize