#!/bin/bash

function installed_software(){
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        first_field=$(echo ${app} | awk -F "." '{print $1}')
        #display_name=${first_field::-2}
        
        printf "C010_2_R1:1:2,%s\n" $first_field
    done
}

installed_software