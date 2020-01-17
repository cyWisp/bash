#!/bin/bash
function installed_software(){
    hostname=$(hostname)

    printf "C010_2_R1:1:2,host_name,display_name-display_version,architecture\n"
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        
        #architecture=$(echo ${app} | awk -F "." '{print $NF}')
        display_name_version=$(echo ${app} | awk -F "." '{$NF=""}; {print $0}')
        
        printf "%s" $display_name_version

        # printf "%s,%s\n" $hostname $app
        # printf "C010_2_R1:1:2,%s,%s,%s,%s\n" $host_name $display_name $display_version $architecture 
    done
}

installed_software