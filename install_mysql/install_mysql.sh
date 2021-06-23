#!/bin/bash

admin='ADMINforJUSTICE1220!'
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
	echo ${admin} | sudo -S curl -L ${mysql_download_url} -o ${download_dir}
else
	echo "[!] File ${download_file_name} exists- skipping..."
fi

# Update mysql software repository
echo ${admin} | sudo -S yum install ${download_file_name}




