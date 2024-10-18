#!/usr/bin/python

"""
Script Name   :- Cosmos Data Collection
Version       :- 3.2
Written in    :- Python3
Project name  :- CosMos
Author        :- LPS Team
Owner         :- Linux-Platform-Services@vmware.com
"""
# Change Log 
#2.3  - Added SSL URL
#2.4  - Working with Related data
#2.5  - Added decode in subprocess for python3 support
#2.6  - Added Path in Cron and DMZ NETWORK
#2.7  - Updated Version format for service check
#2.8  - Cron time change
#3.1  - Removed Curl dependency
#3.2  - Updated Auth detection method
#3.3  - Added new agents method(Salt,liagent,Backup) by Abhirup


import json, sys
import os
from config import configurations
from server_info import ServerInfo
from splunk_info import SplunkInfo
from cb_info import CarbonBlackInfo
from vrops_telegraf import VropsTelegrafInfo
from epops_info import EpopsInfo
from avamar import avamarInfo
from liagent import liagentInfo
from salt import saltagentInfo

# import login
from logger import MyLogger  
logger = MyLogger("cosmos", level='DEBUG')

workdir = '/opt/lpscosmos/'
sys.path.append(workdir)

main_server_conf = configurations()
si = ServerInfo()
splunk_info = SplunkInfo()
cb = CarbonBlackInfo()
vrops_tele = VropsTelegrafInfo()
ep = EpopsInfo()
avr = avamarInfo()
li = liagentInfo()
sa = saltagentInfo()

server_info_data = si.get_server_info()
splunk_data = splunk_info.get_splunk_info()
cb_data = cb.get_cb_info()
vrops_data = vrops_tele.get_vrops_telegraf_info()
epops_data = ep.get_epops_info()
avamar_data = avr.get_avamar_info()
liagent_data = li.get_liagent_info()
salt_data = sa.get_salt_info()
hname = main_server_conf.hostname

dmz = server_info_data['dmz']
print('Updating data')

curl_cmd = workdir + 'cmcli' + ' -s ' + hname + ' -i  vmupdate ' +  '-p ' + '\'' + json.dumps(server_info_data) + '\'' + ' -i  cbdata ' +  '-p ' + '\'' + json.dumps(cb_data) + '\'' + ' -i  splunkdata ' +  '-p ' + '\'' + json.dumps(splunk_data) + '\'' + ' -i  epopsdata ' +  '-p ' + '\'' + json.dumps(epops_data) + '\'' + ' -i  vropstelegrafdata ' +  '-p ' + '\'' + json.dumps(vrops_data) + '\'' + ' -i  backupdata ' +  '-p ' + '\'' + json.dumps(avamar_data) + '\'' + ' -i  loginsightdata ' +  '-p ' + '\'' + json.dumps(liagent_data) + '\''  + ' -i  saltdata ' +  '-p ' + '\'' + json.dumps(salt_data) + '\''

os.system(curl_cmd)

