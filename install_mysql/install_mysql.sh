#!/bin/bash

admin=''
mysql_temp_dir='/tmp/mysql_install'
mysql_download_url='https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm'
mysql_release='mysql80-community-release-el7-3.noarch.rpm'
download_file_name="${mysql_temp_dir}/${mysql_release}"

# Create temporary directory for installation files
if [ ! -d ${mysql_temp_dir} ]
then
	echo "[*] Creating ${mysql_temp_dir}"
	echo ${admin} | sudo -S  mkdir ${mysql_temp_dir}
else
	echo "[!] Directory ${mysql_temp_dir} already exists- skipping..."
fi

# Download mysql with curl
if [ ! -f ${download_file_name} ]
then
	echo "[*] Downloading mysql..."
	echo ${admin} | sudo -S curl -L ${mysql_download_url} -o ${download_file_name}
else
	echo "[!] File ${download_file_name} exists- skipping..."
fi

# Update mysql software repository
echo "[!] Updating mysql repositories..."
echo "[!] Navigating to ${mysql_temp_dir}"
cd ${mysql_temp_dir}
echo ${admin} | sudo -S yum -y install ${mysql_release}

# Install mysql-server
echo "[!] Installing mysql..."
sudo yum install -y mysql-server

# Start mysqld
echo "[!] Starting mysqld service"
echo ${admin} | sudo -S systemctl start mysqld

# Grab temporary password and save it to /home/$(whoami)/mysql_temp_pw
temp_pw=$(sudo grep 'temporary password' /var/log/mysqld.log) 
temp_pw_target="/home/$(whoami)/mysql_temp_pw"

echo "[!] Storing temporary password in ${temp_pw_target}"
echo ${temp_pw} > ${temp_pw_target}

# Clean up and exit
cd
echo "[!] Cleaning up..."
sudo rm -rf ${mysql_temp_dir}

# Post Installation Message
echo '[!] Please run "sudo mysql_secure_installation" to secure your mysql install...'
echo "[*] Installation successful!"
