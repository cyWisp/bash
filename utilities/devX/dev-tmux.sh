#!/usr/bin/env bash

SNAME="dev"
LOG_FILE_PATH="dev-tmux.log"

DB_SCHEMA_PATH="db/schema/app"
DB_PAYLOAD_PATH="frontEnd/payload/app"

function clear_log () {
  # Clear the log file to assure logs are up to date.
  if [ -n "${LOG_FILE_PATH}" ]; then
    if [ -e "${LOG_FILE_PATH}" ]; then
      rm $LOG_FILE_PATH
    fi
  fi
}

clear_log


function log () {
  # Log to stdout and the above log file for troubleshooting
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2" | tee -a $LOG_FILE_PATH
}


function check_error () {
  # If the last command returned a non-zero status,
  # destroy everything.
  if [ "${1}" -ne 0 ]; then
    log "Failed at ${2}."

    log "Destroying containers and exiting."
    tmux kill-session -t $SNAME
    docker compose down
    exit 1
  else
    log "${2} completed successfully."
  fi
}


function kill_old {
  # Assure no sessions exist before attempting to create new containers
  tmux_ls_output=$(tmux ls 2>&1 | awk -F ' ' '{printf("%s %s %s", $1, $2, $3)}')

  if ! [ "${tmux_ls_output}" == "no server running" ] ; then
    log "Killing tmux session"
    tmux kill-session -t $SNAME
    docker compose down
  fi
}


function portal_migrations {
    log "Running portal migrations..."
    (
        cd $DB_SCHEMA_PATH || exit
        npm i
        npm run migrate
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


kill_old
check_error $? "kill_old init"

# Make sure we're up-to-date on our containers
log "Pulling images and running containers"
docker compose pull && docker compose up -d --remove-orphans
check_error $? "pull and compose up"

log "Running database migrations"
portal_migrations && wait $!
check_error $? "portal migrations"

payload_migrations && wait $!
check_error $? "payload migrations"

log "Building eventProcessor."
tmux new -s $SNAME -d
tmux rename-window -t $SNAME eventProcessor
tmux send-keys -t $SNAME 'cd orgMgt/eventProcessor/app && npm run dev' C-m
check_error $? "eventProcessor window creation"

log "Building ruleProcesssor."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME ruleProcessor
tmux send-keys -t $SNAME 'cd orgMgt/ruleProcessor/app && npm run dev' C-m
check_error $? "ruleProcessor window creation"

log "Building rp-backgroundWorker."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME rp-backgroundWorker
tmux send-keys -t $SNAME 'cd orgMgt/ruleProcessor/app && npm run start-worker' C-m
check_error $? "rp-backgroundWorker window creation"

log "Building pdfProcessor."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME pdfProcessor
tmux send-keys -t $SNAME 'cd orgMgt/pdfProcessor/app && npm run dev' C-m
check_error $? "pdfProcessor window creation"

log "Building login."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME login
tmux send-keys -t $SNAME 'cd frontEnd/login/app && npm run dev' C-m
check_error $? "login window creation"

log "Building payload."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME payload
tmux send-keys -t $SNAME 'cd frontEnd/payload/app && npm run dev' C-m
check_error $? "payload window creation"

log "Building landing."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME landing
tmux send-keys -t $SNAME 'cd frontEnd/landing/app && npm run dev' C-m
check_error $? "landing window creation"

log "Building rule-processor-client."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME rule-processor-client
tmux send-keys -t $SNAME 'cd shared/rule-processor-client && npm run dev' C-m
check_error $? "rule-processor-client window creation"

log "Starting docker logs."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME docker
tmux send-keys -t $SNAME 'docker compose logs -f' C-m
check_error $? "docker compose logs window creation"

log "Monitoring unleash service."
tmux new-window -t $SNAME
tmux rename-window -t $SNAME unleashServer
tmux send-keys -t $SNAME "docker logs -f $(docker ps -aqf 'name=portal-unleash-service')" C-m
check_error $? "unleash service window creation"

log "All builds completed successfully."

tmux select-window -t $SNAME:1

[ "$1" != "iterm" ] && tmux attach -t $SNAME
[ "$1" == "iterm" ] && tmux -CC attach -t $SNAME

kill_old