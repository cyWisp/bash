#!/bin/bash
function installed_software(){
    host_name=$(hostname)

    printf "C010_2_R1:1:2,host_name,display_name,display_version,architecture\n"
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        display_name=$(echo ${app} | awk -F "." '{print $1}' | sed 's/[0-9]//g' | awk -F "-" '{print $NF=""}')
        dv_prefix=$(echo ${app} | awk -F "-" '{print $(NF-1)}')
        dv_suffix=$(echo ${dv_prefix} | awk -F "." '{print $1}')

        architecture=$(echo ${app} | awk -F "." '{print $NF}')
        display_version="${dv_prefix}${dv_suffix}"
    

        #printf "%s\n" $first_field

        printf "C010_2_R1:1:2,%s,%s,%s,%s\n" $host_name $display_name $display_version $architecture 
    done
}

installed_software