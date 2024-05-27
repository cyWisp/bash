#!/usr/bin/env bash


function log () {
        echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
    }


function verify_root () {
    if [ "$EUID" -ne 0 ]; then
        log "This script must run with root privileges - exiting."
        exit
    fi
}


function update_locate_db () {
    cd /
    /usr/libexec/locate.updatedb
    cd -
}

verify_root

log "[!] Updating locate DB."
update_locate_db

if [ "$?" -ne 0 ]; then
    log "[x] Update failed."
else
    log "[*] Update succeeded."
fi
