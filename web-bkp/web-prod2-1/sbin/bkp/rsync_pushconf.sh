#!/bin/bash

HTTPDCONFDIR=/etc/httpd/conf.d/
HTTPDMAINTDIR=/etc/httpd/webmaint/
HTTPDCONTROL=/usr/sbin/apachectl
#HTTPHOSTS='web-prod-2-new web-prod-3-new web-prod-4-new'
HTTPHOSTS='10.128.20.16 10.128.20.17 10.128.20.18'

echo "Running configtest"
$HTTPDCONTROL configtest
if [ $? != 0  ]; then
  echo "apachectl configtest failed"
  exit 257
fi

echo 
echo "Push to all nodes"
echo

# local restart
echo "---------- `hostname` ----------"
echo
$HTTPDCONTROL configtest
echo
echo

for HOST in $HTTPHOSTS
do
    echo "---------- $HOST ----------"
    echo
    rsync -avz --delete -e ssh $HTTPDCONFDIR $HOST:$HTTPDCONFDIR
    rsync -avz --delete -e ssh $HTTPDMAINTDIR $HOST:$HTTPDMAINTDIR
#    rsync -avz --delete -e ssh $CONFDIR $HOST:$CONFDIR
#    rsync -avz --delete -e ssh $HTTPDMODULEDIR $HOST:$HTTPDMODULEDIR
#    rsync -avz --delete -e ssh $HTTPDCGI $HOST:$HTTPDCGI
    ssh $HOST "$HTTPDCONTROL configtest"
    echo
    echo
done
