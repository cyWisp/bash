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

function generic_accounts(){
    egrep -v "ksh|bash" /etc/passwd | egrep -v ":/home" | awk -F : '{print $1}'
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

function auth_methods(){
    cat /etc/pam.d/system-auth | grep -i 'auth ' | grep -v '#'

    sys_log="/etc/syslog.conf"

    if [ -e "$sys_log" ]; then
        printf "\n###__Check to ensure that logging is enabled and sending data to the correct collectors ###\n\n"
        cat $sys_log | grep -v "^#" | sed '/^\s*$/d' | sort
    else
        :
    fi
}

function check_itncm_version(){
    version="/opt/IBM/tivoli/netcool/ncm/config/rseries_version.txt"

    if [ -e "$version" ]; then
        printf "###___ITNCM Version___###\n\n"
        cat $version
    else
        :
    fi
}

function password_complexity(){
    system_auth_file="/etc/pam.d/system-auth"
    if [ -e "$system_auth_file" ]; then
        cat $system_auth_file | grep -i 'password' | grep -v '#'
    else
        :
    fi
}

function calc_user_age(){
    egrep "ksh|bash" /etc/passwd | egrep ":/home" | awk -F : '{print $1}' | while read user_account; do
        date_set=$(sudo passwd -S ${user_account} | cut -d " " -f 3)
        printf "%s:%s\n" $user_account $date_set; 
    done
}

function read_age_results(){
    cat $user_age_temp | while read user_entry; do

        printf "%s\n" $user_entry
        creation_date=$(echo ${user_entry} | cut -d ":" -f 2)
        current_date=$(date +%Y-%m-%d)
        pw_age=$(echo $(( (`date -d $current_date +%s` - `date -d $creation_date +%s`) / 86400 )))
        pw_age_months=$(expr ${pw_age} / 30)

        printf "Password last set: %s days\n" $pw_age
        printf "Password age: %s months\n\n" $pw_age_months
    
        rm $user_age_temp
    done
}

function account_lockout(){
    system_auth_file_path="/etc/pam.d/system-auth"
    cat $system_auth_file_path | grep -i 'password' | grep -v '#'
}

function os_info(){
    redhat_info="/etc/redhat-release"
    
    if [ -e $redhat_info ]; then
        printf "###__System OS__START ###\n\n"
        cat $redhat_info 
        printf "\n###__System OS__END ###\n\n"     
    else
        :
    fi
    
    printf "###__Firmware or BIOS__START ###\n\n"
    printf "BIOS Version: "
    sudo dmidecode | grep "BIOS Information" -A 5 | grep "Version:" | cut -d : -f 2 | sed 's/-//g'
    printf "\n###__Firmware or BIOS__END ###\n\n" 
    
    printf "###__GPU__START ###\n\n"
    lspci | grep -i vga | cut -d " " -f 5-10
    printf "\n###__GPU__END ###\n\n"
}

function installed_software(){
    rpm -qa | sort |tr [a-z] [A-Z] | while read app; do
        printf "C010_2_R1:1:2,%s\n" $app
    done
}

function db2_application(){

    db2_app="/opt/IBM/db2instance/db2inst1/Db2Level.sh"

    if [ -e "$db2_app" ]; then
        printf "###___DB2_Application__START ###\n\n"
        $db2_app
        printf "\n###___DB2_Application__END ###\n"
    else
        :
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
printf "###__Ports and Services that are listening on the system__###\n\n"
ports_and_services
printf "\n### C010_2_R1:1:4__END ###\n"
printf "### C007_6_R1:1__END ###\n\n"

#==================================| CIP 07__2 |=================================
#================================================================================

printf "### C007_6_R2:3__START ###\n"
printf "### C010_2_R1:1:5__START ###\n"
printf "###__Any Security Patches applied__###\n\n"

uname -a
check_itncm_version

printf "\n### C010_2_R1:1:5__END ###"
printf "### C010_2_R1:1:5__END ###\n\n"

#==================================| CIP 07__3 |=================================
# Not Applicable
#================================================================================

printf "### CIP:007_6_R3:1__START ###\n"
printf "###__Check if device has AV installed__###\n"
printf "###__________Not Capable__________###\n"
printf "### CIP:007_6_R3:1__END ###\n\n"

#==================================| CIP 07__4 |=================================
#================================================================================

printf "### CIP:007_6_R5:1__START ###\n"
printf "###__Check to ensure that authentication methods are enabled and pointing to appropriate server__###\n\n"

auth_methods

printf "\n### CIP:007_6_R5:1__END ###\n\n"

#==================================| CIP 07__5 |=================================
#================================================================================

#==================================| CIP 07__6 |=================================
#================================================================================

printf "### CIP:007_6_R5:2__START ###\n"
printf "###__Detect any default or generic account and report it__###\n\n"

generic_accounts

printf "### CIP:007_6_R5:2__END ###\n\n"

#================================================================================

printf "### CIP:007_6_R5:4__START ###\n"
printf "###__Check for any default passwords__###\n\n"

userinfo="/tmp/userinfo"
get_info > $userinfo
verify

printf "\n### CIP:007_6_R5:4__END ###\n\n"

#================================================================================

printf "### CIP:007_6_R5:5:1__START ###\n"
printf "###__Check Password complexity (8 characters or more)__###\n"
printf "### CIP:007_6_R5:5:2__START ###\n"
printf "###__Check for password policy enforcement__###\n\n"

password_complexity

printf "\n### CIP:007_6_R5:5:2__END ###\n"
printf "### CIP:007_6_R5:5:1__END ###\n\n"

#================================================================================

printf "### CIP:007_6_R5:6__START ###\n"
printf "###__Check for user account password not changed within 15 calendar months ###\n\n"

user_age_temp="/tmp/userage"
calc_user_age > $user_age_temp
read_age_results

printf '### CIP:007_6_R5:6__END ###\n\n'

#================================================================================

printf "### CIP:007_6_R5:7__START ###\n"
printf "###__Check for Account lockout enabled for a specified threshold ###\n\n"

account_lockout

printf "\n### CIP:007_6_R5:7__END ###\n\n"

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

printf "### CIP:010_2_R1:1:1__START ###\n"
printf "###__Operating system or firmware including version ###\n\n"

os_info

printf "\n### CIP:010_2_R1:1:1__END ###\n\n"

#================================================================================

printf "### CIP:010_2_R1:1:2__START ###\n"
printf "###__Any commercially available or open_source application software installed including version ###\n\n"

installed_software
db2_application

printf "### CIP:010_2_R1:1:2__END ###\n\n"


#==================================| CIP 010__3 |================================
#================================================================================

printf "### CIP:010_2_R1:1:3__START ###\n"
printf "###__Any custom software installed ###\n"
printf "###__________Not Capable__________###\n"
printf "### CIP:010_2_R1:1:3__END ###\n\n"

#==================================| CIP 010__4 |================================
#================================================================================

printf "### CIP:010_2_R1:1:4__START ###\n"
printf "###__Any logical network accessible ports ###\n"
printf "###__________SEE CIP:007_6_R1:1__________###\n"
printf "### CIP:010_2_R1:1:4__END ###\n\n"

#==================================| CIP 010__5 |================================
#================================================================================

printf "### CIP:010_2_R1:1:5__START ###\n"
printf "###__Any security patches installed ###\n"
printf "###__________SEE CIP:007_6_R2:3__________###\n"
printf "### CIP:010_5_R1:1:5__END ###\n\n"

#================================================================================

printf "*** END_OF_SCRIPT ***\n"