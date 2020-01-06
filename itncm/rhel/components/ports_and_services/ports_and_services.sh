# echo '### CIP:007_6_R1:1__START ###'
# echo '### CIP:010_2_R1:1:4__START ###'
# echo '###__Ports and Services that are enabled or listening on the system ###'
# DATE=`(date +"%m%d%y.%H%M")`
# SUMMARY="/tmp/NstatSummary.txt"
# STAGE="/tmp/NstatSumSTAGE_$DATE.txt"
# > $SUMMARY
# > $STAGE
# LINE="================================================================================================================="
# #================================================================================================================="
# ##----- 1         3         4       5       7       8       9
# printf "%-20.20s, %-10.10s, %-5.5s, %-5.5s, %-9.9s, %-4.4s, %-30.30s\n" COMMAND         USER   FD   TYPE   SIZE_OFF NODE NAME >> $SUMMARY
# lsof -nPi |egrep -i "LISTEN|UDP|NAME" |sort -k8,8 -k9rn,9 |egrep -v "NAME|127.0.0.1|::1" |sed s/\*/\\*/g > $STAGE
# for INST in `cat $STAGE |grep -n "" |cut -d":" -f1`
# do
# v1=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $1}'`
# #v2=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $2}'`
# v3=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $3}'`
# v4=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $4}'`
# v5=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $5}'`
# #v6=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $6}'`
# v7=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $7}'`
# v8=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $8}'`
# v9=`grep -n "" $STAGE |grep "^$INST": |cut -d":" -f2- |awk '{print $9,$10}'`
# #================================================================================================================="
# ##----  1         3         4       5       7       8       9
# printf "%-20.20s, %-10.10s, %-5.5s, %-5.5s, %-9.9s, %-4.4s, %-30.30s\n" "$v1" "$v3" "$v4" "$v5" "$v7" "$v8" "$v9" >> $SUMMARY
# done
# cat $SUMMARY
# echo '### CIP:010_2_R1:1:4__END ###'
# echo '### CIP:007_6_R1:1__END ###'
# echo ''
# echo ''

host_name=$(hostname)
netstat_output=$(sudo netstat -antp)

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
        # PRINT hostname, protocol, port, IPvX, process name
        printf "%s,%s,%s,%s,%s\n" $host_name $protocol_type $port $ip_type $process_name
    fi
    #echo "$protocol_type : $port_status : $process_name"
done

# pid_num=$(echo $line | awk '{print $7}' | cut -d "/" -f 1)
# ipv4_port=$(echo $line | awk '{print $4}' | cut -d ":" -f 2)
# printf "%s,%s,%s,%s\n" $host_name $protocol_type $port $process_name 
# echo "${protocol_type} : ${port}"