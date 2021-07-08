#!/bin/bash

# This script will install Python 3.8 on CentOS 7

admin=""

# Install centos-release-scl
echo ${admin} | sudo -S yum install -y centos-release-scl

# Install python
sudo yum install -y rh-python38

# Install development tools
sudo yum groupinstall 'Development Tools'
