#!/bin/bash
function installed_software(){
    hostname=$(hostname)

    printf "C010_2_R1:1:2,host_name,display_name,display_version,architecture\n"
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        
        printf "%s,%s\n" $hostname $app
        # display_name=$(echo ${app} | awk -F "." '{print $1}')
        # dv_prefix=$(echo ${app} | awk -F "-" '{print $(NF-1)}')
        # dv_suffix=$(echo ${dv_prefix} | awk -F "." '{print $1}')

        # architecture=$(echo ${app} | awk -F "." '{print $NF}')
        # display_version="${dv_prefix}${dv_suffix}"

        # display_name=$(echo ${app} | awk -F "-" '{$NF=""; print $0}')

        # printf "%s\n" $display_name

        # printf "C010_2_R1:1:2,%s,%s,%s,%s\n" $host_name $display_name $display_version $architecture 
    done
}

installed_software