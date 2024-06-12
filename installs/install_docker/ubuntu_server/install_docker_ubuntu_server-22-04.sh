#!/usr/bin/env bash

# Provide explicit user, e.g. - ./install_docker_ubuntu_server-22-04.sh wisp

function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1"
}

function verify_root () {
    log "Verifying root user."

    if [ "$EUID" -ne 0 ]; then
      log "This script requires root privileges."
      exit
  fi
}

# Set up Docker's apt repository
function repo_setup () {
  # Install dependencies
  apt-get update
  apt-get install ca-certificates curl -y
  apt-get install -m 0755 -d /etc/apt/keyrings

  # Download gpg and modify permissions
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  # Verify gpg key and update repositories
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt-get update
}

# Install Docker
function install_docker () {
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function post_install () {
  groupadd docker
  usermod -aG docker $1
  newgrp docker
}


verify_root
repo_setup
install_docker
post_install