###############################################################################
## Script to failover NS1 cdnorigin record for vmworld.com                   ##
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

pwdh="RjZPNTJZNDRLQWhiY2pLaVBKaFU="
pwd=base64.b64decode(pwdh)

_HEADERS = {
    "X-NSONE-Key": pwd ,
    "Content-type": "application/json",
}

ib_pwdh="R3FiWXpOU2tzMkZMNksyYg=="
ib_username = 'svc.coreinfra_robot'
ib_password = base64.b64decode(ib_pwdh)

_URL = {
	"url_switch" : "https://api.nsone.net/v1/zones/cdnorigin.vmware.com/vmworld.cdnorigin.vmware.com/A"
}

_PAYLOAD_SC2 = json.dumps({ "zone" : "cdnorigin.vmware.com" ,
                            "domain": "vmworld.cdnorigin.vmware.com",
                            "type": "A",
                            "answers":[{"answer": ["208.91.0.232"]}] })

_PAYLOAD_VMC = json.dumps({ "zone" : "cdnorigin.vmware.com" ,
                            "domain":"vmworld.cdnorigin.vmware.com",
                            "type": "A",
                            "answers":[{"answer": ["44.226.141.141"]}] })


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)-5.5s] %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()

def TD_Argument_Parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--action',choices=['status','sc2','vmc'],default=None,help='Action to be executed')
    return parser


def TD_External_Switch(dc):
	logger.info("Attempting external failover to %s..." % dc)
	url = _URL["url_switch"]
	if dc == 'vmc':
        	logger.info("Failing over to VMC...")
		response = requests.request("POST",url,data=_PAYLOAD_VMC,headers=_HEADERS)
		if response.status_code != 200:
                       	return 1
		return 0

	elif dc == 'sc2':
		logger.info("Failing over to SC2...")
                response = requests.request("POST",url,data=_PAYLOAD_SC2,headers=_HEADERS)
                if response.status_code != 200:
                        return 1
		return 0
    	else:
        	return 1

def TD_Internal_Switch(dc):
	logger.info("Attempting internal failover to %s..." % dc)
	response = requests.get("https://infoblox.eng.vmware.com/wapi/v2.5/record:cname?name=www.vmworld.com", auth=(ib_username,ib_password), verify=False)
        resp = response.json()
        reference = resp[0]
        ref = reference['_ref']
	if dc == 'vmc':
        	data = json.dumps({"canonical":"vmworld-prd-int-web-vip.vmware.com"})
	elif dc == 'sc2':
		data = json.dumps({"canonical":"vmworld-prd2-int-web-vip.vmware.com"})
        response = requests.put("https://infoblox.eng.vmware.com/wapi/v2.5/"+ref+"?_return_fields%2B=name&_return_as_object=1", data, auth=(ib_username,ib_password), verify=False)
        if response.status_code !=200:
		return 1
	return 0

def dig_int():
	time.sleep(2)
	cmd='dig @10.113.61.110 www.vmworld.com +short'
        proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
        out,err=proc.communicate()
        print("vmworld.com is internally resolving to -> " + out)

def dig():
	time.sleep(2)
	cmd='dig @dns1.p05.nsone.net vmworld.cdnorigin.vmware.com +short'
	proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
	out,err=proc.communicate()
	print("vmworld.com origin record is resolving to -> " + out)

def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	    dig()
	    dig_int()
    elif args.action in ['sc2', 'vmc']:
	ib_stat = TD_Internal_Switch(args.action)
	if ib_stat == 0:
            logger.info("Internal Failover was completed..")
	    dig_int()
        else:
            logger.error("Internal Failover was not completed.")
        stat = TD_External_Switch(args.action)
        if stat == 0:
            logger.info("External Failover was completed..")
	    dig()
        else:
            logger.error("External Failover was not completed.")
	    dig()
    else:
        logger.info('Unsupported option requested! Type -h, --help for options')


if __name__ == '__main__':
        TD_Runner()


