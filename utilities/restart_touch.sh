#!/bin/bash

read -p "[?] Pass: " -s pass


echo "${pass}" | sudo -S modprobe -r psmouse

echo "[+] Restarting touchpad..."
sudo modprobe psmouse

if [ $? -ne 0 ]; then
	echo "[x] Something went wrong..."
else
	echo "[+] Process completed on $(date)"
fi
