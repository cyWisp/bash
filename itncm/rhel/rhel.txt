#!/bin/bash
################################################################################
##set -vx                                 ## Used to enable debugging
##exec 1> /tmp/rhel5ITNCMscript.trace   ## Writes "Standard out" to file.
##exec 2>&1                               ## Writes "Standard error" to a file.
################################################################################

# IP and MAC address
# 9/21/18 | refined host ip mac
# 10/24/18 | further refined host ip mac
################################################################################
echo ''
echo ''
echo '### HOST_ADDRESS_INFO_START ###' > /tmp/h.txt
ip route | grep default | awk -F " " '{print $5}' | while read ID
do
A=$(hostname)
B=$(ip addr show $ID | awk '/inet / {print $2}')
C=$(ip addr show $ID | awk ' /ether/ {print $2}')
#echo Hostname "          " IP Address/Mask "  "  MAC Address
#echo $A "  " $B "  " $C "  "
echo '' >> /tmp/h.txt
printf "%-30.30s, %-20.20s, %-20.20s\n" "Hostname" "IpAddress" "MacAddress" >> /tmp/h.txt
printf "%-30.30s, %-20.20s, %-20.20s\n" "$A" "$B" "$C" >> /tmp/h.txt
done
echo '' >> /tmp/h.txt
echo '### HOST_ADDRESS_INFO_END ###' >> /tmp/h.txt
cat /tmp/h.txt
echo ''
echo ''
################################################################################

################################################################################
echo ' START_OF_SCRIPT '
echo ''
echo ''
################################################################################


echo '### CIP:007_6_R1:1__START ###'
echo '### CIP:010_2_R1:1:4__START ###'
echo '###__Ports and Services that are enabled or listening on the system ###'
DATE=`(date +"%m%d%y.%H%M")`
SUMMARY="/tmp/NstatSummary.txt"
STAGE="/tmp/NstatSumSTAGE_$DATE.txt"
> $SUMMARY
> $STAGE
LINE="================================================================================================================="
#================================================================================================================="
##----- 1         3         4       5       7       8       9
printf "%-20.20s, %-10.10s, %-5.5s, %-5.5s, %-9.9s, %-4.4s, %-30.30s\n" COMMAND         USER   FD   TYPE   SIZE_OFF NODE NAME >> $SUMMARY
lsof -nPi |egrep -i "LISTEN|UDP|NAME" |sort -k8,8 -k9rn,9 |egrep -v "NAME|127.0.0.1|::1" |sed s/\*/\\*/g > $STAGE
for INST in `cat $STAGE |grep -n "" |cut -d":" -f1`
do
v1=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $1}'`
#v2=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $2}'`
v3=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $3}'`
v4=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $4}'`
v5=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $5}'`
#v6=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $6}'`
v7=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $7}'`
v8=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $8}'`
v9=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $9,$10}'`
#================================================================================================================="
##----  1         3         4       5       7       8       9
printf "%-20.20s, %-10.10s, %-5.5s, %-5.5s, %-9.9s, %-4.4s, %-30.30s\n" "$v1" "$v3" "$v4" "$v5" "$v7" "$v8" "$v9" >> $SUMMARY
done
cat $SUMMARY
echo '### CIP:010_2_R1:1:4__END ###'
echo '### CIP:007_6_R1:1__END ###'
echo ''
echo ''


# CIP 07__2
#need app specific command
# 8/06/18 | added headers
# 8/14/18 | added app specific commands
################################################################################
echo '### CIP:007_6_R2:3__START ###'
echo '### CIP:010_2_R1:1:5__START ###'
echo '###__Any Security Patches applied ###'
echo '###___System___###'
uname -a
# APP SPECIFIC
########################################
echo ''
echo '###___ITNCM Version___###'
cat /opt/IBM/tivoli/netcool/ncm/config/rseries_version.txt
echo ''
echo '### CIP:010_5_R1:1:5__END ###'
echo '### CIP:007_6_R2:3__END ###'
echo ''
echo ''


