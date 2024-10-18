#!/bin/bash

HTTPDCONFDIR=/etc/httpd/conf/
CONFDIR=/etc/httpd/conf.d/
HTTPDMAINTDIR=/etc/httpd/webmaint/
HTTPDMODULEDIR=/etc/httpd/conf.modules.d/
HTTPDCONTROL=/usr/sbin/apachectl
HTTPDCGI=/etc/httpd/cgi-bin/
HTTPHOSTS='web-prod2-2 web-prod2-3 web-prod2-4'

echo "Running configtest"
$HTTPDCONTROL configtest
if [ $? != 0  ]; then
  echo "apachectl configtest failed"
  exit 257
fi

echo "Checking Apache status before reload on `hostname`..."
#$HTTPDCONTROL fullstatus |grep 'Apache/2.4.6'
$HTTPDCONTROL status | grep 'running'
if [ $? != 0  ]; then
  echo "Apache Service is not running on server"
  echo "Reach out to core-infra-linux@vmware.com team immediately"
  echo
  exit 1
fi

# local restart
echo "---------- `hostname` ----------"
echo
echo "Reloading Apache service"
$HTTPDCONTROL configtest && $HTTPDCONTROL graceful
echo
echo
echo "Waiting for 30 seconds to check the reload status"

#Waiting for 30 seconds to validate service is up after graceful restart
sleep 30

#$HTTPDCONTROL fullstatus |grep 'Apache/2.4.6'
$HTTPDCONTROL status | grep 'running'
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
    if [ $? != 0 ]; then
        echo "!! Apache service has not started successfully on $HOST. Restarting the service on other nodes. Reach out to Linux Team for issue on $HOST. !!"
    fi
    echo
    echo
done
