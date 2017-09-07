#!/bin/bash

for LINE in `lsof -c pingDevices -F p`; do 
    if [ $$ -gt ${LINE#?} ] ; then
        echo "'$0' is already running" 1>&2
        exit 1;
    fi
done

rm "/home/pi/devices.txt"
(s=192.168.1 ; for i in $(seq 1 254) ; do ( ping -n -c 1 -w 1 $s.$i 1>/dev/null 2>&1 && printf "%-16s %s\n" $s.$i ) & done ; wait ; echo) > "/home/pi/devices.txt"

chmod a+w "/home/pi/devices.txt"

# timeout 3 ping -b 192.168.1.255

# arp -a | grep -v '<incomplete>' | sort -r | while read line; do
# 	ip=$( echo $line | grep -oP '\(\K[^)]+' )
# 	echo -n $ip
# 	result=$( ping -c 3 $ip )
#     if [[ "${result}" == *" 0% packet loss"* ]] ; then
#         echo " Online"
#         echo "$line at $(date)" >> "/home/pi/devices.txt"
#     else
#         echo " Offline"
#     fi
# done