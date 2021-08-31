#!/bin/bash

hostname=$(hostname)
netstat_output=$(sudo netstat -antp | grep "LISTEN")

function ports_and_services(){
    echo "${netstat_output}" | while read line; do
        protocol_type=$(echo $line | awk '{print $1}')
        port_status=$(echo $line | awk '{print $6}')
        pid_num=$(echo ${line} | awk '{print $7}' | awk -F "/" '{print $1}')
        process_name=$(ps aux | grep "${pid_num}" -m 1 | awk '{print $11}')
        if [ "$protocol_type" != "tcp" ]; then
            port=$(echo $line | awk '{print $4}' | cut -d ":" -f 4)
            ip_type="IPv6"    
        else
            port=$(echo $line | awk '{print $4}' | cut -d ":" -f 2)
            ip_type="IPv4"
        fi

        if [ "$process_name" = "-" ]; then
            $process_name="n/a"
        else
            :
        fi
                
        printf "%s,%s,%s,%s,%s\n" $hostname $protocol_type $port $ip_type $process_name
    done
}

ports_and_services