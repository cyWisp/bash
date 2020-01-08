#!/bin/bash

function installed_software(){
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        display_name=$(echo ${app} | awk -F "." '{print $1}')
        
        printf "C010_2_R1:1:2,%s\n" $display_name
    done
}

installed_software