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

class EpopsInfo:
    def __init__(self):
        pass
    def get_epops_info(self):

        server_config = configurations()
        package_ver,rpm_v = server_config.check_rpm_ver('epops-agent')
        if package_ver != 'Not Installed':
            epops_service = server_config.check_service_status('epops-agent')
            epops_enabled = server_config.check_service_enable('epops-agent')
        else:
            epops_service = 'Stopped'
            epops_enabled = 'Disabled'

        epops_data  = {
            "vmname": server_config.hostname,
            "epops_rpm": package_ver,
            "epops_version": rpm_v,
            "epops_service": epops_service,
            "epops_enabled": epops_enabled,
        }
        return epops_data
