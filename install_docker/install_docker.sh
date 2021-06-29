#!/bin/bash

# This script will set up the Docker repository
# and install Docker on CentOS 7

admin=""
docker_repo="https://download.docker.com/linux/centos/docker-ce.repo"
log_file="./install.log"

# Install yum-utils
printf "[!] Installing yum-utils...\n" >> ${log_file}
echo ${admin} | sudo -S yum install -y yum-utils

printf "[!] Adding Docker repository...\n" >> ${log_file}
sudo yum-config-manager --add-repo ${docker_repo}

printf "[!] Installing docker-ce, docker-cd-cli and containerd.io\n" >> ${log_file}
sudo yum install -y docker-ce docker-cd-cli containerd.io

printf "[!] Got here!"


