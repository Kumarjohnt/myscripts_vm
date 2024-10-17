#!/usr/bin/python
import subprocess
from config import configurations

class liagentInfo:
    def __init__(self):
        pass
    def get_liagent_info(self):

        server_config = configurations()
        if server_config.os_rel == "Ubuntu":
            package_ver,rpm_v = server_config.check_rpm_ver('vmware-log-insight-agent')
        else:
            package_ver,rpm_v = server_config.check_rpm_ver('Log-Insight-Agent')
        agent_service_status = server_config.check_service_status('liagentd')
        agent_enabled_status = server_config.check_service_enable('liagentd')
        # try:
        #     collectorHostname = subprocess.Popen(("sudo", "cat", "/etc/liagent.ini"), stdout=subprocess.PIPE)
        #     grepCollectorHostname = subprocess.check_output(("grep", "-i", "^\;hostname"), stdin=collectorHostname.stdout)
        #     CollectorHostnameInStr = str(grepCollectorHostname)
        #     CollectorHostnameInStr = CollectorHostnameInStr.strip().split("=")[1]
        # except:
        #     CollectorHostnameInStr = "N/A"

        if agent_service_status == 'Running':
            liagent_service = 'Running'
        else:
            liagent_service = 'Stopped'

        if agent_enabled_status == 'Enabled':
            liagent_enabled = 'Enabled'
        else:
            liagent_enabled = 'Disabled'

        liagent_data  = {
            "vmname": server_config.hostname,
            "loginsight_service": liagent_service,
            "loginsight_enabled": liagent_enabled,
            # "collector_hostname": CollectorHostnameInStr,
            "loginsight_rpm": package_ver,
            "loginsight_version": rpm_v,
        }
        return liagent_data


testData = liagentInfo()
print(testData.get_liagent_info())

