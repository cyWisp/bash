#!/bin/bash

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