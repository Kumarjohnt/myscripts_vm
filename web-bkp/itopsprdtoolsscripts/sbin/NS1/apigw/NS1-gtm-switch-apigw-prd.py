#####################################################################################
## Script to failover NS1 Filter Chain services for apigw.gtmglb.vmware.com        ##
## Maintainer : Neha G                                                             ##
## Contact : gneha@vmware.com, net-services@vmware.com				   ##
#####################################################################################

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
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

_HEADERS = {
    "X-NSONE-Key": "F6O52Y44KAhbcjKiPJhU",
    "Content-type": "application/json",
}

_FEED = {
        "url_switch" : "https://api.nsone.net/v1/feed/b93a9f1a12507c34e05b8233e9245324",
        "url_status_sc2" : "https://api.nsone.net/v1/monitoring/jobs/5ee62914e97cf5008a05f3f4",
        "url_status_wdc" : "https://api.nsone.net/v1/monitoring/jobs/5ee6299e16aed30091d73025"
}

_SC2_DOWN = {
        "jobid":"5ee62914e97cf5008a05f3f4",
        "up": False
}

_SC2_UP = {
        "jobid":"5ee62914e97cf5008a05f3f4",
        "up": True
}

_WDC_DOWN = {
	"jobid":"5ee6299e16aed30091d73025",
	"up": False
}

_WDC_UP = {
        "jobid":"5ee6299e16aed30091d73025",
        "up": True
}

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)-5.5s] %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()

def TD_Argument_Parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--action',choices=['status','sc2','wdc'],default='status',help='Action to be executed')
    return parser

def TD_Trigger_Mail(dc):
        now = datetime.now()
        msg1 = MIMEText("Date and Time : %s" % now.strftime("%m/%d/%Y, %H:%M:%S") +"\nAffected Service : apigw.gtmglb.vmware.com"+"\nCurrent DC : %s" % dc.upper())
        msg1["From"] = "NS1 <no-reply@ns1.com>"
        rec = ["net-services@vmware.com","it-middleware-admin@vmware.com"]
        msg1['To'] = ", ".join(rec)
        msg1["Subject"] = "Filter Chain Service Alert : apigw.gtmglb.vmware.com has been manually changed to %s" % dc.upper()
        p = Popen(["/usr/sbin/sendmail", "-t", "-oi"], stdin=PIPE)
        p.communicate(msg1.as_string())


def TD_Status_DCs():
	url_sc2 = _FEED["url_status_sc2"]
	url_wdc = _FEED["url_status_wdc"]
	response1 = requests.get(url_sc2, verify=False, headers=_HEADERS)
	response2 = requests.get(url_wdc, verify=False, headers=_HEADERS)
	res1 = response1.json()["status"]["global"]["status"]
	res2 = response2.json()["status"]["global"]["status"]
	print("\nSC2 DC status is currently "+ res1)
    	print("WDC DC status is currently "+ res2)


def TD_FailoverTo(dc):
	logger.info("Attempting failover to %s..." % dc)
	url = _FEED["url_switch"]
	logging.info("Fetching status..")
	url_sc2 = _FEED["url_status_sc2"]
        url_wdc = _FEED["url_status_wdc"]
        response1 = requests.get(url_sc2, verify=False, headers=_HEADERS)
        response2 = requests.get(url_wdc, verify=False, headers=_HEADERS)
        sc2_elig = response1.json()["status"]["global"]["status"]
        wdc_elig = response2.json()["status"]["global"]["status"]

	if dc == 'wdc':
        	logger.info("Failing over to WDC...")
		if wdc_elig == "up":
			response = requests.post(url,json=_SC2_DOWN,headers=_HEADERS)
			if response.status_code != 200:
                        	return 1
			response1 = requests.post(url,json=_WDC_UP,headers=_HEADERS)
			if response1.status_code != 200:
                                return 1
		else:
                        logger.info("WDC is currently down and not eligible for failover...")
                        return 1
                return 0

	elif dc == 'sc2':
		logger.info("Failing over to SC2...")
		if sc2_elig == "up":
                	response = requests.post(url,json=_SC2_UP,headers=_HEADERS)
                	if response.status_code != 200:
                        	return 1
		else:
                        logger.info("SC2 is currently down and not eligible for failover...")
                        return 1
                return 0
	else:
		return 1


def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
        TD_Status_DCs()
    elif args.action in ['sc2', 'wdc']:
        stat = TD_FailoverTo(args.action)
        if stat == 0:
            logger.info("Failover was completed..")
	    TD_Trigger_Mail(args.action)
        else:
            logger.error("Failover was not completed.")
    else:
        logger.error('ERROR :: Unsupported option requested!')


if __name__ == '__main__':
        TD_Runner()


