#!/bin/bash

# This script will set up the Docker repository
# and install Docker on CentOS 7

admin=$1
docker_repo="https://download.docker.com/linux/centos/docker-ce.repo"
log_file="./install.log"

# Install yum-utils
printf "[!] Installing yum-utils...\n" >> ${log_file}
echo ${admin} | sudo -S yum install -y yum-utils >> ${log_file}

printf "[!] Adding Docker repository...\n" >> ${log_file}
sudo yum-config-manager --add-repo ${docker_repo} >> ${log_file}

printf "[!] Installing docker-ce, docker-cd-cli and containerd.io\n" >> ${log_file}
sudo yum install -y docker-ce docker-cd-cli containerd.io >> ${log_file}

printf "[!] Initializing post-installation tasks...\n"
printf "[!] Creating docker group...\n"
sudo groupadd docker

printf "[!] Adding user ${admin} to docker group...\n"
sudo usermod -aG docker ${admin}

printf "[!] Refreshing group membership..."
newgrp docker
