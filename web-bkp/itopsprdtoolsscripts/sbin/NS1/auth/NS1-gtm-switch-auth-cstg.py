###############################################################################
## Script to failover NS1 Traffic Director services for auth-cstg.vmware.com ##
## Maintainer : Neha G							     ##
## Contact : gneha@vmware.com, net-services@vmware.com			     ##
###############################################################################

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
        "url_status_sc2" : "https://api.nsone.net/v1/monitoring/jobs/5ee15583b00767009075ec69",
        "url_status_wdc" : "https://api.nsone.net/v1/monitoring/jobs/5ee15652b00767008d9eb929",
        "url_status_vmc" : "https://api.nsone.net/v1/monitoring/jobs/5ee155c86711b300987c406e"
}

_SC2_DOWN = {
        "jobid":"5ee15583b00767009075ec69",
        "up": False
}

_SC2_UP = {
        "jobid":"5ee15583b00767009075ec69",
        "up": True
}
_WDC_DOWN = {
        "jobid": "5ee15652b00767008d9eb929",
        "up": False
}
_WDC_UP = {
        "jobid": "5ee15652b00767008d9eb929",
        "up": True
}
_VMC_DOWN = {
        "jobid": "5ee155c86711b300987c406e",
        "up": False
}
_VMC_UP = {
        "jobid": "5ee155c86711b300987c406e",
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
    parser.add_argument('--action',choices=['status','sc2','wdc','vmc'],default='status',help='Action to be executed')
    return parser

def TD_GetStatusFromCDN(cdn_url,host):
    response_from_cdn = requests.get(cdn_url,verify=False,headers={'host': host, 'Cache-Control': 'no-cache'})
    try:
        dc = response_from_cdn.headers['DC-Instance']
        return dc
    except KeyError as err:
        return None

def TD_Trigger_Mail(dc):
        now = datetime.now()
        msg1 = MIMEText("Date and Time : %s" % now.strftime("%m/%d/%Y, %H:%M:%S") +"\nAffected Service : auth-cstg.gtmglb-stg.vmware.com"+"\nCurrent DC : %s" % dc.upper())
        msg1["From"] = "NS1 <no-reply@ns1.com>"
        rec = ["net-services@vmware.com","it-idm@vmware.com","auth@vmware.com"]
        msg1['To'] = ", ".join(rec)
        msg1["Subject"] = "Filter Chain Service Alert : auth-cstg.gtmglb-stg.vmware.com has been manually changed to %s" % dc.upper()
        p = Popen(["/usr/sbin/sendmail", "-t", "-oi"], stdin=PIPE)
        p.communicate(msg1.as_string())

def TD_Status_DCs():
	url_sc2 = _FEED["url_status_sc2"]
	url_wdc = _FEED["url_status_wdc"]
	url_vmc = _FEED["url_status_vmc"]
	response1 = requests.get(url_sc2, verify=False, headers=_HEADERS)
	response2 = requests.get(url_wdc, verify=False, headers=_HEADERS)
	response3 = requests.get(url_vmc, verify=False, headers=_HEADERS)
	res1 = response1.json()["status"]["global"]["status"]
	res2 = response2.json()["status"]["global"]["status"]
	res3 = response3.json()["status"]["global"]["status"]
	print("\nSC2 DC status is currently "+ res1)
    	print("WDC DC status is currently "+ res2)
	print("VMC DC status is currently "+ res3)


def TD_FailoverTo(dc):
	logger.info("attempting failover to %s..." % dc)
	url = _FEED["url_switch"]
	logging.info("fetching status..")
	url_sc2 = _FEED["url_status_sc2"]
        url_wdc = _FEED["url_status_wdc"]
        url_vmc = _FEED["url_status_vmc"]
        response1 = requests.get(url_sc2, verify=False, headers=_HEADERS)
        response2 = requests.get(url_wdc, verify=False, headers=_HEADERS)
        response3 = requests.get(url_vmc, verify=False, headers=_HEADERS)
        sc2_elig = response1.json()["status"]["global"]["status"]
        wdc_elig = response2.json()["status"]["global"]["status"]
        vmc_elig = response3.json()["status"]["global"]["status"]

	if dc == 'wdc':
        	logger.info("failing over to WDC...")
		if wdc_elig == "up":
			response = requests.post(url,json=_SC2_DOWN,headers=_HEADERS)
			if response.status_code != 200:
                        	return 1
			response = requests.post(url,json=_WDC_UP,headers=_HEADERS)
                        if response.status_code != 200:
                                return 1
		else:
                	logger.info("WDC is currently down and not eligible for failover...")
                	return 1
        	return 0

	elif dc == 'vmc':
		logger.info("failing over to VMC...")
		if vmc_elig == "up":
                	response = requests.post(url,json=_SC2_DOWN,headers=_HEADERS)
                	if response.status_code != 200:
                        	return 1
			response = requests.post(url,json=_WDC_DOWN,headers=_HEADERS)
			if response.status_code != 200:
                                return 1
			response = requests.post(url,json=_VMC_UP,headers=_HEADERS)
                        if response.status_code != 200:
                                return 1
		else:
                        logger.info("VMC is currently down and not eligible for failover...")
                        return 1
		return 0

	elif dc == 'sc2':
		logger.info("failing over to SC2...")
		if sc2_elig == "up":
                	response = requests.post(url,json=_SC2_UP,headers=_HEADERS)
                        if response.status_code != 200:
                                return 1
			response = requests.post(url,json=_WDC_UP,headers=_HEADERS)
                        if response.status_code != 200:
                                return 1
			response = requests.post(url,json=_VMC_UP,headers=_HEADERS)
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
        dc = TD_GetStatusFromCDN('https://s751x.vmware.com.edgekey.net/web/csp/','auth-cstg.vmware.com')
        if dc is not None:
            print('Currently serving from %s \n' % dc)

        else:
            logger.error('Could not retrieve status from CDN')
        TD_Status_DCs()
    elif args.action in ['sc2', 'wdc', 'vmc']:
        stat = TD_FailoverTo(args.action)
        if stat == 0:
            logger.info("failover was completed..")
	    TD_Trigger_Mail(args.action)
        else:
            logger.error("failover was not completed.")
    else:
        logger.error('ERROR :: Unsupported option requested!')


if __name__ == '__main__':
        TD_Runner()


