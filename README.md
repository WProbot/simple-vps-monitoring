
# Simple VPS Monitoring
This is a simple and lightweight shell script that logs current CPU and Memory usage og the host machine with user-specified interval. 
An HTML file contains usage-over-time graph is created and placed under directory defined in `simple-monitor.sh` script.
Memory/CPU usage graph is generated using [Google Charts](https://developers.google.com/chart) scripts.
Intended to run on remote server to provide quick access to usage logs via browser. 

## How to use (with setup.sh)
Simply download and run setup.sh script. It will configure monitoring script and cron job definition.

## How to use
Place the script in convenient location, add execute permissions and add a cron job definition.

Edit `simple-monitor.sh` file and set OUTPUT variable to folder where HTML files should be located. For example, Nginx HTML path is `/var/www/html/`.

In directory where `simple-monitoring.sh` file is placed run:

    chmod +x simple-monitor.sh

Then edit crontab file

    crontab -e
    
and add following line a the top of the file

    * * * * * path/to/simple-monitor.sh

This will tell the cron daemon to run simple-monitoring script every minute. 
*(To learn more about defining cron jobs you can visit [CronTab Guru](https://crontab.guru)).*

From now on, an usage graph will be updated every minute. If number of log entries exceeds MAX_LOGS value (specified inside the script) the least recent log will be deleted. 
Hosting service will make usage graph accessible via your server's address on port 80. Simply enter your server IP address in the browser to view usage graph.
