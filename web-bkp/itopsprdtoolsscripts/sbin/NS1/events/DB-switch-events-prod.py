###############################################################################
## Script to failover DB for events.vmware.com                               ##
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

ib_pwdh="eTJNLkA2WU0uSDJQbyFkaWE3OQ=="
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
    parser.add_argument('--action',choices=['status','sc2','wdc'],default=None,help='Action to be executed')
    return parser


def TD_DB_Switch(dc):
        logger.info("Attempting DB failover to %s..." % dc)
        response = requests.get("https://infoblox.eng.vmware.com/wapi/v2.5/record:cname?name=vmworld-prd-mysql.infra.vmware.com", auth=(ib_username,ib_password), verify=False)
	#print(response.text)
        resp = response.json()
        reference = resp[0]
        ref = reference['_ref']
        if dc == 'wdc':
                data = json.dumps({"canonical":"vmworld-prd-wdc-vip.vmware.com"})
        elif dc == 'sc2':
                data = json.dumps({"canonical":"vmworld-prd-mysql-sc2.vmware.com"})
        response = requests.put("https://infoblox.eng.vmware.com/wapi/v2.5/"+ref+"?_return_fields%2B=name&_return_as_object=1", data, auth=(ib_username,ib_password), verify=False)
        if response.status_code !=200:
                return 1
	return 0


def dig_db():
	time.sleep(2)
        cmd='dig @10.113.61.110 vmworld-prd-mysql.infra.vmware.com +short'
        proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
        out,err=proc.communicate()
        print("events DB is internally resolving to -> " + out)


def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	    dig_db()
    elif args.action in ['sc2', 'wdc']:
	db_stat = TD_DB_Switch(args.action)
	if db_stat == 0:
	    logger.info("DB Failover was completed..")
	    dig_db()
	else:
	    logger.info("DB Failover was not completed..")
    else:
        logger.info('Unsupported option requested! Type -h, --help for options')


if __name__ == '__main__':
        TD_Runner()


