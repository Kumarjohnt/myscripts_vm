#!/bin/bash
find /home/kongadmin -name "dump.log*" -type f -mtime +4 -exec rm -f {} \;
find /home/kongadmin -name "script.log*" -type f -mtime +4 -exec rm -f {} \;
