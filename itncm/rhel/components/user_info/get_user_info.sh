#!/bin/bash

userinfo=/tmp/userinfo

function get_info(){
    egrep -v  "ksh|bash" /etc/passwd | egrep ":/home" | awk -F ":" '{print $1}' | while read user_id; do
        printf "%s\n" $user_id
        passwd -S $ID | cut -d " " -f 3,8-12
    done
}

function verify(){
    if [ -s "$userinfo" ]; then
        cat $userinfo | column -t
        rm $userinfo
    else
        echo "###___No Users Found___###\n\n"
        rm $userinfo
    fi
}

get_info > $userinfo
verify

