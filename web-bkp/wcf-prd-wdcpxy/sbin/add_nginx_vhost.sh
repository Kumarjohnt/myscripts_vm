#!/bin/bash
#This scripts appends new virtual host configuration in /etc/nginx/virtual.conf
#Author: Sudhir
#Date:16 Dec 2020

RED='\e[31m'
GREEN='\e[32m'
DEFAULT='\e[39m'

VHOST="$1"
UPSTREAM="$2"
ARG_LEN=$#
CONF_FILE="/etc/nginx/virtual.conf"
SCRIPT_NAME=$(basename $0|sed 's/\(\..*\)$//')

function check_No_Of_Aruguments () {
    if [[ $ARG_LEN -lt 2 ]] ; then
    	echo "You must specify two arguments."
    	echo "Usage: $SCRIPT_NAME <Virtual_Host_Name> https://<Upstream_Server_Name/IP>"
    	echo "Example: $SCRIPT_NAME test15.vmware.com https://app1-prod-vip.vmware.com"
    	exit 1
    fi
}

function check_Upstream_Protocol () {
	if [[ ! $UPSTREAM =~ ^http.* ]]; then
    		echo "Protocol missing in second arugument"
    		echo "Prefix protocol name i.e. http:// or https:// in second arugument)"
    		echo "Usage: $SCRIPT_NAME <Virtual_Host_Name> http(s)://<Upstream_Server_Name/IP>"
    		echo "Example: $SCRIPT_NAME test15.vmware.com https://app1-prod-vip.vmware.com"
    		exit 1
	fi
}

function check_Nginx_Syntax () {
  echo "------ Test nginx config ------"
  /usr/sbin/nginx -t  # Will capture return code, Do not add any cmd between next line!
	if [ $? != 0 ]; then
   		echo -e "${RED}!*** FATAL ERROR: nginx configtest failed on $node1 ***!"
   		echo -e "!*** Configs not appended ***! ${DEFAULT}"
   		exit 255;
	fi
  echo -e "${GREEN}NGINX CONFIG TEST IS SUCCESS $DEFAULT\n"
}

######----Before we add vhost to /etc/nginx/conf.d/virtual.conf....fuction to check existence of vhost needs to be added here----#######

function main () {
check_No_Of_Aruguments
check_Upstream_Protocol
check_Nginx_Syntax
cp $CONF_FILE /root/backup/virtual.conf_$(date +"%Y_%m_%d_%H%M%S")
cat >> $CONF_FILE << EOF
server {
        listen 80;
        server_name $VHOST;
        include /etc/nginx/allow_GET_POST_PUT_DELETE_OPTIONS_only.conf;
        access_log /var/log/nginx/$(echo $VHOST)_access.log proxylog;
        error_log /var/log/nginx/$(echo $VHOST)_error.log;
        resolver 10.113.61.110 10.113.61.111 ipv6=off valid=30s;
        client_max_body_size 10M;
        location /akamai-probe.html {
            alias /etc/nginx/akamai-probe/akamai-probe.html
        }
        location / {
        proxy_set_header Host              \$http_host;
        proxy_set_header X-Forwarded-For   \$proxy_add_x_forwarded_for;
        set \$BACKEND $UPSTREAM;
        proxy_pass  \$BACKEND;
       }
}
EOF
/usr/bin/tail -19 $CONF_FILE
check_Nginx_Syntax
}
main
