#!/bin/bash
max_lines=20
output="/var/mon.log"
tmplog="/tmp/mon.log.tmp"
memused=$( free |  awk '$1 == "Mem:" {x= $7/($3+$7)*100} $2 == "buffers/cache:" {x= $4/($3+$4)*100} $1 == "Swap:" {print (100-x)}')
cpuused=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')

#current number of lines in output file
lines=$(wc -l $output | cut --delimiter=' ' -f1)

#cut first line if max number was exceeded (memory)
if [[ $lines -ge $max_lines ]] ; then
	tail -n +2 "$output" > "$tmplog" && mv "$tmplog" "$output"
fi


#log used memory & cpu to file
timestamp=$(date '+%d.%m.%y %H:%M')
echo "['$timestamp',$memused,$cpuused]," >> "$output"

#update html file
/root/monitoring/create-output.sh $output
