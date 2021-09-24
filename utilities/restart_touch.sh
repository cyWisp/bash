#!/bin/bash

# This script queries the psmouse (touchpad device)
# on an ubuntu based laptop and restarts the driver

# Gather superuser credentials
# and query the device
read -p "[?] Pass: " -s pass
echo "${pass}" | sudo -S modprobe -r psmouse

# Start the driver
echo "[+] Restarting touchpad..."
sudo modprobe psmouse

# If there's an error, notify
# else present a confirmation message
if [ $? -ne 0 ]; then
	echo "[x] Something went wrong..."
else
	echo "[+] Process completed on $(date)"
fi
