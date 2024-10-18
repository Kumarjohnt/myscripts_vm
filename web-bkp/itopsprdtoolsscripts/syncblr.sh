#!/bin/bash

CONFDIR=/opt/sbin/
SUDOFILE=/etc/sudoers

HOSTS='itops-blr3-tools'

for HOST in $HOSTS
do
    echo "---------- $HOST ----------"
    echo
       rsync -avz --delete -e ssh $CONFDIR $HOST:$CONFDIR
       rsync -avz --delete -e ssh $SUDOFILE $HOST:$SUDOFILE
    echo
    echo
done

