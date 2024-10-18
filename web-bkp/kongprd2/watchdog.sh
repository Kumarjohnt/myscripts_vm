#!/bin/bash
/bin/ps aux | /bin/grep '/usr/bin/python /home/kongadmin/kongmonitor.py' | /bin/grep -v grep
if [ $? -eq 0 ]
        then
                echo "Script is running"
        else
                echo "Starting script"
               /usr/bin/python /home/kongadmin/kongmonitor.py   &
fi
