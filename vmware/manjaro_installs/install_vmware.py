#!/usr/bin/env python
from os import system
if __name__ == '__main__':

    commands = [
        'sudo mkdir /etc/init.d',
        'sudo pacman -S fuse2 gtkmm linux-headers pcsclite libcanberra',
        'yay -S --noconfirm --needed ncurses5-compat-libs',
        'chmod 755 "/installer/VMware-Workstation-Full-15.5.1-15018445.x86_64.bundle"',
        'sudo /installer/VMware-Workstation-Full-15.5.1-15018445.x86_64.bundle',
    ]

    print("[*] Creating installation folder...")
    system(commands[0])

    print("[*] Installing dependencies...")
    system(commands[1])
    system(commands[2])

    print("[*] Writing permissions...")
    system(commands[3])

    print("[*] Installing...")
    system(commands[3])

    print("\n\n[*] Done!\n[!] Please run configure_services.sh to finish installation...")
