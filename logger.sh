#!/bin/bash
max_lines=20
output="/var/mon.log"
tmplog="/tmp/mon.log.tmp"
memfree=`cat /proc/meminfo | grep MemAvailable | awk '{print $2}'`;
memtotal=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`;
memused=$((memtotal-memfree))
memused=$((memused*10000/memtotal))
cpuused=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')

#current number of lines in output file
lines=$(wc -l $output | cut --delimiter=' ' -f1)

#cut first line if max number was exceeded (memory)
if [[ $lines -ge $max_lines ]] ; then
        tail -n +2 "$output" > "$tmplog" && mv "$tmplog" "$output"
fi

#log used memory to file
echo "$memused $cpuused $(date '+%d.%m.%y %H:%M')" >> $output

#update html file
#/root/monitoring/create-output.sh
