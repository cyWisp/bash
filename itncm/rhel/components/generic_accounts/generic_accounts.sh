#!/bin/bash
function generic_accounts(){
    
    printf "C007_6_R5:7,account\n"
    egrep -v "ksh|bash" /etc/passwd | egrep -v ":/home" | awk -F : '{print $1}' | while read account;do
    printf "C007_6_R5:7,%s\n" $account 
    printf "\n"

    



    itncm_users="/home/icosuser/ItncmUsers.sh"
    if [ -e "$itncm_users" ]; then
        printf '###___ITNCM USERS ACCESS___###\n\n'
        /home/icosuser/ItncmUsers.sh
        printf "\n"
    else
        :
    fi
}

generic_accounts