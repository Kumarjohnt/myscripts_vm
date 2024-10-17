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
import re

class configurations:
    def __init__(self):
        self.api_url ='http://cosmos-stg-d1.infra-nprd.vmware.com/api/v1/'
        self.script_version = '3.0'
        self.dmz = 'Trust'
        self.authtype = 'ldap'
        self.dmz_nw = ['10.113.209.253/23', '10.113.211.253/23', '10.16.6.1/24', '10.128.41.253/23', '10.128.43.253/23', '10.128.45.253/24', '10.113.254.13/28', '10.113.254.29/28', '10.128.141.253/24', '10.113.70.126/25', '10.113.78.126/25', '169.254.0.129/29', '10.113.55.254/23', '10.113.63.254/23', '10.132.0.129/29', '10.113.209.253/23', '10.113.208.1/32', '10.113.211.253/23', '10.255.16.134/29', '10.113.254.13/28', '10.113.254.29/28', '10.113.70.126/25', '10.113.78.126/25', '10.113.55.254/23', '10.113.63.254/23','10.128.38.0/24','10.130.64.0/22','10.188.245.0/24','10.188.246.0/24','10.188.247.0/27','10.113.62.0/23','10.113.208.0/23','10.188.244.128/27','10.188.254.48/29','10.81.23.253/22','10.81.25.253/23','10.95.55.253/22','10.95.57.253/23','10.128.141.0/24','10.128.42.0/23','10.128.40.0/23']
        self.update_time = time.strftime("%Y-%m-%d", time.localtime())
        self.hostname = socket.gethostname().split('.', 1)[0]
        self.ipAddress = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.ipAddress.connect(("10.128.10.150", 80))
        self.ipAddress = self.ipAddress.getsockname()[0]
        self.osowner = 'LPS'
        try:
            self.os_rel = platform.linux_distribution()[0].split()[0]
            self.os_version = platform.linux_distribution()[1]
        except:
            import distro
            self.os_rel = distro.linux_distribution()[0].split()[0]
            self.os_version = distro.linux_distribution()[1]
