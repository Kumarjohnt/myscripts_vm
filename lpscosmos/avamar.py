#!/usr/bin/python
import subprocess
from config import configurations

class avamarInfo:
    def __init__(self):
        pass
    def get_avamar_info(self):

        server_config = configurations()#if avamar also check networker. if no avamar then also check networker.
        if server_config.os_rel == "Ubuntu":#!
            package_ver_avamar,rpm_v_avamar = server_config.check_rpm_ver('avamarclient-debian')
        else:
            package_ver_avamar,rpm_v_avamar = server_config.check_rpm_ver('AvamarClient')

        package_ver_networker,rpm_v_networker = server_config.check_rpm_ver('lgtoclnt')

        # avamar_service_status = "Stopped"
        # avamar_enabled_status = "Disabled"
        # networker_service_status = "Stopped"
        # networker_enabled_status = "Disabled"
        avamar_service_status = server_config.check_service_status('avagent')
        avamar_enabled_status = server_config.check_service_enable('avagent')
        networker_service_status = server_config.check_service_status('networker')
        networker_enabled_status = server_config.check_service_enable('networker')

        # try:
        #     collectorHostname = subprocess.Popen(("sudo", "cat", "/etc/liagent.ini"), stdout=subprocess.PIPE)
        #     grepCollectorHostname = subprocess.check_output(("grep", "-i", "^\;hostname"), stdin=collectorHostname.stdout)
        #     CollectorHostnameInStr = str(grepCollectorHostname)
        #     CollectorHostnameInStr = CollectorHostnameInStr.strip().split("=")[1]
        # except:
        #     CollectorHostnameInStr = "N/A"

        if avamar_service_status == 'Running':
            avamar_service = 'Running'
        else:
            avamar_service = 'Stopped'

        if avamar_enabled_status == 'Enabled':
            avamar_enabled = 'Enabled'
        else:
            avamar_enabled = 'Disabled'

        if networker_service_status == 'Running':
            networker_service = 'Running'
        else:
            networker_service = 'Stopped'

        if networker_enabled_status == 'Enabled':
            networker_enabled = 'Enabled'
        else:
            networker_enabled = 'Disabled'

        if avamar_service_status == "Running" and networker_service_status == 'Running':
            ifBothRunning = 'True'
        else:
            ifBothRunning = 'False'

        if avamar_enabled_status == "Enabled" and networker_enabled_status == 'Enabled':
            ifBothEnabled = 'True'
        else:
            ifBothEnabled = 'False'

        avamar_data  = {
            "vmname": server_config.hostname,
            "backup_agent_name" : ifBothRunning,
            "backup_agent_service": avamar_service,
            "backup_agent_enabled": avamar_enabled,
            "backup_agent_rpm": package_ver_avamar,
            "backup_agent_version": rpm_v_avamar,
            "networker_agent_rpm": package_ver_networker,
            "networker_agent_version": rpm_v_networker,
            "networker_agent_service": networker_service,
            "networker_agent_enabled": networker_enabled
        }
        return avamar_data


testData = avamarInfo()
print(testData.get_avamar_info())
