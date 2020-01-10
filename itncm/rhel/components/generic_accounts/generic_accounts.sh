#!/bin/bash
function generic_accounts(){
    # egrep -v "ksh|bash" /etc/passwd | egrep -v ":/home" | awk -F : '{print $1}'
    # printf "\n"

    printf "C007_6_R5:7,account\n"

    service_accounts=$(egrep -v "ksh|bash" /etc/passwd | egrep -v ":/home" | awk -F : '{print $1}')
    echo "${service_accounts}" | while read account; do
        printf "C007_6_R5:7,%s\n"
    done



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