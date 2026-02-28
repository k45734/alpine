#!/bin/sh
FILE="/usr/bin/rclone"
if [ ! -e $FILE ];then
 curl https://rclone.org/install.sh | sudo bash &
fi
FILE="/app/complete.log"
if [ -e $FILE ];then
	rm start_*.log
else
	rm start_*.log
fi
FILE="/app/server_start.sh"
if [ -e $FILE ]; then
        /app/server_start.sh
else
        echo 'YES'
fi
supervisord -n -c /etc/supervisord.conf
