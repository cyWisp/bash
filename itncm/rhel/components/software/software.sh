#!/bin/bash

function installed_software(){
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        printf "C010_2_R1:1:2,%s\n" $app
    done
}

installed_software