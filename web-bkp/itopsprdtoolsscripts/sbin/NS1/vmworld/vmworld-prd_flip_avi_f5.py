#####################################################################################
## Script to failover VIPs between AVI and F5                                      ##
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


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)-5.5s] %(message)s",
    handlers=[
        logging.StreamHandler()
    ])
logger = logging.getLogger()

def TD_Argument_Parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--action',choices=['avi','f5'],default=None,help='Action to be executed')
    return parser

def TD_Trigger_Mail(dc):
        now = datetime.now()
        msg1 = MIMEText("Date and Time : %s" % now.strftime("%m/%d/%Y, %H:%M:%S") +"\nVMWorld Prod VIPs have been flipped to : %s" % dc.upper())
        msg1["From"] = "NSS"
        rec = ["net-services@vmware.com"]
        msg1['To'] = ", ".join(rec)
        msg1["Subject"] = "VMWorld VIPs have been flipped to  %s" % dc.upper()
        p = Popen(["/usr/sbin/sendmail", "-t", "-oi"], stdin=PIPE)
        p.communicate(msg1.as_string())


#def failover():
controller_ip = "10.81.28.2"
avi_version = "18.2.9"
user = "svc.avi_orchestrate"
pwd = "E541@C!59M^.^mDKhbo"
tenant = "VDR-TNT-DMZ-1"
vips_list = ["vmworld-prd-ext-web-vip-443","vmworld-prd-int-web-vip-443"]
tenant1 = "VDR-TNT-INT-1"
vips_list1 = ["vmworld-vmc-prd-app-vip-443","vmworld-vmc-prd-app-vip-6443"]
	#state = False


#def avi_failover(state):
	#Login Session
login = requests.post('https://'+controller_ip+'/login', data = {'username':user, 'password':pwd}, verify = False)

def avi_failover(state):
	for vip in vips_list:
   		print vip
    		vs_state(controller_ip,avi_version,tenant,vip,state)
	for vip1 in vips_list1:
		print vip1
		vs_state(controller_ip,avi_version,tenant1,vip1,state)
#	logout = requests.post('https://'+controller_ip+'/logout', headers = {'X-CSRFToken':login.cookies['csrftoken'], 'Referer':'https://'+controller_ip}, cookies = login.cookies, verify = False)


#Fuction Definition
def vs_state(controller_ip,avi_version,tenant,vip,state):
 	vss_response = requests.get('https://'+controller_ip+'/api/virtualservice', headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), verify = False)
        vss_resp = vss_response.json()
	#print(vss_resp)
        vss_result =  vss_resp['results']

        for i,j in enumerate(vss_result):
         vss_res = j
        if vss_res['name'] == vip:
            vs_url = vss_res['url']
            vs_response = requests.get(vs_url, headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), verify = False)
            vs_resp = vs_response.json()
            vs_resp['enabled'] = state
	    vs_resp['traffic_enabled'] = state
            final_response = requests.put(vs_url, data = json.dumps(vs_resp), headers = {'Content-Type':'application/json', 'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version, 'X-CSRFToken':login.cookies['csrftoken']}, cookies = dict(sessionid = login.cookies['sessionid'], csrftoken = login.cookies['csrftoken']), verify = False)
            print final_response



def TD_FailoverTo(dc):
	logger.info("attempting failover to %s..." % dc)
	url_vip = "https://10.81.28.12/mgmt/tm/ltm/virtual-address/~Prod~10.81.20.20"
	url_vip_1 = "https://10.81.28.12/mgmt/tm/ltm/virtual-address/~Prod~10.81.20.19"
	url_vip2 = "https://10.81.28.14/mgmt/tm/ltm/virtual-address/~Prod~10.81.16.24"
	url_snat = "https://10.81.28.12/mgmt/tm/ltm/snat-translation/~Prod~10.81.20.23"
	url_snat1 = "https://10.81.28.12/mgmt/tm/ltm/snat-translation/~Prod~10.81.20.24"
	url_snat2 = "https://10.81.28.12/mgmt/tm/ltm/snat-translation/~Prod~10.81.20.21"
	url_snat3 = "https://10.81.28.12/mgmt/tm/ltm/snat-translation/~Prod~10.81.20.22"
	if dc == 'f5':
		avi_failover(False)
        	logger.info("failing over to F5...")
		avi_failover(False)
		data = json.dumps({"arp":"enabled","enabled":"yes","icmp-echo":"enabled"})
		data1 = json.dumps({"enabled":True,"arp":"enabled"})
		response = requests.patch(url_vip,data,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response1 = requests.patch(url_vip_1,data,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response2 = requests.patch(url_vip2,data,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response3 = requests.patch(url_snat,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response4 = requests.patch(url_snat1,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response5 = requests.patch(url_snat2,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response6 = requests.patch(url_snat3,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		if (response.status_code == 200 and response1.status_code == 200 and response2.status_code == 200):
                        	return 0
		else:
				return 1
	

	elif dc == 'avi':
		logger.info("failing over to AVI...")
		data = json.dumps({"arp":"disabled","enabled":"no","icmp-echo":"disabled"})
		data1 = json.dumps({"disabled":True,"arp":"disabled"})
		response = requests.patch(url_vip,data,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
                response1 = requests.patch(url_snat,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		response2 = requests.patch(url_vip2,data,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
                response3 = requests.patch(url_snat,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
                response4 = requests.patch(url_snat1,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
                response5 = requests.patch(url_snat2,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
                response6 = requests.patch(url_snat3,data1,auth=('svc.avi_orchestrate','E541@C!59M^.^mDKhbo'),verify=False)
		if (response.status_code == 200  and  response1.status_code == 200 and response2.status_code == 200):
				avi_failover(True)
                                return 0
                else:   
                                return 1


def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action in ['avi', 'f5']:
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
