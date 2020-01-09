#!/bin/bash

function installed_software(){
    host_name=$(hostname)

    printf "C010_2_R1:1:2,host_name,display_name,display_version,architecture"
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        first_field=$(echo ${app} | awk -F "." '{print $1}')
        display_name=$(echo ${first_field//-})
        architecture=$(echo ${app} | awk -F "." '{print $NF}')
        display_version=$(echo ${app} | awk -F "." '{print $NF=""; print $0}')

        printf "C010_2_R1:1:2,%s,%s,%s,%s\n" $host_name $display_name $display_version $architecture
        #printf "C010_2_R1:1:2,%s,%s\n" $display_name $architecture
    done
}

installed_software