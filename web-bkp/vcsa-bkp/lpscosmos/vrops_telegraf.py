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

class VropsTelegrafInfo:
    def __init__(self):
        pass
    def get_vrops_telegraf_info(self):

        server_config = configurations()
        ucp_service = server_config.check_service_status('ucp-telegraf')
        ucp_enabled = server_config.check_service_enable('ucp-telegraf')
        # ucp_salt_service = server_config.check_service_status('ucp-salt-minion')
        # ucp_salt_enabled = server_config.check_service_enable('ucp-salt-minion')
        # ucp_minion_service = server_config.check_service_status('ucp-minion')
        # ucp_minion_enabled = server_config.check_service_enable('ucp-minion')
        try:
            vrops_telegraf_master = subprocess.Popen('grep -i master /opt/vmware/ucp/salt-minion/etc/salt/minion',stdout=subprocess.PIPE, shell=True ).stdout.read().decode('utf-8').strip().split(':')[1].strip()
        except:
            vrops_telegraf_master = "N/A"

        if ucp_service == 'Running': #and ucp_salt_service == 'Running' and ucp_minion_service == 'Running':
            vrops_telegraf_service = 'Running'
        else:
            vrops_telegraf_service = 'Stopped'

        if ucp_enabled == 'Enabled': #and ucp_salt_enabled == 'Enabled' and ucp_minion_enabled == 'Enabled':
            vrops_telegraf_enabled = 'Enabled'
        else:
            vrops_telegraf_enabled = 'Disabled'
        
        vrops_telegraf_data  = {
            "vmname": server_config.hostname,
            "vrops_telegraf_service": vrops_telegraf_service,
            "vrops_telegraf_enabled": vrops_telegraf_enabled,
            "vrops_telegraf_master": vrops_telegraf_master,
        }
        return vrops_telegraf_data
