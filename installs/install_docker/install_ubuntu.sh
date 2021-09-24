#!/bin/bash

# This script will set up the Docker repository
# and install docker on Ubuntu server 18.04 LTS

# Administrative credentials
read -p "[?] User: " user
read -p "[?] Pass: " -s pass

function uninstall_old_versions () {
	# Uninstall older versions
	echo "[!] Uninstalling older Docker versions..."
	echo "${pass}" | sudo -S apt remove \
		docker \
		docker-engine \
		docker.io \
		containerd runc
}

function set_up_repo () {
	# Set up repository
	echo "[!] Installing necessary packages..."
	echo "${pass}" | sudo -S apt update
	echo "${pass}" | sudo -S apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release

	# Add Docker's official GPG key:
	echo "[!] Downloading and adding official Docker GPG key..."
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	sudo apt-key add -

	# Modify key permissions
	sudo chmod a+r /usr/share/keyrings/docker-archive-keyring.gpg

	# Set up 'stable repository'
	echo "[!] Setting up 'stable' repository..."
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

function install_docker () {
	# Update repositories and install docker
	echo "[!] Installing docker..."
	echo "${pass}" | sudo -S apt update
	sudo apt install \
		docker-ce \
		docker-ce-cli \
		containerd.io
}

function post_install () {
	# Post install - create docker group if it doesn't exist
	echo "[!] Initializing post-installation tasks..."
	echo "[!] Creating docker group..."
	sudo groupadd docker
	exit_code=$?

	if [ ${exit_code} -eq '9' ]
	then
    	printf "[!] Group already exists, bypassing...\n"
	fi

	echo "[!] Adding user ${user} to docker group..."
	echo ${pass} | sudo -S usermod aG docker ${user}

	echo "[!] Refreshing group membership..."
	echo ${pass} | sudo -S newgrp docker
}

uninstall_old_versions
set_up_repo
install_docker
# post_install