#-----------------------------------------------------------------------------#
##Defining Server Config Function

    def insert_dash(self,string, index):
        return string[:index] + '-' + string[index:]
 
    def uptime(self):
        try:
            f = open( "/proc/uptime" )
            contents = f.read().split()
            f.close()
        except:
            return "Cannot open uptime file: /proc/uptime"

        total_seconds = float(contents[0])

        MINUTE  = 60
        HOUR    = MINUTE * 60
        DAY     = HOUR * 24

        days    = int( total_seconds / DAY )
        hours   = int( ( total_seconds % DAY ) / HOUR )
        minutes = int( ( total_seconds % HOUR ) / MINUTE )
        seconds = int( total_seconds % MINUTE )

        string = ""
        if days > 0:
            string += str(days) + " " + (days == 1 and "day" or "days" ) + ", "
        if len(string) > 0 or hours > 0:
            string += str(hours)  + ":"
        if len(string) > 0 or minutes > 0:
            string += str(minutes)
        return int(days)
 
    def alertmail(self):
        SMTP_SERVER = 'localhost'
        SMTP_PORT = 25
        sender = 'root@localhost'
        recipients = 'ukhalep@vmware.com'
        subject = 'data update failed'
        body = 'service failed'
        headers = ["From: root" ,"Subject: " + subject,"To: " + recipients,"MIME-Version: 1.0","Content-Type: text/html"]
        headers = "\r\n".join(headers)
        session = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        session.ehlo()
        session.sendmail(sender, recipients, headers + "\r\n\r\n" + body)
        session.quit()

    def addressInNetwork(self,ip,net):
        ipaddr = struct.unpack('!L',socket.inet_aton(ip))[0]
        netaddr,bits = net.split('/')
        netaddr = struct.unpack('!L',socket.inet_aton(netaddr))[0]
        netmask = ((1<<(32-int(bits))) - 1)^0xffffffff
        return ipaddr & netmask == netaddr & netmask

 #-----------------------------------------------------------------------------#  
 ##Defining Service config function

    def check_service_status(self,service_name):
        os_ver = int((self.os_version.split('.'))[0])
        if os_ver >= 7:
            status = os.system('systemctl status '+ service_name + ' > /dev/null')
        elif os_ver < 7:
            if service_name == 'vmtoolsd':
                service_name = 'vmware-tools'
            status = os.system('service '+ service_name +  ' status > /dev/null')
        if status == 0:
            return "Running"
        else:
            return "Stopped"

    def check_service_enable(self,service_name):
        os_ver = int((self.os_version.split('.'))[0])
        if os_ver >= 7:
            is_enabled = (subprocess.Popen('systemctl is-enabled '+ service_name, stdout=subprocess.PIPE, shell=True ).stdout.read()).decode('utf-8')
        elif os_ver < 7:
            is_enabled = (subprocess.Popen("chkconfig --list " + service_name + "|awk '{print $5}'", stdout=subprocess.PIPE, shell=True).stdout.read()).decode('utf-8')
        if 'enabled' in  is_enabled or 'on' in is_enabled:
            return "Enabled"
        else:
            return "Disabled"

    def check_rpm_ver(self,rpm_name):
        if self.os_rel == 'Ubuntu':
            rpm_chk = os.system('dpkg -s ' + rpm_name + ' > /dev/null')
            if rpm_chk == 0:
                rpm_ver = (subprocess.Popen("dpkg -s " + rpm_name + " | grep -i version | awk '{print $2}'", stdout=subprocess.PIPE, shell=True).stdout.read()).decode('utf-8').strip()
            else:
                rpm_ver = 'Not Installed'

            if rpm_ver != 'Not Installed':
                if rpm_name == 'cb-psc-sensor':
                    rpm_version = rpm_ver.split('-')[0]
                elif rpm_name == 'epops-agent':
                    rpm_version = rpm_ver.split('-')[0]
                elif rpm_name == 'salt-minion':
                    rpm_version = rpm_ver.split('+')[0]
                elif rpm_name == 'vmware-log-insight-agent':
                    rpm_version = rpm_ver.split('-')[0]
                elif rpm_name == 'avamarclient-debian':
                    rpm_version = rpm_ver.split('-')[0]
                elif rpm_name == 'lgtoclnt':
                    rpm_version = rpm_ver
                elif rpm_name == 'splunkforwarder':
                    rpm_version = rpm_ver
                else:
                    rpm_version = rpm_ver.split('-')[0]
                    rpm_version = re.sub('\D', '', rpm_version)
                try:
                    rpm_version_in = int(rpm_version.replace('.',''))
                except:
                    rpm_version_in = -1
            else:
                rpm_version_in = -1
        else:
            rpm_chk = os.system('rpm -qa  | grep ' +  rpm_name + ' > /dev/null')
            if rpm_chk == 0:
                rpm_ver = (subprocess.Popen("rpm -qa  | grep " + rpm_name, stdout=subprocess.PIPE, shell=True).stdout.read()).decode('utf-8').strip()
            else:
                rpm_ver = 'Not Installed'

            if rpm_ver != 'Not Installed':
                if rpm_name == 'cb-psc-sensor':
                    rpm_version = rpm_ver.split('-')[3]
                elif rpm_name == 'epops-agent':
                    rpm_version = rpm_ver.split('-')[2]
                elif rpm_name == 'salt-minion':
                    rpm_version = rpm_ver.split('-')[2]
                elif rpm_name == 'Log-Insight-Agent':
                    rpm_version = rpm_ver.split('-')[4]
                elif rpm_name == 'avamarclient-debian':
                    rpm_version = rpm_ver.split('-')[0]
                elif rpm_name == 'AvamarClient':
                    rpm_version = rpm_ver.split('-')[1]
                elif rpm_name == 'lgtoclnt':
                    rpm_version = rpm_ver.split('-')[1]
                else:
                    rpm_version = rpm_ver.split('-')[1]
                    rpm_version = re.sub('\D', '', rpm_version)
                try:
                    rpm_version_in = int(rpm_version.replace('.',''))
                except:
                    rpm_version_in = -1
            else:
                rpm_version_in = -1
        return rpm_ver,rpm_version_in
#-----------------------------------------------------------------------------#
## Defining URL Functions

    def post_method(self,curl_cmd):
        log = open('/tmp/status.txt', 'w')
        log.write('End \n')
        print(curl_cmd)
        p = subprocess.Popen(curl_cmd, shell=True, stdout=log, stderr=subprocess.PIPE)
        while True:
            out = (p.stderr.read(1)).decode('utf-8').strip()
            if out == '' and p.poll() != None:
                break
            if out != '':
                sys.stdout.write(out)
                sys.stdout.flush()

        f = open("/tmp/status.txt", "r")
        if not 'HTTPStatusCode: 200' in open('/tmp/status.txt').read():
            print("failed")
                
    def get_token(self):
    #   f = open("/opt/cosmos/file.txt", "r")
        with open('/tmp/status.txt') as f:
            lines = f.readlines()
            ac = lines[0]
            # print(lines[0])
        acc = ac.split(',')[1]
        acce = (acc.replace('}','')).split(':')[1]
        acess = acce.replace('"','')
        access_token = acess.strip()
        return access_token

    def check_os_family(self):
        _os_family = self.os_rel
        for _os in ['AlmaLinux', 'RockyLinux', 'CentOS', 'Oracle', 'OracleLinux', 'Fedora']:
            if _os == _os_family:
                os_family = 'RedHat'
                return os_family
        if 'SUSE' in _os_family:
            os_family = 'SUSE'
            return os_family
        if 'Ubuntu' in _os_family:
            os_family = 'Debian'
            return os_family
        

    def os_version_eol(self, eol_os):
        eol_value = 'NA'
        if self.check_os_family() == 'RedHat':
            os_version_major = int((self.os_version.split('.'))[0])
            if os_version_major <= eol_os:
                eol_value = 'YES' 
        return eol_value

