#!/bin/bash

primary_adapter=$(ifconfig | grep "wlp2s0" -A1 | tail -n 1 | awk '{print $2}')
all_devices=$(nmcli device status | awk '{print $1}')


