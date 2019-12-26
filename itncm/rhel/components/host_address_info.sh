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