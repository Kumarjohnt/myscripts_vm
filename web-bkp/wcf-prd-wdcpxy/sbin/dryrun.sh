#!/bin/bash

dir1=/etc/nginx/
hosts='websocket-prd2-ngx1'

/etc/init.d/nginx configtest

if [ $? != 0 ]; then
   echo "nginx configtest failed"
   echo "do nothing"
   exit;
fi

hostname
#/etc/init.d/nginx reload

for host in $hosts
do
    echo $host
    rsync -av --dry-run --delete -e ssh $dir1 $host:$dir1
    #ssh $host "/etc/init.d/nginx reload"
done
