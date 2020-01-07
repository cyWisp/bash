#!/bin/bash

# ===============================================================================
# ===========================| ITNCM Script Ver. 1.1 |===========================
#
#                   Target Platform: Red Hat Enterprise Linux 7
#
# ===============================================================================

function get_network_info(){
        printf "hostname,ip_address,mac_address\n"
        adapters=$(nmcli device status | sed -n '1!p' | awk '{print $1}')
        
        for a in $adapters; do
            if [ "$a" = "lo" ] || [ "$a" = "p2p-dev-wlp2s0" ]; then
                    continue
            else
                hostname=$(hostname)
                ip_address=$(ip addr | grep ${a} | grep inet | cut -d "/" -f 1 | awk '{print $2}')
                mac_address=$(ip addr | grep ${a} -A1 | grep ether | awk '{print $2}')

                printf "HOST:IP:MAC,%s,%s,%s\n" $hostname $ip_address $mac_address
            fi
        done
}

function ports_and_services(){
    host_name=$(hostname)
    netstat_output=$(sudo netstat -antp)

    printf "C010_2_R1:1:4, hostname,protocol,local_port,process_name\n"
    echo "${netstat_output}" | while read line; do
        protocol_type=$(echo $line | awk '{print $1}')
        port_status=$(echo $line | awk '{print $6}')
        process_name=$(echo $line | awk '{print $7}' | cut -d "/" -f 2)
        if [ "$port_status" = "LISTEN" ]; then
            if [ "$protocol_type" != "tcp" ]; then
                port=$(echo $line | awk '{print $4}' | cut -d ":" -f 4)
                ip_type="IPv6"    
            else
                port=$(echo $line | awk '{print $4}' | cut -d ":" -f 2)
                ip_type="IPv4"
            fi
            printf "%s,%s,%s,%s,%s\n" $host_name $protocol_type $port $ip_type $process_name
        fi
    done
}

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
        printf "###___No Users Found___###\n"
        rm $userinfo
    fi
}

#===========================| Host Address Information |=========================
#================================================================================

printf "### HOST_ADDRESS_INFO_START ###\n\n"
get_network_info
printf "\n### HOST_ADDRESS_INFO_END ###\n\n"

#==================================| CIP 07__1 |=================================
#================================================================================

printf "### C007_6_R1:1__START ###\n"
printf "### C010_2_R1:1:4__START ###\n"
printf "###__Ports and Services that are listening on the system ###\n\n"
ports_and_services
printf "\n### C010_2_R1:1:4__END ###\n"
printf "### C007_6_R1:1__END ###\n\n"

#==================================| CIP 07__2 |=================================
#================================================================================

printf "### C007_6_R2:3__START ###\n"
printf "### C010_2_R1:1:5__START ###\n"
printf "###__Any Security Patches applied ###\n\n"

uname -a

#printf "###___ITNCM Version___###\n\n"
#cat /opt/IBM/tivoli/netcool/ncm/config/rseries_version.txt

printf "\n### C010_2_R1:1:5__END ###"
printf "### C010_2_R1:1:5__END ###\n\n"

#==================================| CIP 07__3 |=================================
# Not Applicable
#================================================================================

printf "### CIP:007_6_R3:1__START ###\n"
printf "###__Check if device has AV installed ###\n"
printf "###__________Not Capable__________###\n"
printf "### CIP:007_6_R3:1__END ###\n\n"

#==================================| CIP 07__4 |=================================
#================================================================================

printf "### CIP:007_6_R5:1__START ###\n"
printf "###__Check to ensure that authentication methods are enabled and pointing to appropriate server ###\n\n"
cat /etc/pam.d/system-auth | grep -i 'auth ' | grep -v '#'

printf "\n"
printf "###__Check to ensure that logging is enabled and sending data to the correct collectors ###\n\n"
cat /etc/syslog.conf|grep -v "^#"|sed '/^\s*$/d'|sort
printf "\n"

printf "### CIP:007_6_R5:1__END ###\n\n"

#==================================| CIP 07__5 |=================================
#================================================================================

#==================================| CIP 07__6 |=================================
#================================================================================

printf "### CIP:007_6_R5:2__START ###\n"
printf "###__Detect any default or generic account and report it ###\n\n"

egrep -v "ksh|bash" /etc/passwd | egrep -v ":/home" | awk -F : '{print $1}'
printf "\n"

printf '###___ITNCM USERS ACCESS___###\n\n'
/home/icosuser/ItncmUsers.sh
printf "\n"

printf "### CIP:007_6_R5:2__END ###\n\n"

#================================================================================

printf "### CIP:007_6_R5:4__START ###\n"
printf "###__Check for any default passwords ###\n\n"

userinfo="/tmp/userinfo"
get_info > $userinfo
verify

printf "\n### CIP:007_6_R5:4__END ###\n\n"

#==================================| CIP 07__7 |=================================
#================================================================================

#==================================| CIP 07__8 |=================================
#================================================================================

#==================================| CIP 07__9 |=================================
#================================================================================

#==================================| CIP 07__10 |================================
#================================================================================

#==================================| CIP 010__1 |================================
#================================================================================

#==================================| CIP 010__2 |================================
#================================================================================

#==================================| CIP 010__3 |================================
#================================================================================

#==================================| CIP 010__4 |================================
#================================================================================

#==================================| CIP 010__5 |================================
#================================================================================

