#!/usr/bin/python
import subprocess
from config import configurations

#[root@web-lt-1 ~]# rpm -qa | grep -i salt
# salt-minion-3005.1-1.el7.noarch
# salt-3005.1-1.el7.noarch


class saltagentInfo:
    def __init__(self):
        pass
    def get_salt_info(self):

        server_config = configurations()
        package_ver,rpm_v = server_config.check_rpm_ver('salt-minion')
        salt_minion_service = server_config.check_service_status('salt-minion')
        salt_minion_enabled = server_config.check_service_enable('salt-minion')
        ucp_salt_service = server_config.check_service_status('ucp-salt-minion')
        ucp_salt_enabled = server_config.check_service_enable('ucp-salt-minion')
        # ucp_minion_service = server_config.check_service_status('ucp-minion')
        # ucp_minion_enabled = server_config.check_service_enable('ucp-minion')
        try:
            salt_master = subprocess.Popen("cat /etc/salt/minion.d/* | grep -v '#' | grep -w -A 2 -i master:| head -2 | tail -1",stdout=subprocess.PIPE, shell=True).stdout.read().decode('utf-8').strip().split(' ')[1].strip()
        except:
            salt_master = "N/A"

        if salt_master == "N/A":
            try:
                salt_master = subprocess.Popen("cat /etc/salt/minion | grep -v '#' | grep master:",stdout=subprocess.PIPE, shell=True).stdout.read().decode('utf-8').strip().split(' ')[1].strip()
            except:
                salt_master = "N/A"

        if salt_minion_service == 'Running' and ucp_salt_service == 'Running':
            salt_service = 'Running'
        else:
            salt_service = 'Stopped'

        if salt_minion_enabled == 'Enabled' and ucp_salt_enabled == 'Enabled':
            salt_enabled = 'Enabled'
        else:
            salt_enabled = 'Disabled'

        salt_data  = {
            "vmname": server_config.hostname,
            "salt_service": salt_service,
            "salt_enabled": salt_enabled,
            "salt_master": salt_master,
            "salt_rpm": package_ver,
            "salt_version": rpm_v
        }
        return salt_data



testData = saltagentInfo()
print(testData.get_salt_info())

