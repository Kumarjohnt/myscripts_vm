#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
DEFAULT='\e[39m'

dir1=/etc/nginx/

#Do Not Sync /etc/nginx/ssl
excldir=ssl
excldir2=conf-LOCAL

node1=`/usr/bin/hostname -s`
#hosts='ph-prd2-web2'
hosts='ph-prd2-web2 ph-prd2-web3'

echo
echo "------ Test nginx config file on $node1"
sudo /usr/sbin/nginx -t  # Will capture return code, Do not add any cmd between next line!
if [ $? != 0 ]; then
   echo -e "${RED}!*** FATAL ERROR: nginx configtest failed on $node1 ***!"
   echo -e "!*** Configs were not pushed out ***! ${DEFAULT}"
   exit 255;
fi
echo -e "${GREEN}OK $DEFAULT\n"


echo "------ Reload nginx service on $node1"
sudo /usr/bin/systemctl reload nginx.service
if [ $? != 0 ]; then
    echo -e "${RED}!*** FATAL ERROR: nginx reload failed on $node1 ***!"
    echo -e "!*** Please contact Linux admin to check nginx service status ***! ${DEFAULT}"
    exit 255;
fi
echo -e "${GREEN}OK $DEFAULT\n"

for host in $hosts
do

    echo "------ Rsync configs from ${node1}:${dir1} to $host"
    #rsync -av --delete --exclude $excldir --exclude $excldir2 -e ssh $dir1 $host:$dir1
    rsync -avz --delete --exclude $excldir --exclude $excldir2 -e ssh --rsync-path='sudo rsync' $dir1 salinux@$host:$dir1
    if [ $? != 0 ]; then
       echo -e "${RED}!*** FATAL ERROR: Rsync config file from ${node1}:${dir1} to $host failed ***!"
       echo -e "!***  Please contact Linux admin to check nginx service status ***! ${DEFAULT}"
       exit 255;
    fi
    echo -e "${GREEN}OK $DEFAULT\n"


    echo "------ Reload nginx service on $host"
    sudo -u salinux ssh salinux@$host "sudo /usr/bin/systemctl reload nginx.service"
    if [ $? != 0 ]; then
       echo -e "${RED}!*** FATAL ERROR: nginx reload failed on $host ***!"
       echo -e "!*** Please contact Linux admin to check nginx service status ***! ${DEFAULT}"
       exit 255;
    fi
    echo -e "${GREEN}OK $DEFAULT\n"
done

echo -e "${GREEN}Success${DEFAULT}"

