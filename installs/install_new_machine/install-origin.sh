#!/usr/bin/env bash


function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1"
}

function check_root () {
	if [ "$EUID" -ne 0 ]; then
		echo "[x] This script must run as root."
		echo "[!] Assure updates have been applied before running this script."
  		exit
	fi
}

function check_error () {
  if [ $1 -ne 0 ]; then
    log "[x] Previous operation returned a non-zero status - exiting..."
    log "[x] Failed at ${2}."
    exit 1
  else
    log "[*] Success!"
  fi
}

function configure_ssh () {
  local function_name="configure_ssh"
  local ssh_backup_dir="/etc/ssh/backup"
  local ssh_conf_old="/etc/ssh/ssh_host_*"

  # Create a backup directory.
  log "[!] Reconfiguring SSH service."
  mkdir ssh_backup_dir
  check_error $? $function_name

  # Move old ssh configuration to newly created backup dir.
  mv ssh_conf_old ssh_backup_dir
  check_error $? $function_name

  # Reconfigure openssh server.
  dpkg-reconfigure openssh-server
  check_error $? $function_name
}

function install_base_applications () {
  local function_name="install_base_applications"

  log "[!] Installing base operations software."

  apt install git vim tmux net-tools dnsutils
  check_error $? $function_name
}

check_root
configure_ssh
install_base_applications


