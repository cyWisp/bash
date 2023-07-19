#!/bin/bash

# This script will set up the Docker repository
# and install docker on Ubuntu server 18.04 LTS
docker_user=$1

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

function get_docker_user () {
  target_user=$1
  user_exists="$(cat /etc/passwd | grep $target_user | cut -d ':' -f 1)"

  if [ "${user_exists}" != '' ]; then
    log "Docker user provided: ${target_user} | User found: ${user_exists}"

    if [ "${user_exists}" == "${target_user}" ]; then
      log "User ${target_user} verified in /etc/passwd."
    else
      log "User not found."
      exit 1
    fi

  else
    log "Please provide a valid sudo user for docker installation."
    log "Example: sudo ./install.sh <user>"
    exit 1
  fi
}


function uninstall_old_versions () {
	# Uninstall older versions
	log "[!] Uninstalling older Docker versions..."
	apt remove \
		docker \
		docker-engine \
		docker.io \
		containerd \
		runc
}


function install_requirements () {
	# Set up repository
	log "[!] Installing necessary packages..."
	apt update
	apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release \
		software-properties-common
}


function configure_repository () {
	# Add Docker's official GPG key:
	echo "[!] Downloading and adding official Docker GPG key..."

  # Add Docker's official GPG key
	install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Set up the repository
  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null


}


function install_docker () {
	# Update repositories and install docker
	log "Installing docker..."
	apt update
	apt install -y \
		docker-ce \
		docker-ce-cli \
		containerd.io
}


function post_install_setup () {
	# Post install - create docker group if it doesn't exist
	log "[!] Initializing post-installation tasks..."
	log "[!] Creating docker group..."
	groupadd docker
	exit_code=$?

	if [ ${exit_code} -eq '9' ]
	then
    		log "[!] Group already exists, bypassing."
	fi

	log "[!] Adding user ${docker_user} to docker group..."
	usermod -aG docker ${docker_user}

	log "[!] Refreshing group membership..."
	newgrp docker

	systemctl restart docker
	systemctl enable docker

}


verify_root
get_docker_user $docker_user

uninstall_old_versions
install_requirements
configure_repository
install_docker
post_install_setup