# CIP 07__3
# Not Applicable
################################################################################
echo '### CIP:007_6_R3:1__START ###'
echo '###__Check if device has AV installed ###'
echo '###__________Not Capable__________###'
echo '### CIP:007_6_R3:1__END ###'
echo ''
echo ''


# CIP 07__4
# how is access authenticated, how to enforce authentication, show authentication methods
# 8/06/18 | new command added
################################################################################
#cat /etc/pam.d/system-auth | grep -i pam_passwdqc.so
echo '### CIP:007_6_R5:1__START ###'
echo '###__Check to ensure that authentication methods are enabled and pointing to appropriate server ###'
cat /etc/pam.d/system-auth | grep -i 'auth ' | grep -v '#'
echo ''
echo '###__Check to ensure that logging is enabled and sending data to the correct collectors ###'
cat /etc/syslog.conf|grep -v "^#"|sed '/^\s*$/d'|sort
echo ''
echo '### CIP:007_6_R5:1__END ###'
echo ''
echo ''


# CIP-07__7
# existing command not reporting all generic accounts
# 7/19/18 | added new command
# 7/23/18 | further refined command
# 8/16/18 | added ITNCM users
################################################################################
##cat /etc/passwd | grep -v nologin
##awk -F : '{printf "%s %s\n", $1, $5}' /etc/passwd
##awk -F':' '{ print $1}' /etc/passwd
##grep -v nologin /etc/passwd | awk -F : '{print $1}'
##egrep -v "ksh|bash" /etc/passwd | awk -F : '{print $1}'
echo '### CIP:007_6_R5:2__START ###'
echo '###__Detect any default or generic account and report it ###'
egrep -v "ksh|bash" /etc/passwd | egrep -v ":/home" | awk -F : '{print $1}'
echo ''
echo '###___ITNCM USERS ACCESS___###'
/home/icosuser/ItncmUsers.sh
##su - icosuser
##db2 connect to ITNCM
##db2 "select userid, GIVENNAME, LASTNAME from icosuser.users where TYPE <> 'inactive' order by userid"
##exit
echo ''
echo '### CIP:007_6_R5:2__END ###'
echo ''
echo ''


# CIP-07__8
#change known default passwords, procedure that password is changed when new devices are added
# 8/08/18 | added new command
# 8/13/18 | added no users found
################################################################################
#awk -F : '{print $1}' /etc/passwd | while read ID
echo '### CIP:007_6_R5:4__START ###'
echo '###__Check for any default passwords ###'
userinfo=/tmp/userinfo
getinfo(){
egrep -v  "ksh|bash" /etc/passwd | egrep ":/home" | awk -F : '{print $1}' | while read ID
do
printf "${ID} "; passwd -S $ID | cut -d " " -f 3,8-12
done
}
getinfo > $userinfo
if [[ -s $userinfo ]]
then
cat $userinfo | column -t
else
echo "###___No Users Found___###"
fi
echo '### CIP:007_6_R5:4__END ###'
echo ''
echo ''


# CIP-07__9
# 2 Part
# 8/06/18 | added new command
################################################################################
#cat /etc/pam.d/system-auth | grep pam_passwdqc.so
echo '### CIP:007_6_R5:5:1__START ###'
echo '###__Check Password complexity to meet 8 characters in length ###'
echo '### CIP:007_6_R5:5:2__START ###'
echo '###__Check password that upper case lowercase numeric and non numeric characters are enforced ###'
cat /etc/pam.d/system-auth | grep -i 'password' | grep -v '#'
echo '### CIP:007_6_R5:5:2__END ###'
echo '### CIP:007_6_R5:5:1__END ###'
echo ''
echo ''


