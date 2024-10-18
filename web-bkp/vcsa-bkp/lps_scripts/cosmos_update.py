#!/usr/bin/python

"""
Script Name   :- Cosmos Data Collection
Version       :- 2.8
Written in    :- Python3
Project name  :- CosMos
Author        :- LPS Team
Owner         :- Priyank Ukhale
"""
# Change Log 
#2.3  - Added SSL URL
#2.4  - Working with Related data
#2.5  - Added decode in subprocess for python3 support
#2.6  - Added Path in Cron and DMZ NETWORK
#2.7  - Updated Version format for service check
#2.8  - Cron time change

import json
import subprocess
from config import configurations
from server_info import ServerInfo
from splunk_info import SplunkInfo
from cb_info import CarbonBlackInfo

main_server_conf = configurations()
si = ServerInfo()
splunk_info = SplunkInfo()
cb = CarbonBlackInfo()

server_info_data = si.get_server_info()
#splunk_data = splunk_info.get_splunk_info()

hname = main_server_conf.hostname

dmz = server_info_data['dmz']

userdata = { "username": "test","password": "user@123"} # this is for priyank-test
userdata = '\'' + json.dumps(userdata) + '\''
tokenurl = main_server_conf.api_url + 'auth/get-token/'
gettoken = 'curl ' + '-k'  + ' -w' + ' "\n\nHTTPStatusCode: %{http_code}\n" ' + '--location --request POST ' + tokenurl + ' --header "Content-Type: application/json" -d' + userdata
main_server_conf.post_method(gettoken)
get_access_token = main_server_conf.get_token()

uuidurl = main_server_conf.api_url + 'cilt/get-vm-uuid/' + hname + '/'
uuid_cmd = 'curl ' + '-k'  + ' -w' + ' "\n\nHTTPStatusCode: %{http_code}\n" ' + '--location --request GET ' + uuidurl + ' --header "Authorization: Bearer ' + get_access_token + '" --header ' + '"Content-Type: application/json"'
print(uuid_cmd)

cmd_exe = subprocess.Popen(uuid_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
out =(((cmd_exe.stdout.read()).decode('utf-8')).split('\n')[0])
print(out)
output = json.loads(out)
hostname_id =  output['uuid_vmos']
log = open('/tmp/hostname_id', 'w')
log.write(hostname_id)

server_info_data['uuid_vmos'] = hostname_id
data = '\'' + json.dumps(server_info_data) + '\''
print(data)
vmdataupdate = '/tmp/' + hname + '.json'
log = open(vmdataupdate, 'w')
log.write(data)

splunk_data = '\'' + json.dumps(splunk_info.get_splunk_info()) + '\''
log = open('/tmp/' + hname + '.splunk_data.json', 'w')
log.write(splunk_data)

cb_data = '\'' + json.dumps(cb.get_cb_info()) + '\''
log = open('/tmp/' + hname + '.cb_data.json', 'w')
log.write(cb_data)

hosturl = main_server_conf.api_url + 'cilt/vmupdate/' + hostname_id + '/'
host_curl_cmd = 'curl ' + '-k'  + ' -w' + ' "\n\nHTTPStatusCode: %{http_code}\n" ' + '--location ' +  '--request ' +  'PUT ' + hosturl + ' --header "Authorization: Bearer ' + get_access_token +'" --header ' + '"Content-Type: application/json" ' + '-d ' +  data
print(host_curl_cmd)
main_server_conf.post_method(host_curl_cmd)

splunk_url = main_server_conf.api_url + 'cilt/splunkdata/' + hostname_id + '/'
splunk_curl_cmd = 'curl ' + '-k'  + ' -w' + ' "\n\nHTTPStatusCode: %{http_code}\n" ' + '--location ' +  '--request ' +  'PUT ' + splunk_url + ' --header "Authorization: Bearer ' + get_access_token +'" --header ' + '"Content-Type: application/json" ' + '-d ' +  splunk_data
main_server_conf.post_method(splunk_curl_cmd)

cb_url = main_server_conf.api_url + 'cilt/cbdata/' + hostname_id + '/'
cb_curl_cmd = 'curl ' + '-k'  + ' -w' + ' "\n\nHTTPStatusCode: %{http_code}\n" ' + '--location ' +  '--request ' +  'PUT ' + cb_url + ' --header "Authorization: Bearer ' + get_access_token +'" --header ' + '"Content-Type: application/json" ' + '-d ' +  cb_data
main_server_conf.post_method(cb_curl_cmd)
