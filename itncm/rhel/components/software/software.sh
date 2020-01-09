#!/bin/bash

function installed_software(){
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        # first_field=$(echo ${app} | awk -F "." '{print $1}')
        # display_name=$(echo ${first_field//-})
        # architecture=$(echo ${app} | awk -F "." '{print $NF}')

        printf "C010_2_R1:1:2,%s\n" $app
        #printf "C010_2_R1:1:2,%s,%s\n" $display_name $architecture
    done
}

installed_software