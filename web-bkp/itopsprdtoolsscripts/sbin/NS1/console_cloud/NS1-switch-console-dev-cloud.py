########################################################################################
## Script to failover NS1 cdnorigin record for console-dev-cloud.cdnswitch.vmware.com  #                 
## Maintainer : Neha G							              ##
## Contact : gneha@vmware.com, net-services@vmware.com			              ##
########################################################################################

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

_URL = {
	"url_switch" : "https://api.nsone.net/v1/zones/cdnswitch.vmware.com/console-dev-cloud.cdnswitch.vmware.com/CNAME"
}

_PAYLOAD_INCAPSULA = json.dumps({ "zone" : "cdnswitch.vmware.com" ,
                            "domain": "console-dev-cloud.cdnswitch.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["y7ru4jt.x.incapdns.net."]}] })

_PAYLOAD_AKAMAI = json.dumps({ "zone" : "cdnswitch.vmware.com" ,
                            "domain":"console-dev-cloud.cdnswitch.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["s4236.vmware.com.edgekey.net."]}] })


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)-5.5s] %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()

def TD_Argument_Parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--action',choices=['status','incapsula','akamai'],default=None,help='Action to be executed')
    return parser


def TD_External_Switch(dc):
	logger.info("Attempting external failover to %s..." % dc)
	url = _URL["url_switch"]
	if dc == 'akamai':
        	logger.info("Failing over to Akamai...")
		response = requests.request("POST",url,data=_PAYLOAD_AKAMAI,headers=_HEADERS)
		if response.status_code != 200:
                       	return 1
		return 0

	elif dc == 'incapsula':
		logger.info("Failing over to Incapsula...")
                response = requests.request("POST",url,data=_PAYLOAD_INCAPSULA,headers=_HEADERS)
                if response.status_code != 200:
                        return 1
		return 0
    	else:
        	return 1

def dig():
	time.sleep(2)
	cmd='dig @dns1.p05.nsone.net console-dev-cloud.cdnswitch.vmware.com +short'
	proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
	out,err=proc.communicate()
	print("\nconsole-dev-cloud.cdnswitch.vmware.com is resolving to -> " + out)

def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	    dig()
    elif args.action in ['incapsula', 'akamai']:
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


