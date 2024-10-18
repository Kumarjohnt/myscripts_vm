import json
import platform
import socket
import subprocess
import os
import random
import smtplib
import sys
import time
import pwd
import socket
import struct
from config import configurations

class SplunkInfo:
    def __init__(self):
        pass
    def get_splunk_info(self):

        server_config = configurations()
        package_ver,rpm_v = server_config.check_rpm_ver('splunkforwarder')
        if package_ver != 'Not Installed':
            sp_service = server_config.check_service_status('splunk')
            sp_enabled = server_config.check_service_enable('splunk')
            upstream = subprocess.Popen('timeout 2s /opt/splunkforwarder/bin/splunk show deploy-poll',stdout=subprocess.PIPE, shell=True ).stdout.read().decode('utf-8').strip()
            if upstream == '':
                upstream="Error"
            sp_upstream = (upstream.split()[-1]).replace('"','').split(':')[0]

        else:
            sp_service = 'Stopped'
            sp_enabled = 'Disabled'
            sp_upstream = 'NA'

        splunk_data  = {
            "vmname": server_config.hostname,
            "sp_rpm": package_ver,
            "sp_version": rpm_v,
            "sp_service": sp_service,
            "sp_enabled": sp_enabled,
            "sp_upstream": sp_upstream,
        }
        return splunk_data
