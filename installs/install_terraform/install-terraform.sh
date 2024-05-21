#!/usr/bin/env bash

function log () {
	echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1"
}

function check-root () {
	if [ "$EUID" -ne 0 ]; then
		echo "[x] This script must run as root."
  		exit
	fi
}

function install-prerequisites () {
	log "[!] Installing pre-requisites."
	apt install -y gnupg software-properties-common
}

function install-gpg-key () {
	log "[!] Downloading and installing Hashicorp GPG key."
	wget -O- https://apt.releases.hashicorp.com/gpg | \
	gpg --dearmor | \
	tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
}

function verify-key-fingerprint () {
	log "[!] Verifying key fingerprint."
	gpg --no-default-keyring \
		--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
		--fingerprint
}

function add-hashicorp-repo () {
	log "[!] Adding the official Hashicorp repository."
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
		https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
	
	tee /etc/apt/sources.list.d/hashicorp.list

}


function update-and-install-terraform () {
	log "[!] Installing Terraform!"
	apt update && apt install terraform
}


check-root
install-prerequisites
install-gpg-key
verify-key-fingerprint
add-hashicorp-repo
update-and-install-terraform

# Verify the installation
terraform -help
