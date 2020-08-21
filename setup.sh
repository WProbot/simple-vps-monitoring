#!/bin/bash

# check if root
if [[ $(whoami) != "root" ]] ; then
	echo "run me as a root!";
	exit 1;
fi

# check if crontab already has simple-monitor.sh defined
crontab -l | grep "simple-monitor.sh"
if [[ $? -eq 0 ]] ; then
	echo "simple-monitor.sh is already defined in crontab. Delete it first and re-run this script"
	echo "type 'crontab -e' to edit cron job list"
	exit 2;
fi

# download simple monitor script
curl -O https://raw.githubusercontent.com/jakubpartyka/simple-vps-monitoring/master/simple-monitor.sh
chmod +x simple-monitor.sh

# get user input
echo "provide interval for monitoring log file updating (minutes):"
read INTERVAL

# check if interval is correct
if [[ $INTERVAL -gt 59 ]] ||  [[ $INTERVAL -lt 1 ]] ; then
	echo "Incorrect interval was specified. Please choose a value between 1 and 59"
	exit 3
fi

echo "how much time a log entry should be kept? This implies how far back memory and cpu usage will be show on monitoring page. Provide time in hours:"
read HOURS

MAX_LOGS=$(((60/INTERVAL)*HOURS))
echo "$MAX_LOGS log entries will be kept"

# get output folder
echo "specify output folder where HTML file should be saved:"
read OUTPUT

mkdir -p $OUTPUT

if ! [[ -d $OUTPUT ]] ; then
	echo "Specified folder does not exists"
	exit 4
fi

echo "configuring monitoring script"

# delete first 5 lines from monitoring file
tail -n +6 "simple-monitor.sh" > "simple-monitor.sh.tmp"
echo "#!/bin/bash

### CONFIG ###
MAX_LOG_CNT=$MAX_LOGS  	# max number of monitoring log entries that will be kept
OUTPUT="$OUTPUT/index.html"	# file to which an usage graph will be written to" > simple-monitor.sh

cat "simple-monitor.sh.tmp" >> "simple-monitor.sh"
rm "simple-monitor.sh.tmp"

echo "creating cron job"

(crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $(pwd)/simple-monitor.sh") | crontab -

echo "simple monitor is now configured!"
