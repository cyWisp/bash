#!/bin/bash

function get_network_info(){
        adapters=$(nmcli device status | sed -n '1!p' | awk '{print $1}')
        printf "hostname,ip_address,mac_address\n"

        for a in $adapters; do
            if [ "$a" = "lo" ] || [ "$a" = "p2p-dev-wlp2s0" ]; then
                    continue
            else
                hostname=$(hostname)
                ip_address=$(ifconfig | grep ${a} -A1 | grep inet | awk '{print $2}')
                mac_address=$(ifconfig | grep ${a} -A3 | grep ether | awk '{print $2}')

                printf "HOST:IP:MAC,%s,%s,%s\n" $hostname $ip_address $mac_address
            fi
        done
}

get_network_info