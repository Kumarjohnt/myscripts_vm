import os
import json
import platform
import socket
import subprocess
import random
import smtplib
import sys
import time
import pwd
import socket
import struct
from config import configurations

class ServerInfo:
    def __init__(self):
        pass

    def get_server_info(self):
        server_config = configurations()
        hostname = server_config.hostname
        network = server_config.dmz
        for netw in server_config.dmz_nw:
            if server_config.addressInNetwork(server_config.ipAddress,netw):
            #if address_in_network(ipAddress,netw) == 'True':
                network = 'DMZ'
                server_config.authtype = 'local'
            else:
                pass
            #    server_config.dmz = server_config.dmz
        if network == 'Trust' and os.path.isfile('/etc/sssd/sssd.conf'):
            try:
                if pwd.getpwnam('ukhalep'):
                    server_config.authtype = 'sssd'
            except:
                server_config.authtype = 'error'

        if 'poc' in hostname:
            server_config.dmz = 'POC'

        if hostname.startswith("cilt"):
            network = 'Template'

        try:
            with open("/opt/lps_scripts/patchdata.json", "r") as read_file:
                data1 = json.load(read_file)
        except:
            # with open("/opt/lps_scripts/dmz.json", "r") as read_file:
            #     data1 = json.load(read_file)
            data1 = { "repo" : '2019Q1' }

        patchrepo = data1['repo']
        time.sleep(random.randrange(0,15,30))
        #uptime = uptime()
        data = {
            "hostname" : hostname,
            "ipaddr" : server_config.ipAddress,
            "vm_os" : server_config.os_rel,
            "os_version" : server_config.os_version,
            "puppet" : server_config.check_service_status('puppet'),
            "uptime" : server_config.uptime(),
            "dmz" : network,
            "sssd" : server_config.check_service_status('sssd'),
            "patchrepo" : patchrepo,
            "authtype" : server_config.authtype,
            "vmtoolsd" : server_config.check_service_status('vmtoolsd'),
            "update_time" : server_config.update_time,
            "osowner" : server_config.osowner,
            "script_ver" : server_config.script_version,
        }
#        print(data)
        return data

if __name__ == '__main__':
    si = ServerInfo()
    server_info_data = si.get_server_info()

