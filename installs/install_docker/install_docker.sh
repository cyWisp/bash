#!/bin/env bash

# This script will set up the Docker repository
# and install Docker on CentOS 7

docker_repo="https://download.docker.com/linux/centos/docker-ce.repo"
log_file="./install.log"
user="wisp"


function log () {
        echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
    }


function verify_root () {
    if [ "$EUID" -ne 0 ]; then
        log "This script must run with root privileges - exiting."
        exit
    fi
}

function check_return_code () {
            # $1: return code
            # $2: success message
            # $3: failed message
            # $4: optional command to execute

            if [ $1 -ne 0 ]; then
                log "${3}"

                if ! [ -z "${4}" ]; then
                    eval "${4}"
                else
                    return 1
                fi

            else
                log "${2}"
            fi
}


# Install yum-utils
log "Installing yum-utils."
yum install -y yum-utils

check_return_code $? "Success." "Failed."

# Add the repo
log "Adding Docker repository."
sudo yum-config-manager --add-repo $docker_repo

check_return_code $? "Success." "Failed."

# Install docker and utilities
log "Installing docker-ce, docker-cd-cli and containerd.io."
sudo yum install -y docker-ce docker-cd-cli containerd.io docker-buildx-plugin docker-compose-plugin

check_return_code $? "Success." "Failed."

# Start docker and allow it to run at startup
systemctl start docker
systemctl enable docker

# Add docker group
log "Initializing post-installation tasks."
log "Creating docker group."
sudo groupadd docker

exit_code=$?

if [ ${exit_code} -eq '9' ]
then
	log "Group already exists, skipping."
fi

# Add user to docker group
log "Adding user ${user} to docker group."
usermod -aG docker ${user}

check_return_code $? "Success." "Failed."

log "Refreshing group membership."
newgrp docker

check_return_code $? "Success." "Failed."