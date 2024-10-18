#!/bin/bash
#This scripts appends new virtual host configuration in /etc/nginx/conf.d/virtual.conf
#Author: Sudhir
#Date:16 Dec 2020

RED='\e[31m'
GREEN='\e[32m'
DEFAULT='\e[39m'

VHOST="$1"
TARGET="$2"
TICKET="$3"
ARG_LEN=$#
CONF_FILE="/etc/nginx/virtual.conf"
SCRIPT_NAME=$(basename $0|sed 's/\(\..*\)$//')

function check_No_Of_Aruguments () {
    if [[ $ARG_LEN -lt 3 ]] ; then
    echo -e "${RED}!*** ERROR ==> YOU MUST SPECIFY 3 ARGUMENTS ***! ${DEFAULT}"
    echo -e "${GREEN}   Usage: $SCRIPT_NAME <Virtual_Host_Name> https://<Redirect_Target_URL> TICKET/ITCM"
    echo -e "   Example: $SCRIPT_NAME test15.vmware.com https://app1-prod-vip.vmware.com TKT3948825 ${DEFAULT}"
    exit 1
    fi
}

function check_Upstream_Protocol () {
if [[ ! $TARGET =~ ^http.* ]]; then
    echo -e "${RED}!*** ERROR ==> PROTOCOL/SCHEME NAME IS MISSING IN SECOND ARGUMENT ***! ${DEFAULT}"
    echo -e "${GREEN}Prefix protocol/scheme name i.e. http:// or https:// in second arugument"
    echo -e "Usage: $SCRIPT_NAME <Virtual_Host_Name> http(s)://<Redirect_Target_URL> TICKET/ITCM "
    echo -e "Example: $SCRIPT_NAME test15.vmware.com https://app1-prod-vip.vmware.com TKT3948825 ${DEFAULT}"
    exit 1
fi
}


function test_Nginx_Config () {
echo "------ Test nginx config ------"
/usr/sbin/nginx -t  # Will capture return code, Do not add any cmd between next line!
if [ $? != 0 ]; then
   echo -e "${RED}!*** FATAL ERROR: nginx configtest failed on $node1 ***!"
   echo -e "!*** Configs not appended ***! ${DEFAULT}"
   exit 255;
fi
echo -e "${GREEN}NGINX CONFIG TEST IS SUCCESS $DEFAULT\n"
}

#fuction check_if_vhost_already_exist () {
#
#}

function main () {
check_No_Of_Aruguments
check_Upstream_Protocol
test_Nginx_Config
cp $CONF_FILE /root/backup/virtual.conf_$(date +"%Y_%m_%d_%H%M%S")
cat >> $CONF_FILE << EOF

# $TICKET
server {
        listen 80;
        server_name $VHOST;
        include      /etc/nginx/allow_GET_only.conf;
        return 301   $TARGET;
}
EOF
/usr/bin/tail -8 $CONF_FILE
test_Nginx_Config
}

main
