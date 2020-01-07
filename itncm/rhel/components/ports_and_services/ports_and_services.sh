#!/bin/bash
function ports_and_services(){
    host_name=$(hostname)
    netstat_output=$(sudo netstat -antp)

    printf "C010_2_R1:1:4, hostname,protocol,local_port,process_name\n"
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
            printf "%s,%s,%s,%s,%s\n" $host_name $protocol_type $port $ip_type $process_name
        fi
    done
}

ports_and_services

