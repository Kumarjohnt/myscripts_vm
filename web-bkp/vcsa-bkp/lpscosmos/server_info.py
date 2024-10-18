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
import sssdldap
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
                try:
                    server_config.authtype = sssdldap.sssAuthLdap()
                except:
                    server_config.authtype = 'error'
            else:
                pass
            #    server_config.dmz = server_config.dmz
        if network == 'Trust':
            try:
                server_config.authtype = sssdldap.sssAuthLdap()
            except:
                server_config.authtype = 'error'
        if 'poc' in hostname:
            server_config.dmz = 'POC'

        if hostname.startswith("cilt"):
            network = 'Template'

        try:
            package_ver,rpm_v = server_config.check_rpm_ver('lpscosmos')
            if package_ver.split('.')[-1] == 'noarch':
                repo = package_ver.split('.')[-2]
            else:
                package_ver=package_ver.splitlines()[0]
                repo = package_ver.split('.')[-1]
            data1 = { "repo" : repo }
        except:
            data1 = { "repo" : 'Err' }

        patchrepo = data1['repo']
        time.sleep(random.randrange(0,15,30))
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
            "eol": server_config.os_version_eol(6),
        }
#        print(data)
        return data

if __name__ == '__main__':
    si = ServerInfo()
    server_info_data = si.get_server_info()

