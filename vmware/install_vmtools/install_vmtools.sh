#!/usr/bin/bash

vm_tools="/dev/cdrom"
mount_dir="/mnt/cdrom"
temp_dir="/tmp/vmware_tools"
admin="ADMINforJUSTICE1220!"

# Install dependecies
echo ${admin} | sudo -S yum install perl kernel-devel kernel-headers gcc -y

# Create mount dir and mount cdrom
sudo -S mkdir ${mount_dir}
sudo mount ${vm_tools} ${mount_dir}

# Create temp dir and copy install files
sudo mkdir ${temp_dir}
sudo cp /mnt/cdrom/VMwareTools-10.3.22-15902021.tar.gz ${temp_dir}

# Untar install files
sudo tar -xzf "${temp_dir}/VMwareTools-10.3.22-15902021.tar.gz" -C ${temp_dir}

# Create answer file
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
sudo /tmp/vmware_tools/vmware-tools-distrib/vmware-install.pl < /tmp/answer

# Clean up
sudo umount ${mount_dir}
sudo rm -rf ${mount_dir} ${temp_dir} /tmp/answer
