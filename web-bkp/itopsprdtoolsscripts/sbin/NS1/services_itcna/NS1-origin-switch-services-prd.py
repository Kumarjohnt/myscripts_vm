####################################################################################
## Script to failover NS1 cdnorigin record for services-itcna.cdnorigin.vmware.com ##
## Maintainer : Neha G							          ##
## Contact : gneha@vmware.com, net-services@vmware.com			          ##
####################################################################################

import shlex, subprocess
import sys
import time
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
	"url_switch" : "https://api.nsone.net/v1/zones/cdnorigin.vmware.com/services-itcna.cdnorigin.vmware.com/A"
}

_PAYLOAD_SC2 = json.dumps({ "zone" : "cdnorigin.vmware.com" ,
                            "domain": "services-itcna.cdnorigin.vmware.com",
                            "type": "A",
                            "answers":[{"answer": ["66.170.111.238"]}] })

_PAYLOAD_WDC = json.dumps({ "zone" : "cdnorigin.vmware.com" ,
                            "domain":"services-itcna.cdnorigin.vmware.com",
                            "type": "A",
                            "answers":[{"answer": ["208.91.1.235"]}] })

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

def TD_GetStatusFromCDN(cdn_url,host):
    response_from_cdn = requests.get(cdn_url,verify=False,headers={'host': host, 'Cache-Control': 'no-cache'})
    try:
        dc = response_from_cdn.headers['DC-Instance']
        return dc
    except KeyError as err:
        return None


def TD_FailoverTo(dc):
	logger.info("Attempting failover to %s..." % dc)
	url = _URL["url_switch"]
	if dc == 'wdc':
        	logger.info("Failing over to WDC...")
		response = requests.request("POST",url,data=_PAYLOAD_WDC,headers=_HEADERS)
	#	print(response.text)
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


def dig():
        time.sleep(2)
        cmd='dig @dns1.p05.nsone.net services-itcna.cdnorigin.vmware.com +short'
        proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
        out,err=proc.communicate()
	out1 = out.strip()
        print("services-itcna.cdnorigin.vmware.com record is resolving to -> " + out)
	sc = "66.170.111.238"
	wdc = "208.91.1.235"
	if out1 == sc:
                logger.info("Currently serving from SC2")
        elif out1 == wdc:
                logger.info("Currently serving from WDC")
        else:
                logger.info("Error! Could not retrieve the status")	

def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	dig()
    elif args.action in ['sc2', 'wdc']:
        stat = TD_FailoverTo(args.action)
        if stat == 0:
            logger.info("Failover was completed..")
	    dig()
        else:
            logger.error("Failover was not completed.")
	    dig()
    else:
        logger.info('Unsupported option requested! Type -h, --help for options')


if __name__ == '__main__':
        TD_Runner()


