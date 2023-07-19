#!/usr/bin/bash

vm_tools="/dev/cdrom"
mount_dir="/mnt/cdrom"
temp_dir="/tmp/vmware_tools"
vmware_tools_package="VMwareTools-10.3.25-20206839.tar.gz"

function log () {
        echo "$(date '+%d-%m-%Y %H:%M:%S'): ${1}"
}

function verify_root () {
    if [ "$EUID" -ne 0 ]; then
        log "This script must run with root privileges - exiting."
        exit
    fi
}

function check_return_code () {
            # $1: return code
            # $2: success message
            # $3: failed message
            # $4: optional command to execute

            if [ $1 -ne 0 ]; then
                log "${3}"

                if ! [ -z "${4}" ]; then
                    eval "${4}"
                else
                    return 1
                fi

            else
                log "${2}"
            fi
}


# Install dependecies
log "Installing dependencies."
yum install perl kernel-devel kernel-headers gcc -y

check_return_code $? "Successful." "Failed."

# Create mount dir and mount cdrom
log "Creating and mounting vmtools package."
mkdir ${mount_dir}
mount ${vm_tools} ${mount_dir}

check_return_code $? "Successful." "Failed."

# Create temp dir and copy install files
log "Copying necessary files."
mkdir ${temp_dir}
cp "${mount_dir}/${vmware_tools_package}" ${temp_dir}

check_return_code $? "Successful." "Failed."

# Untar install files
log "Extracting package files."
tar -xzf "${temp_dir}/${vmware_tools_package}" -C ${temp_dir}

check_return_code $? "Successful." "Failed."

# Create answer file
log "Creating answer file for unattended install."
cat > /tmp/answer << __ANSWER__
yes
/usr/bin
/etc/rc.d
/etc/rc.d/init.d
/usr/sbin
/usr/lib/vmware-tools
yes
/usr/lib
/var/lib
/usr/share/doc/vmware-tools
yes
yes
yes
__ANSWER__

# Install VMware Tools redirecting silent install
log "Installing VMWare Tools."
/tmp/vmware_tools/vmware-tools-distrib/vmware-install.pl < /tmp/answer

check_return_code $? "Successful." "Failed."

# Clean up
log "Cleaning up."
umount ${mount_dir}
rm -rf ${mount_dir} ${temp_dir} /tmp/answer

check_return_code $? "Successful." "Failed."
