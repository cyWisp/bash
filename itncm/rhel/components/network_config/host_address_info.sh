#!/bin/bash
# function get_network_info(){ #Using nmcli
#         printf "hostname,ip_address,mac_address\n"
#         adapters=$(nmcli device status | sed -n '1!p' | awk '{print $1}')
        
#         for a in $adapters; do
#             if [ "$a" = "lo" ] || [ "$a" = "p2p-dev-wlp2s0" ]; then
#                     continue
#             else
#                 hostname=$(hostname)
#                 ip_address=$(ip addr | grep ${a} | grep inet | cut -d "/" -f 1 | awk '{print $2}')
#                 mac_address=$(ip addr | grep ${a} -A1 | grep ether | awk '{print $2}')

#                 printf "HOST:IP:MAC,%s,%s,%s\n" $hostname $ip_address $mac_address
#             fi
#         done
# }

function get_network_info(){ # Using netstat
    #printf "hostname,ip_address,mac_address\n"
    #ns_enum=$(netstat -i | column -t | awk '/Iface/{getline; print}' | awk '{print $1}')
    
    #adapters=()
    #counter=0
    ns_enum=$(netstat -i | column -t)
    
    echo "${ns_enum}" | while read output_line; do
        interface=$(echo "${output_line}" | awk '{print $1}')
        if [ "$interface" = "Kernel" ] || [ "$interface" = "Iface" ] || [ "$interface" = "lo" ]; then
            continue
        else
            echo "${interface}"
        fi
        
    done
     
    #echo "${adapters[@]}"
}
 
    # for a in $adapters; do
    #     if [ "$a" = "lo" ] || [ "$a" = "p2p-dev-wlp2s0" ]; then
    #         continue
    #     else
    #         hostname=$(hostname)
    #         ip_address=$(ip addr | grep ${a} | grep inet | cut -d "/" -f 1 | awk '{print $2}')
    #         mac_address=$(ip addr | grep ${a} -A1 | grep ether | awk '{print $2}')

    #         printf "HOST:IP:MAC,%s,%s,%s\n" $hostname $ip_address $mac_address
    #     fi
    # done
#}



get_network_info
#enumerate_adatpers