########################################################################################
## Script to failover CDN Failover between Akamai and Imperva                         ##                 
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


_URL_1 = {
	"url_switch" : "https://api.nsone.net/v1/zones/cdnswitchstg.vmware.com/cdn-test-1.cdnswitchstg.vmware.com/CNAME"
}
_URL_2 = {
        "url_switch" : "https://api.nsone.net/v1/zones/cdnswitchstg.vmware.com/cdn-test-2.cdnswitchstg.vmware.com/CNAME"
}
_URL_3 = {
        "url_switch" : "https://api.nsone.net/v1/zones/cdnswitchstg.vmware.com/cdn-test-3.cdnswitchstg.vmware.com/CNAME"
}

_PAYLOAD_INCAPSULA_1 = json.dumps({ "zone" : "cdnswitchstg.vmware.com" ,
                            "domain": "cdn-test-1.cdnswitchstg.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["y7ru4jt.x.incapdns.net."]}] })

_PAYLOAD_INCAPSULA_2 = json.dumps({ "zone" : "cdnswitchstg.vmware.com" ,
                            "domain": "cdn-test-2.cdnswitchstg.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["y7ru4jt.x.incapdns.net."]}] })

_PAYLOAD_INCAPSULA_3 = json.dumps({ "zone" : "cdnswitchstg.vmware.com" ,
                            "domain": "cdn-test-3.cdnswitchstg.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["y7ru4jt.x.incapdns.net."]}] })

_PAYLOAD_AKAMAI_1 = json.dumps({ "zone" : "cdnswitchstg.vmware.com" ,
                            "domain":"cdn-test-1.cdnswitchstg.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["s4236.vmware.com.edgekey.net."]}] })

_PAYLOAD_AKAMAI_2 = json.dumps({ "zone" : "cdnswitchstg.vmware.com" ,
                            "domain":"cdn-test-2.cdnswitchstg.vmware.com",
                            "type": "CNAME",
                            "answers":[{"answer": ["s4236.vmware.com.edgekey.net."]}] })

_PAYLOAD_AKAMAI_3 = json.dumps({ "zone" : "cdnswitchstg.vmware.com" ,
                            "domain":"cdn-test-3.cdnswitchstg.vmware.com",
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

def TD_External_Switch(dc,x):
	logger.info("Attempting external failover to %s..." % dc)
	if x == 1:
		url = _URL_1["url_switch"]
		data_a = _PAYLOAD_AKAMAI_1
		data_i = _PAYLOAD_INCAPSULA_1
	elif x == 2:
		url = _URL_2["url_switch"]
                data_a = _PAYLOAD_AKAMAI_2
		data_i = _PAYLOAD_INCAPSULA_2
	elif x == 3:
		url = _URL_3["url_switch"]
                data_a = _PAYLOAD_AKAMAI_3
		data_i = _PAYLOAD_INCAPSULA_3
	if dc == 'akamai':
        	logger.info("Failing over to Akamai...")
		response = requests.request("POST",url,data=data_a,headers=_HEADERS)
		if response.status_code != 200:
                       	return 1
		return 0

	elif dc == 'incapsula':
		logger.info("Failing over to Incapsula...")
                response = requests.request("POST",url,data=data_i,headers=_HEADERS)
		#print(response.text) 
                if response.status_code != 200:
                        return 1
		return 0
    	else:
        	return 1

def dig(n):
	time.sleep(2)
	cmd='dig @dns1.p05.nsone.net ' +n + ' +short'
	proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
	out,err=proc.communicate()
	print(n +" is resolving to -> " + out)

def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	    dig("cdn-test-1.cdnswitchstg.vmware.com")
	    dig("cdn-test-2.cdnswitchstg.vmware.com")
	    dig("cdn-test-3.cdnswitchstg.vmware.com")
    elif args.action in ['incapsula', 'akamai']:
	while(True):
		#print("1. Test-1 \n2. Test-2 \n3. Test-3")
		print("Current status: ")
		dig("cdn-test-1.cdnswitchstg.vmware.com")
                dig("cdn-test-2.cdnswitchstg.vmware.com")
                dig("cdn-test-3.cdnswitchstg.vmware.com")
		print("1. Test-1 \n2. Test-2 \n3. Test-3")
		x = input("Enter the number against the app that needs failover: ")
		stat = TD_External_Switch(args.action,x)	
        	if stat == 0:
         	   	logger.info("External Failover was completed..")
       		else:
            		logger.error("External Failover was not completed.")
		res = raw_input("Do you want to continue Yes/No: ")
		if res == "No" or res == "no":
			print("Quitting..")
			break
    else:
        logger.info('Unsupported option requested! Type -h, --help for options')


if __name__ == '__main__':
        TD_Runner()


