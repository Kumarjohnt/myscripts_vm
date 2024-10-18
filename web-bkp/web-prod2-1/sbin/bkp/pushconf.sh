#!/bin/bash

HTTPDCONFDIR=/etc/httpd/conf/
CONFDIR=/etc/httpd/conf.d/
HTTPDMAINTDIR=/etc/httpd/webmaint/
HTTPDMODULEDIR=/etc/httpd/conf.modules.d/
HTTPDCONTROL=/usr/sbin/apachectl
HTTPDCGI=/etc/httpd/cgi-bin/
#HTTPHOSTS='web-prod-2-new web-prod-3-new web-prod-4-new'
HTTPHOSTS='10.128.20.16 10.128.20.17 10.128.20.18'

echo "Running configtest"
$HTTPDCONTROL configtest
if [ $? != 0  ]; then
  echo "apachectl configtest failed"
  exit 257
fi

$HTTPDCONTROL fullstatus |grep 'Apache/2.4.6'
if [ $? != 0  ]; then
  echo "Apache Service is not running on server"
  echo "Reach out to core-infra-linux@vmware.com team immediately"
  echo
  exit 1
fi

# local restart
echo "---------- `hostname` ----------"
echo
$HTTPDCONTROL configtest && $HTTPDCONTROL graceful
echo
echo

#Waiting for 30 seconds to validate service is up after graceful restart
sleep 5

$HTTPDCONTROL fullstatus |grep 'Apache/2.4.6'
if [ $? != 0  ]; then
  echo "Apache Service is not running on server"
  echo "Reach out to core-infra-linux@vmware.com team immediately"
  echo
  exit 1
fi

echo
echo "Push to all nodes"
echo
for HOST in $HTTPHOSTS
do
    echo "---------- $HOST ----------"
    echo
    rsync -avz --delete -e ssh $HTTPDCONFDIR $HOST:$HTTPDCONFDIR
    rsync -avz --delete -e ssh $HTTPDMAINTDIR $HOST:$HTTPDMAINTDIR
    rsync -avz --delete -e ssh $CONFDIR $HOST:$CONFDIR
    rsync -avz --delete -e ssh $HTTPDMODULEDIR $HOST:$HTTPDMODULEDIR
    rsync -avz --delete -e ssh $HTTPDCGI $HOST:$HTTPDCGI
    ssh $HOST "$HTTPDCONTROL configtest && $HTTPDCONTROL graceful"
    echo
    echo
done
