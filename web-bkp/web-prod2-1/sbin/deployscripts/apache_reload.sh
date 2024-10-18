#!/bin/bash
echo "!! Reloading Apache service on all the nodes. !!"

HTTPDCONTROL=/usr/sbin/apachectl
HTTPHOSTS='web-prod2-2 web-prod2-3 web-prod2-4'
HOSTNAME=`hostname`
echo "Running configtest"
$HTTPDCONTROL configtest
if [ $? != 0  ]; then
  echo "apachectl configtest failed"
  exit 257
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

HTTP_STATUS=`/usr/bin/curl -s --output /tmp/deploy -w '%{http_code}' http://$HOSTNAME/server-status`
if [ $HTTP_STATUS != 200  ]; then
  echo "Apache Service is not running on server"
  echo "Reach out to core-infra-linux@vmware.com team immediately"
  echo
  exit 1
fi
echo
echo "Reloading apache on rest of the nodes"
for HOST in $HTTPHOSTS
do
    echo "---------- $HOST ----------"
    echo
    sudo -u salinux ssh salinux@$HOST "sudo $HTTPDCONTROL configtest && sudo $HTTPDCONTROL graceful"
    if [ $? != 0 ]; then
        echo "!! Apache service has not started successfully on $HOST. Restarting the service on other nodes. Reach out to Linux Team for issue on $HOST. !!"
    fi
    echo
    echo
done

