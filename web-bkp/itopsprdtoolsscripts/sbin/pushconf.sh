#!/bin/bash

CONFDIR=/opt/sbin
HOSTS='itops-blr3-tools'
echo
echo "Push to all nodes"
echo
for HOST in $HOSTS
do
    echo "---------- $HOST ----------"
    echo
    rsync -avz --delete -e ssh $CONFDIR $HOST:$CONFDIR
    echo
    echo
done
