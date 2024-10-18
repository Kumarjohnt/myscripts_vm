#############################################################################
## Script to failover DYN Traffic Director services for auth.vmware.com
## Maintainer : Neha G
## Contact : gneha@vmware.com, net-services@vmware.com
#############################################################################
import requests
import json
import argparse
import urllib3
import base64
import logging
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

_HEADERS = {
    "Content-type": "application/json",
    "Auth-Token" : ""
}

_CREDS = {
"customer_name":"vmwarecorporate",
"user_name":base64.b64decode("Y2RuYXBpc3RndXNlcg=="),
"password":base64.b64decode("eV5lLlleWTJVVHV6eV5ZLkEhVQ==")
}

_RECORD = {
    "SC2": "https://api2.dynect.net/REST/DSFRecord/sZJV94OqneHd1nFyw5EW2BqL0U4/roEY5alVLGQdElhC0lWnoszAW3A",
    "WDC": "https://api2.dynect.net/REST/DSFRecord/sZJV94OqneHd1nFyw5EW2BqL0U4/UN7p7gMSF_db3o_EGMqAEprL-vc",
    "VMC": "https://api2.dynect.net/REST/DSFRecord/sZJV94OqneHd1nFyw5EW2BqL0U4/uXoTOiptk_OJAkhguSocLPWXMM0",
    "SC2_RECOVERY": "https://api2.dynect.net/REST/DSFRecordSet/sZJV94OqneHd1nFyw5EW2BqL0U4/lMzGPnzfl-GAbBtG_d45O6_Z4HU",
    "WDC_RECOVERY": "https://api2.dynect.net/REST/DSFRecordSet/sZJV94OqneHd1nFyw5EW2BqL0U4/ELeNi78bhzbhtXOAt9MfeC6Z1d0"
}

_doNotServe = {
        'publish': 'Y',
        'automation': 'manual',
        'eligible': 'false'
    }

_monitorAndRemove = {
    'publish': 'Y',
    'automation': 'auto_down',
    'eligible': 'true'
}

_monitorAndObey = {
        'publish': 'Y',
        'automation': 'auto',
        'eligible': 'true'
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

def TD_GetAccessToken():
    response = requests.post('https://api.dynect.net/REST/Session/',headers={'Content-type': 'application/json'},json=_CREDS)
    try:
        access_token = response.json()['data']['token']
        return access_token
    except KeyError as err:
        return None

def TD_Status_DCs():
    urlForSC2 = _RECORD['SC2']
    urlForWDC = _RECORD['WDC']
    urlForVMC = _RECORD['VMC']
    urlForSC2recovery = _RECORD['SC2_RECOVERY']
    urlForWDCrecovery = _RECORD['WDC_RECOVERY']

    token = TD_GetAccessToken()
    if token is not None:
        logger.info("received authentication token...")
        _HEADERS["Auth-Token"] = token
    else:
        logger.error('could not retrieve access token...')
        return 1
    
    logging.info("fetching DC specific status..")
    response1 = requests.get(urlForSC2, verify=False, headers=_HEADERS)
    response2 = requests.get(urlForWDC, verify=False, headers=_HEADERS)
    response3 = requests.get(urlForVMC, verify=False, headers=_HEADERS)
    print("\nSC2 DC status is currently "+response1.json()['data']['status'])
    print("WDC DC status is currently "+ response2.json()['data']['status'])
    print("VMC DC status is currently "+ response3.json()['data']['status'])

def TD_FailoverTo(dc):
    urlForSC2 = _RECORD['SC2']
    urlForWDC = _RECORD['WDC']
    urlForVMC = _RECORD['VMC']
    urlForSC2recovery = _RECORD['SC2_RECOVERY']
    urlForWDCrecovery = _RECORD['WDC_RECOVERY']

    logger.info("attempting failover to %s..." % dc)
    logger.info("requesting authentication token...")
    token = TD_GetAccessToken()
    if token is not None:
        logger.info("received authentication token...")
        _HEADERS["Auth-Token"] = token
    else:
        logger.error('could not retrieve access token...')
        return 1
    logging.info("fetching status..")
    response1 = requests.get(urlForSC2, verify=False, headers=_HEADERS)
    response2 = requests.get(urlForWDC, verify=False, headers=_HEADERS)
    response3 = requests.get(urlForVMC, verify=False, headers=_HEADERS)

    sc2_elig = response1.json()['data']['status']
    wdc_elig = response2.json()['data']['status']
    vmc_elig = response3.json()['data']['status']

    # Fail-over to WDC
    if dc == 'wdc':
        logger.info("failing over to WDC...")
	if wdc_elig == "up":
        	response = requests.put(urlForSC2, json=_doNotServe, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1


        	response = requests.put(urlForWDC, json=_monitorAndRemove, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1

		response = requests.put(urlForWDCrecovery, json=_monitorAndRemove, headers=_HEADERS)
                if response.status_code != 200:
                        return 1

        	response = requests.put(urlForVMC, json=_monitorAndObey, headers=_HEADERS)
        	if response.status_code != 200:
    			return 1
	else:
		logger.info("WDC is currently not eligible for failover...")
		return 1
	return 0

    # Fail-over to VMC
    elif dc == 'vmc':
	if vmc_elig == "up":
        	logger.info("failing over to VMC...")
        	response = requests.put(urlForSC2, json=_doNotServe, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1

        	response = requests.put(urlForWDC, json=_doNotServe, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1
        
        	response = requests.put(urlForVMC, json=_monitorAndObey, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1
	else:
                logger.info("VMC is currently not eligible for failover...")
		return 1
        return 0

    # Fail-over to SC2
    elif dc == 'sc2':
	if sc2_elig == "up":
        	logger.info("failing over to SC2...")
        	response = requests.put(urlForSC2, json=_monitorAndRemove, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1

        	response = requests.put(urlForSC2recovery, json=_monitorAndRemove, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1

        	respone = requests.put(urlForWDC, json=_monitorAndRemove, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1

		response = requests.put(urlForWDCrecovery, json=_monitorAndRemove, headers=_HEADERS)
                if response.status_code != 200:
                        return 1

        	respone = requests.put(urlForVMC, json=_monitorAndObey, headers=_HEADERS)
        	if response.status_code != 200:
            		return 1
	else:
		logger.info("SC2 is currently not eligible for failover...")
		return 1
	return 0

    else:
        return 1
        

def TD_Runner():
    args = TD_Argument_Parser().parse_args()
    if args.action == 'status':
        dc = TD_GetStatusFromCDN('https://s751x.vmware.com.edgekey.net/web/csp/','auth.vmware.com')
        if dc is not None:
            print('Currently serving from %s \n' % dc)
	    
        else:
            logger.error('Could not retrieve status from CDN')
	TD_Status_DCs()
    elif args.action in ['sc2', 'wdc', 'vmc']:
        stat = TD_FailoverTo(args.action)
        if stat == 0:
            logger.info("failover was completed..")
        else:
            logger.error("failover was not completed.")
    else:
        logger.error('ERROR :: Unsupported option requested!')


if __name__ == '__main__':
	TD_Runner()

