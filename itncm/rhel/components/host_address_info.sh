#!/bin/bash
function get_network_info(){
        get_ip=$(ifconfig | grep wlp2s0 -A1 | grep inet | awk '{print $2}')
        host_name=$(hostname)
        get_mac=$(ifconfig | grep wlp2s0 -A3 | grep ether | awk '{print $2}')

        printf "hostname,ip_address,mac_address\n"
        printf "HOST:IP:MAC,%s,%s,%s\n" $host_name $get_ip $get_mac
}
get_network_info