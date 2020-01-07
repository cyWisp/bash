#!/bin/bash

# ===============================================================================
# ===========================| ITNCM Script Ver. 1.1 |===========================
#
#                   Target Platform: Red Hat Enterprise Linux 7
#
# ===============================================================================

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

                printf "hostname,ip_address,mac_address\n"
                printf "HOST:IP:MAC,%s,%s,%s\n" $hostname $ip_address $mac_address
            fi
        done
}

function ports_and_services(){
    host_name=$(hostname)
    netstat_output=$(sudo netstat -antp)

    echo "${netstat_output}" | while read line; do
        protocol_type=$(echo $line | awk '{print $1}')
        port_status=$(echo $line | awk '{print $6}')
        process_name=$(echo $line | awk '{print $7}' | cut -d "/" -f 2)
        if [ "$port_status" = "LISTEN" ]; then
            if [ "$protocol_type" != "tcp" ]; then
                port=$(echo $line | awk '{print $4}' | cut -d ":" -f 4)
                ip_type="IPv6"    
            else
                port=$(echo $line | awk '{print $4}' | cut -d ":" -f 2)
                ip_type="IPv4"
            fi
            printf "C010_2_R1:1:4, hostname,protocol,local_port,process_name\n"
            printf "%s,%s,%s,%s,%s\n" $host_name $protocol_type $port $ip_type $process_name
        fi
    done
}

#===========================| Host Address Information |=========================
#================================================================================

printf "### HOST_ADDRESS_INFO_START ###\n\n"
get_network_info
printf "\n### HOST_ADDRESS_INFO_END ###\n\n"

#==================================| CIP 07__1 |=================================
#================================================================================

printf "### C007_6_R1:1__START ###\n"
printf "### C010_2_R1:1:4__START ###\n"
printf "###__Ports and Services that are enabled or listening on the system ###\n\n"
ports_and_services
printf "\n### C010_2_R1:1:4__END ###\n"
printf "### C007_6_R1:1__END ###\n\n"

#==================================| CIP 07__2 |=================================
#================================================================================

printf "### C007_6_R2:3__START ###\n"
printf "### C010_2_R1:1:5__START ###\n"
printf "###__Any Security Patches applied ###\n\n"

printf "### C010_2_R1:1:5__END ###"
printf "### C010_2_R1:1:5__END ###\n\n"

#==================================| CIP 07__3 |=================================
#================================================================================

#==================================| CIP 07__4 |=================================
#================================================================================

#==================================| CIP 07__5 |=================================
#================================================================================

#==================================| CIP 07__7 |=================================
#================================================================================

#==================================| CIP 07__8 |=================================
#================================================================================

#==================================| CIP 07__9 |=================================
#================================================================================

#==================================| CIP 07__10 |================================
#================================================================================

#==================================| CIP 010__1 |================================
#================================================================================

#==================================| CIP 010__2 |================================
#================================================================================

#==================================| CIP 010__3 |================================
#================================================================================

#==================================| CIP 010__4 |================================
#================================================================================

#==================================| CIP 010__5 |================================
#================================================================================
