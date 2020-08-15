#!/bin/bash

####
# this script will log memory usage to a specified file
####

max_lines=300
output="/var/mon.log"
memfree=`cat /proc/meminfo | grep MemAvailable | awk '{print $2}'`; 
memtotal=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`;
memused=$((memtotal-memfree))
memused=$((memused*10000/memtotal))
lines=$(wc -l /var/mon.log | cut --delimiter=' ' -f1)

#cut first line if max number was exceeded
if [[ $lines -gt $max_lines ]] ; then
	tail -n +2 "$output" > "$output"
fi

#log used memory to file
echo "$memused $(date '+%d.%m.%y %H:%M')" >> /var/mon.log
