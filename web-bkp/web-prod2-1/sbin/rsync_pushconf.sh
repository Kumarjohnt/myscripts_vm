#!/bin/bash

HTTPDCONFDIR=/etc/httpd/conf.d/
HTTPDMAINTDIR=/etc/httpd/webmaint/
#HTTPDENV=/etc/httpd/bin/envvars
HTTPDCONTROL=/usr/sbin/apachectl
#HTTPHOSTS='web-prod-2'
HTTPHOSTS='web-prod2-2 web-prod2-3 web-prod2-4'

$HTTPDCONTROL configtest
if [ $? != 0  ]; then
  echo "apachectl configtest failed"
  exit 255
fi

echo
echo "Push to all nodes"
echo

# local restart
#echo "---------- `hostname` ----------"
#echo
#$HTTPDCONTROL configtest
#echo
#echo

for HOST in $HTTPHOSTS
do
    echo "---------- $HOST ----------"
    echo

    rsync -avz --delete -e ssh --rsync-path='sudo rsync' $HTTPDCONFDIR salinux@$HOST:$HTTPDCONFDIR
    rsync -avz --delete -e ssh --rsync-path='sudo rsync' $HTTPDMAINTDIR salinux@$HOST:$HTTPDMAINTDIR
#    rsync -avz --delete -e ssh $HTTPDCONFDIR $HOST:$HTTPDCONFDIR
#    rsync -avz --delete -e ssh $HTTPDMAINTDIR $HOST:$HTTPDMAINTDIR
#    rsync -avz --delete -e ssh $HTTPDENV $HOST:$HTTPDENV
    ssh salinux@$HOST "sudo $HTTPDCONTROL configtest"
    if [ $? != 0 ]; then
        echo "!! apachectl configtest failed on $HOST. Please reach out Linux team for support on $HOST. !!"
    fi
    echo
    echo
done

