#!/bin/bash

printf "[*] Adding vmware service to systemd..."

cat <<EOF | sudo tee /etc/systemd/system/vmware.service
[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware start
ExecStop=/etc/init.d/vmware stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

printf "[*] Adding vmware arbitrator service to systemd"

cat <<EOF | sudo tee /etc/systemd/system/vmware-usbarbitrator.service
[Unit]
Description=VMware USB Arbitrator
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/usr/bin/vmware-usbarbitrator
ExecStop=/usr/bin/vmware-usbarbitrator --kill
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

printf "[*] Adding vmware workstation server service to systemd"

cat <<EOF | sudo tee /etc/systemd/system/vmware-workstation-server.service
[Unit]
Description=VMware Workstation Server
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/etc/init.d/vmware-workstation-server start
ExecStop=/etc/init.d/vmware-workstation-server stop
PIDFile=/var/lock/subsys/vmware-workstation-server
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

printf "[*] Restarting vmware daemon..."
sudo systemctl daemon-reload

printf "[*] Starting vmware and vmware arbitrator service..."
sudo systemctl start vmware.service vmware-usbarbitrator.service 

#printf "[*] Starting vmware service..."
#sudo systemctl start vmware

printf "[*] Enabling vmware service..."
sudo systemctl enable vmware.service

printf "[*] Recompiling VMware kernel modules..."
sudo  vmware-modconfig --console --install-all
