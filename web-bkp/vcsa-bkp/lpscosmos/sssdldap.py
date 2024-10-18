#!/usr/bin/python
#

import subprocess, os
from config import configurations


def adNotWorking(DEVNULL):
    try:
        idOutput = subprocess.check_output(["id", "kabhirup"], stderr=DEVNULL)
    except subprocess.CalledProcessError as grepexc:
        return 1
    return 0
#--------------------------------------------------------------------------------------------------------------#


def onlyContainSssd():

    ifSssdRunning = configurations()

    if ifSssdRunning.check_service_status('sssd') == "Running":
        idProvider = subprocess.Popen(("sudo", "cat", "/etc/sssd/sssd.conf"), stdout=subprocess.PIPE)
        grepIdProvider = subprocess.check_output(("grep", "-i", "^id_provider"), stdin=idProvider.stdout)
        outputInStr = str(grepIdProvider)

        if "ad" in outputInStr.split('=')[1]:
            return "sssd_ad"
        if "ldap" in outputInStr.split('=')[1]:
            return "sssd_ldap"
        return "sssd"
    else:
        pass

    return "Error"
#--------------------------------------------------------------------------------------------------------------#


def onlyContainLdap():

    if os.path.exists("/etc/ldap.conf"):
        catLdap = subprocess.Popen(("sudo", "cat", "/etc/ldap.conf"), stdout=subprocess.PIPE)
    elif os.path.exists("/etc/ldap/ldap.conf"):
        catLdap = subprocess.Popen(("sudo", "cat", "/etc/ldap/ldap.conf"), stdout=subprocess.PIPE)
    elif os.path.exists("/etc/openldap/ldap.conf"):
        catLdap = subprocess.Popen(("sudo", "cat", "/etc/openldap/ldap.conf"), stdout=subprocess.PIPE)
    else:
        return "ldap.conf not present in VM"

    grepUri = subprocess.check_output(("grep", "-i", "^URI"), stdin=catLdap.stdout)
    outputInStr = str(grepUri)[6:-3]
    if ".vmware.com" in outputInStr:
        return "ldap"
    return "Error"
#--------------------------------------------------------------------------------------------------------------#


def sssAuthLdap():
    DEVNULL = open(os.devnull,'wb')
    if adNotWorking(DEVNULL):
        if not (os.path.exists("/etc/sssd/sssd.conf") or os.path.exists("/etc/ldap.conf") or os.path.exists("/etc/ldap/ldap.conf") or os.path.exists("/etc/openldap/ldap.conf")):
            return "local"
        return "Erorr"

    nsswitchOutput = subprocess.check_output(["sudo","grep",  "^passwd:", "/etc/nsswitch.conf"],stderr=DEVNULL)
    outInStr = str(nsswitchOutput)
    DEVNULL.close()

    if " sss" in outInStr and " ldap" in outInStr:
        return "both in nsswitch"
    if " sss" in outInStr:
        return onlyContainSssd()
    if " ldap" in outInStr:
        return onlyContainLdap()
    return "Error"
#--------------------------------------------------------------------------------------------------------------#
