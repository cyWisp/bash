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
	echo "${pass}" | sudo -S apt install \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release

	# Add Docker's official GPG key:
	echo "[!] Downloading and adding official Docker GPG key..."
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

	# Set up 'stable repository'
	echo "[!] Setting up 'stable' repository..."
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

uninstall_old_versions
set_up_repo
