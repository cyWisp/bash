#!/bin/bash

# This script will set up the Docker repository
# and install Docker on CentOS 7

if [ $# -eq 0 ]
then
	echo "Please provide a user name..."
	exit 0
fi

admin=$1
pass="ADMINforJUSTICE1220!"
docker_repo="https://download.docker.com/linux/centos/docker-ce.repo"
log_file="./install.log"

# Install yum-utils
printf "[!] Installing yum-utils...\n"
echo ${pass} | sudo -S yum install -y yum-utils

printf "[!] Adding Docker repository...\n"
sudo yum-config-manager --add-repo ${docker_repo}

printf "[!] Installing docker-ce, docker-cd-cli and containerd.io\n"
sudo yum install -y docker-ce docker-cd-cli containerd.io

printf "[!] Initializing post-installation tasks...\n"
printf "[!] Creating docker group...\n"
sudo groupadd docker
exit_code=$?

if [ ${exit_code} -eq '9' ]
then
	printf "[!] Group already exists, bypassing...\n"
fi

printf "[!] Adding user ${admin} to docker group...\n"
echo ${pass} | sudo -S usermod -aG docker ${admin}

printf "[!] Refreshing group membership..."
newgrp docker
