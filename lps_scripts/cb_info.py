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

class CarbonBlackInfo:
    def __init__(self):
        pass
    def get_cb_info(self):
        server_config = configurations()
        package_ver,rpm_v = server_config.check_rpm_ver('cb-psc-sensor')
        if package_ver != 'Not Installed':
            cb_service = server_config.check_service_status('cbagentd')
            cb_enabled = server_config.check_service_enable('cbagentd')
            cb_upstream = 'Null'

        else:
            cb_service = 'Stopped'
            cb_enabled = 'Disabled'
            cb_upstream = 'NA'

        cb_data  = {
            "vmname": server_config.hostname,
            "cb_rpm": package_ver,
            "cb_version": rpm_v,
            "cb_service": cb_service,
            "cb_enabled": cb_enabled,
            "cb_upstream": cb_upstream,
        }
        return cb_data
        
if __name__ == '__main__':
    si = CarbonBlackInfo()
    cb_info_data = si.get_cb_info()
