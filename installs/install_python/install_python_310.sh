#!/usr/bin/env bash

function verify_return_code (){
	if [ $? -eq 0 ]; then
		echo "Success!"
	else
		echo "Failed!"
		exit 1
	fi
}

wsl_mount="/mnt/c"

# Prompt user for *nix password
unset pass
read -p "UNIX Password: " -s pass
echo ""

# Navigate to $HOME
echo "Navigating to home directory."
cd $HOME

# Update and upgrade Ubuntu installation
echo "Pulling latest udpates."
echo "${pass}" | sudo -S apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y
verify_return_code

# Install software properties, passing above password
echo "Installing software-properties-common."
sudo apt install software-properties-common -y
verify_return_code

# Add deadsnakes ppa and update
echo "Adding deadsnakes ppa repository."
sudo add-apt-repository ppa:deadsnakes/ppa -y
echo "Updating sources.list."
sudo apt update
verify_return_code

# Install necessary dependencies
#        libncurses5-dev \
#        libncursesw5-dev \
#        libxmlsec1-dev \
#        libreadline-dev \
#        tk-dev \

sudo apt install -y \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libsqlite3-dev \
        llvm \
        xz-utils \
        libgdbm-dev \
        lzma \
        lzma-dev \
        tcl-dev \
        libxml2-dev \
        libffi-dev \
        liblzma-dev \
        wget \
        curl \
        make \
        build-essential \
        python-openssl

verify_return_code

# Install python 3.10 and necessary tools
echo "Installing Python 3.10 and necessary tools."
sudo apt install -y \
        python3.10 \
        python3.10-dev \
        python3.10-distutils \
        python3.10-venv

verify_return_code

# Fix Windows directory metadata bug
if [ -d "${wsl_mount}" ]; then
  echo "Fixing windows permission issues."
  sudo umount "${wsl_mount}"
  sudo mount -t drvfs C: "${wsl_mount}" -o metadata
else
  echo "System is running native Ubuntu."
fi

# Returning to original directory
echo "Returning to target directory."
cd -

