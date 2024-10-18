###############################################################################
## Script to failover APP for events.vmware.com                              ##
## Maintainer : Neha G							     ##
## Contact : gneha@vmware.com, net-services@vmware.com			     ##
###############################################################################

import sys
import time
import shlex,subprocess
import json
import httplib2
import argparse
from getpass import getpass
import requests
import logging
import urllib3
from datetime import datetime
from subprocess import Popen, PIPE
from email.mime.text import MIMEText
import base64

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

ib_pwdh="OVdwNGozcnEhczY2ViFBXkguIQ=="
ib_username = 'svc.nssapi'
ib_password = base64.b64decode(ib_pwdh)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)-5.5s] %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()

def TD_Argument_Parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--action',choices=['status','sc2-primary','sc2-tertiary'],default=None,help='Action to be executed')
    return parser


def TD_Internal_Switch(dc):
	logger.info("Attempting internal failover to %s..." % dc)
	response = requests.get("https://infoblox.eng.vmware.com/wapi/v2.5/record:cname?name=events-sc2-prd-app.vmware.com", auth=(ib_username,ib_password), verify=False)
#        print(response.text)
	resp = response.json()
        reference = resp[0]
        ref = reference['_ref']
	if dc == 'sc2-primary':
        	data = json.dumps({"canonical":"vmworld-sc2-prd-app-vip.vmware.com"})
	elif dc == 'sc2-tertiary':
		data = json.dumps({"canonical":"events-prod-sc2tkg-app-vip.tkg.vmware.com"})
        response = requests.put("https://infoblox.eng.vmware.com/wapi/v2.5/"+ref+"?_return_fields%2B=name&_return_as_object=1", data, auth=(ib_username,ib_password), verify=False)
        if response.status_code !=200:
		return 1
	return 0


def dig_int():
	time.sleep(5)
	cmd='dig @10.113.61.110 events-sc2-prd-app.vmware.com +short'
        proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
        out,err=proc.communicate()
        print("events app is internally resolving to -> " + out)


def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	    dig_int()
    elif args.action in ['sc2-primary', 'sc2-tertiary']:	
	ib_stat = TD_Internal_Switch(args.action)
	if ib_stat == 0:
            logger.info("Internal Failover was completed..")
	    dig_int()
        else:
            logger.error("Internal Failover was not completed.")
    else:
        logger.info('Unsupported option requested! Type -h, --help for options')


if __name__ == '__main__':
        TD_Runner()


