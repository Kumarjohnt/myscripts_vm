#####################################################################################
## Script to failover Internal Kong -Stage f5                                      ##
## Maintainer : Neha G                                                             ##
## Contact : gneha@vmware.com, net-services@vmware.com				   ##
#####################################################################################

import sys
import time
import json
import httplib2
import argparse
import shlex,subprocess
from getpass import getpass
import requests
import logging
import urllib3
from datetime import datetime
from subprocess import Popen, PIPE
from email.mime.text import MIMEText
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)-5.5s] %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()

def TD_Argument_Parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--action',choices=['sc2','wdc','status'],default=None,help='Action to be executed')
    return parser

def TD_Trigger_Mail(dc):
        now = datetime.now()
	msg1 = MIMEText("Date and Time : %s" % now.strftime("%m/%d/%Y, %H:%M:%S") +"\nAffected Service : apigw-stg.intglb.vmware.com"+"\nCurrent DC : %s" % dc.upper())
        msg1["From"] = "f5 <no-reply@f5.com>"
        rec = ["gneha@vmware.com"]
        msg1['To'] = ", ".join(rec)
        msg1["Subject"] = "f5 Alert : Kong Internal(Stage) has been flipped to  %s" % dc.upper()
        p = Popen(["/usr/sbin/sendmail", "-t", "-oi"], stdin=PIPE)
        p.communicate(msg1.as_string())



def TD_FailoverTo(dc):
	logger.info("attempting failover to %s..." % dc)
	url_wideip = "https://10.188.3.0/mgmt/tm/gtm/pool/a/~Common~apigw-stg-scdc-pool/members/~Common~avicontroller-sjc5:apigw-stg-vip-https"
	if dc == 'sc2':
        	logger.info("failing over to SC2...")
		data = json.dumps({"enabled": True})
		response = requests.patch(url_wideip,data,auth=('svc.avi_orchestrate','oN..L.u3US!Am3s@x66'),verify=False)
		if (response.status_code == 200):
                        	return 0
		else:
				return 1
	

	elif dc == 'wdc':
		logger.info("failing over to WDC...")
                data = json.dumps({"disabled": True})
                response = requests.patch(url_wideip,data,auth=('svc.avi_orchestrate','oN..L.u3US!Am3s@x66'),verify=False)
		if (response.status_code == 200):
                                return 0
                else:   
                                return 1

def dig_int():
        time.sleep(2)
        cmd='dig @10.113.61.110 apigw-stg.intglb.vmware.com +short'
        proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
        out,err=proc.communicate()
        print("Kong Stage is internally resolving to -> " + out)


def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
	dig_int()
    elif args.action in ['sc2', 'wdc']:
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