# CIP-07__10
# 6/27/18 | added 'smart script'
# 7/17/18 | changed 15 to 13 months
# 7/19/18 | removed 'non-interactive' users
# 7/23/18 | further refined command
# 8/06/18 | added command to print if no users
################################################################################
#awk -F : '{print $1}' /etc/passwd | while read ID
#egrep -i "ksh|bash" /etc/passwd | awk -F : '{print $1}' | while read ID
echo '### CIP:007_6_R5:6__START ###'
echo '###__Check for user account password not changed within 15 calendar months ###'
calcuage(){
egrep "ksh|bash" /etc/passwd | egrep ":/home" | awk -F : '{print $1}' | while read ID
do
printf "${ID}:"; passwd -S $ID | cut -d " " -f 3
done
}
calcuage > /tmp/userage
for userage in $(cat /tmp/userage)
do
A=$(echo $userage | cut -d : -f 2)
B=$(date +%Y-%m-%d)
C=$(echo $(( (`date -d $B +%s` - `date -d $A +%s`) / 86400 )))
D=395
if [ $C -gt $D ]
then
echo $(echo $userage | cut -d : -f 1)
#else
#echo '###__________No Users Found__________###'
fi
done
echo '### CIP:007_6_R5:6__END ###'
echo ''
echo ''



echo '### CIP:007_6_R5:7__START ###'
echo '###__Check for Account lockout enabled for a specified threshold ###'
cat /etc/pam.d/system-auth | grep -i 'password' | grep -v '#'
echo '### CIP:007_6_R5:7__END ###'
echo ''
echo ''



# CIP 10__1
# 12/11/18 | Added fw command
# 12/11/18 | Added gpu command
################################################################################
echo '### CIP:010_2_R1:1:1__START ###'
echo '###__Operating system or firmware including version ###'
echo '###__System OS__START ###'
cat /etc/redhat-release
echo '###__System OS__END ###'
echo '###__Firmware or BIOS__START ###'
dmidecode | grep 'BIOS Information' -A 5 | grep Version: | cut -d : -f 2 | sed 's/-//g'
echo '###__Firmware or BIOS__END ###'
echo '###__GPU__START ###'
lspci | grep -i vga | cut -d " " -f 5-10
echo '###__GPU__END ###'
echo '### CIP:010_2_R1:1:1__END ###'
echo ''
echo ''


# CIP 10__2
################################################################################
echo '### CIP:010_2_R1:1:2__START ###'
echo '###__Any commercially available or open_source application software installed including version ###'
rpm -qa | sort |tr [a-z] [A-Z]
echo ''
echo ''
echo '###___DB2_Application__START ###'
echo ''
/opt/IBM/db2instance/db2inst1/Db2Level.sh
echo '###___DB2_Application__END ###'
echo ''
echo '### CIP:010_2_R1:1:2__END ###'
echo ''
echo ''


# CIP 10__3
#not applicable
################################################################################
echo '### CIP:010_2_R1:1:3__START ###'
echo '###__Any custom software installed ###'
echo '###__________Not Capable__________###'
echo '### CIP:010_2_R1:1:3__END ###'
echo ''
echo ''


# CIP 10__4
# 8/02/18 | pointed to CIP:007_6_R1:1
################################################################################
echo '### CIP:010_2_R1:1:4__START ###'
echo '###__Any logical network accessible ports ###'
echo '###__________SEE CIP:007_6_R1:1__________###'
echo '### CIP:010_2_R1:1:4__END ###'
echo ''
echo ''


# CIP 10__5
#app specific
# 8/02/18 | pointed to CIP:007_6_R2:3
################################################################################
echo '### CIP:010_2_R1:1:5__START ###'
echo '###__Any security patches installed ###'
echo '###__________SEE CIP:007_6_R2:3__________###'
echo '### CIP:010_5_R1:1:5__END ###'
echo ''
echo ''


################################################################################
echo ' END_OF_SCRIPT '
echo ''
echo ''
################################################################################
