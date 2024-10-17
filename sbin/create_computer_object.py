#!/usr/bin/env python3
########################################################################################
# Author: Sudhir (vsudhir@vmware.com)
# Date:15-April-2021
# Description: This script creates computer object in Active Directory.

#### TO DO List / Further Enhancements in Consideration ####
# 1. ldapsearch for application and business owner for validatation of user ids
# 2. Try to get Jenkins console for specific build.
# 3. Try to mask the password in script  
# 4. Integrate this script with SSSD puppet module <Work with Priyank>.
#### END of TO DO List / Further Enhancements in Consideration ####

#### Change History Log #####
# V1: Intial release. 
# V2: Added condition to check the computer name length is <= 15 Chars for ENG OU and make the script usage simpler by not enforcing to pass args -n, -o, -a, -b (assigned default values in argparse)   
# V3: Added logic to check existence of computer object before creating computer object, Add logic to wait for 120 seconds and validate that computer object is created successfully. 
# V4: Added logging, replaced if condition with try and except for ad_search_computer(), Introduced main() function, notification . 
# V5: Added feature for passing multiple hostnames.
# V6: Make the validation step as optional so that we don't have to waittime of 120 seconds. 
# V7: Keep the validation from outside of iteration for object creation so that 120 second wait time is not triggered in every iteration. 
#########################################################################################################################################

import sys, json, requests, argparse, smtplib, base64, getpass, ldap3, logging 
from ldap3 import Server, Connection, SUBTREE, BASE, Entry, Attribute
from urllib.parse import urlencode
from tqdm import tqdm
from time import sleep
from datetime import datetime

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s:%(levelname)s:%(name)s:%(message)s')
file_handler = logging.FileHandler('/var/log/automationScripts/create_computer_object.log')
file_handler.setFormatter(formatter)
stream_handler = logging.StreamHandler() #To send log message to console as well. 
stream_handler.setFormatter(formatter)
logger.addHandler(file_handler)
logger.addHandler(stream_handler) #To send log message to console as well.

'''logging.basicConfig(filename='/var/log/automationScripts/create_computer_object.log', level=logger.info,
                    format='%(asctime)s:%(levelname)s:%(name)s:%(message)s')'''

usageText = '''Examples:
1. To create computer object in Corp OU in NASA Region.
   /opt/sbin/create_computer_object.py cbsftp-stg-jscape9 -a myadav -b tleung   

2. To create in Eng OU use -o eng and -r to create in EMEA or APAC.
   /opt/sbin/create_computer_object.py cbsftp-stg-jscape9 -o eng -a myadav -b tleung -r apac 

3. You can pass multiple computer names as arguments using comma seperated values. 
   /opt/sbin/create_computer_object.py cbsftp-stg-jscape9,cbsftp-stg-jscape19 -a myadav -b tleung    

4. To perform computer object creation validation in AD use --do-validation, but enabling this make you wait for 120 seconds.
   /opt/sbin/create_computer_object.py cbsftp-stg-jscape9,cbsftp-stg-jscape19 -a myadav -b tleung --do-validation

INFO: This script sends the logs to console output as well to the log file /var/log/automationScripts/create_computer_object.log' .   
'''
def argParseValidateCompName(compName): ##Not in Use
    logger.info (f'The computer name typed in is {compName}')
    if adOU is "Corp" and len(compName) > 19:
        raise argparse.ArgumentTypeError(
            '\nERROR: Invalid HOSTNAME Length. The hostname must be lesser than or equal to 19 characters length for Corp OU\n')
    elif adOU is "Eng" and len(compName) > 15:
        raise argparse.ArgumentTypeError(
            '\nERROR: Invalid HOSTNAME Length. The hostname must be lesser than or equal to 15 charecters length for Engineering OU\n')
    else:
        logger.info (f'\nSUCCESS: Hostname length validation check is passed for "{hostName}" in {adOU}\n')
        return compName

parser = argparse.ArgumentParser(prog='create_computer_object.py',
                                 description='This script creates computer object in Active Directory',
                                 usage='/opt/sbin/%(prog)s ComputerName [-o {corp,eng}] [-a appOwnerId] [-b bizOwnerId]',
                                 epilog=usageText,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)

parser.add_argument('compName', metavar='ComputerName', type=str, help="Enter the Computer Object Name, Multiple computer names supported using comma as delimiter.")
parser.add_argument('-o', type=str, choices=['corp', 'eng'], default='corp', help="Enter the AD Organization Unit Name, Default is corp. ", required=False)
parser.add_argument('-a', metavar='', type=str, help="Enter App Owner's AD User ID, Default is svc.sssdcomp." , default='svc.sssdcomp' )
parser.add_argument('-b', metavar='', type=str, help="Enter Business Owner's AD User ID, Default is svc.sssdcomp. ", default='svc.sssdcomp' )
parser.add_argument('-r', type=str, choices=['nasa', 'emea', 'apac'], default='nasa', help="Enter Deployment Region for computer object, Default is nasa." )
#parser.add_argument('-d', choices=['eng', 'infra', 'infra-stg', 'infra-nprd', 'infra-dev'], type=str, help="Enter appropriate DNS Suffix, Default is vmware.com.", default='vmware.com' )
parser.add_argument('-d', choices=['eng.vmware.com', 'infra.vmware.com', 'infra-stg.vmware.com', 'infra-nprd.vmware.com', 'infra-dev.vmware.com'], type=str, help="Enter appropriate DNS Suffix, Default is vmware.com.", default='vmware.com')
parser.add_argument("--do-validation", default=False, action="store_true", help="Perform computer object creation validation in AD.")

cmdargs = parser.parse_args()
validation = cmdargs.do_validation
#print(validation)
#if cmdargs.do_validation:
#     print("Do Validation")
#else:
#     print("Don't do Validation")
#print(f"Check that cmdargs.do_something={cmdargs.do_validation} is always a bool.")
hostName = cmdargs.compName
hostNameList = hostName.split(",")
adOU = cmdargs.o.capitalize() 
appOwner = cmdargs.a
bizOwner = cmdargs.b
deployRegion = cmdargs.r.upper()
dnsSuffix = cmdargs.d
#dnsSuffix = cmdargs.d + '.vmware.com' if cmdargs.d != "vmware.com" else cmdargs.d
#dnsSuffix = 'vmware.com'
divisionName = "Corporate" if adOU == "Corp" else 'Engineering'
EADDRESS = 'vsudhir@vmware.com'
ESRV = 'smtp.vmware.com'
loginUser = getpass.getuser()
LDAP_SERVER = "sc2-ad-vip.vmware.com"
BASE_DN = 'dc=vmware,dc=com'
ATTRS = ["canonicalName", "cn", "location", "division", "whenCreated"]
SERVICE_USER="svc.sssdcomp"
SERVICE_PASSWORD="1YeBn95.2bDqLU2.^!."
cTime= datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def validateHostnameLength(computerName):
    ''' The Active Directory / Active Role server impose a restriction to have the computer object name length to be lesser than or equal to 19 characters length,
    this function validates this prerequisite'''
    logger.info(f"^^^^STAGE-1 Inside function validateHostnameLength({computerName})^^^^")
    logger.info(f'Checking if the hostname length for "{computerName}" is less than 20?')
    computerNameLen = len(computerName)
    logger.info(f'The length of the hostname "{computerName}" is {computerNameLen}')
    if adOU == "Corp":
        if len(computerName) > 19:
            logger.info ('ERROR: Invalid HOSTNAME Length. The hostname must be lesser than or equal to 19 charecters length for Corp OU')
            sys.exit()
        else:
            logger.info (f'Hostname length validation PASSED for "{computerName}" in Corp OU')
    elif adOU == "Eng":
        if len(computerName) > 15:
            logger.info ('ERROR: Invalid HOSTNAME Length. The hostname must be lesser than or equal to 15 charecters length for Engineering OU\n')
            sys.exit()
        else:
            logger.info (f'SUCCESS: Hostname length validation check is passed for "{computerName}" in Eng OU')

def ad_search_computer(computerName):
    logger.info(f"^^^^STAGE-2 Inside Function ad_search_computer({computerName})^^^^")
    FILTER = f"(&(objectclass=computer)(cn={computerName}))"
    ad_conn = Connection('sc2-ad-vip.vmware.com', user=SERVICE_USER, password=SERVICE_PASSWORD) # Instantiating ldap3 Connection Object to AD
    try:
        logger.info(f'Trying to perform LDAP bind to sc2-ad-vip.vmware.com')
        ad_conn.bind()  #Try Connection bind to AD
    except Exception as e:
        logger.info(e)
    else: #If AD connection bind is success then perform the search for computer object. 
        logger.info(f'AD LDAP bind to sc2-ad-vip.vmware.com is SUCCESS')
        logger.info(f'Checking if computer object {computerName} already exist in Active Directory?')  
        (ad_conn.search(search_base=BASE_DN, search_filter=FILTER, search_scope=SUBTREE, attributes = ATTRS, size_limit=0))
        logger.info(f' {ad_conn.entries} ')
        if computerName in str(ad_conn.entries):
            logger.info (f"Computer Name '{computerName}' EXIST in Active Directory.")
            return True
        else:
            logger.info (f"Computer Name '{computerName}' DO NOT EXIST in Active Directory")
            return False
    finally: #Unbind connection to AD
        ad_conn.unbind()

def notification(computerName):
    with smtplib.SMTP(ESRV) as smtp:
        subject = f'LinuxAutomation:-Computer object creation for {computerName} initiated by {loginUser}'
        body = f'Computer object creation for {computerName} initiated by {loginUser} at {cTime}'
        msg = f'Subject: {subject}\n\n{body}'
        smtp.sendmail(EADDRESS, EADDRESS, msg)

def createComputerObject(computerName):
    logger.info(f"^^^^STAGE-3 Inside Function createComputerObject({computerName})^^^^")
    # This functions submits ARS-ComputerAccountCreation-VMWAREM build job to the Jenkins Server
    adOUlocation = f"OU=Generic,OU=Linux,OU=Servers,OU={adOU},OU=Common,DC=vmware,DC=com"
    logger.info(f"Intiating request to create Computer Object {computerName} in {adOUlocation}")
    jenkinsJobUrl = "https://crdvps-jkm1.vmware.com/job/ARS-ComputerAccountCreation-VMWAREM/build"
    payload = {"parameter": [{"name":"Username", "value":SERVICE_USER}, {"name":"Password", "value":SERVICE_PASSWORD}, {"name":"ParentContainerDN", "value":adOUlocation}, {"name":"ComputerName", "value":computerName}, {"name":"edsvaVMW_BusinessOwner", "value":bizOwner}  , {"name":"edsvaVMW_ApplicationOwner", "value":appOwner}, {"name":"edsvaSecondaryOwners", "value":"g.st.admins.corp.linux"}, {"name":"edsvaVMW_dNSSuffix",   "value":dnsSuffix}, {"name":"division", "value":divisionName}, {"name":"location", "value":deployRegion}, {"name":"edsvaGroupMemberOf", "value":""}]}
    payloadJson = {"json": payload}
    #logger.info(payloadJson)
    payloadUrlEncodeFormat = urlencode(payloadJson)
    logger.info(f"Submitting HTTP POST request to {jenkinsJobUrl}")
    httpPostRequest = requests.post(jenkinsJobUrl,auth=('svc.stgcoredevopsvc', '11d9d83f8ea15dc6a994ce60e9e6f59606'),params=payloadUrlEncodeFormat)
    logger.info(f"HTTP POST RESPONSE STATUS CODE FROM JENKINS is {httpPostRequest.status_code} ")
    if httpPostRequest.status_code == 201:
        logger.info (f'Submitted Computer Object Creation Build Job for {computerName} to Jenkins')
        logger.info (f'Computer Object {computerName} will be created after 120 seconds')
        
    else:
        logger.info ('Error: Please validate arugments once again')
        logger.info ('For help execute the command ./create_computer_object.py -h ')

def compObjectCreationValidation():
    logger.info (f'Checking if --do-validation is set as argument ?')
    if validation:
        logger.info (f'Continuing inside the function compObjectCreationValidation() since --do-validation = {validation}')
        logger.info (f'Starting computer Object Creation Validation')
        logger.info (f'Please WAIT for 150 Seconds.....')
        displayProgressBar(150)
        for computerName in hostNameList:
            if ad_search_computer(computerName) :
                logger.info (f'SUCCESS:Computer Object {computerName} has been created successfully in Active Directory')                
            else:
                logger.info ('ERROR: Something went wrong, please check status in https://crdvps-jkm1.vmware.com/job/ARS-ComputerAccountCreation-VMWAREM/ by selecting latest build number on left pane under the "Build History" section, and select "Console Output" to the see the results \n')
    else:
        logger.info (f'Skipping computer object creation validation since --do-validation = {validation}')
        return

def displayProgressBar(seconds):
    seconds = seconds
    for i in tqdm(range(0, seconds), desc='In Progress:'):
        sleep(1)

def getBuildStatus():
    #curl https://crdvps-jkm1.vmware.com/job/ARS-ComputerAccountCreation-VMWAREM/lastBuild/api/json
    jenkinsJobBuildStatus = "https://crdvps-jkm1.vmware.com/job/ARS-ComputerAccountCreation-VMWAREM/lastBuild/api/json"
    response= requests.get(jenkinsJobBuildStatus,auth=('svc.stgcoredevopsvc', '11d9d83f8ea15dc6a994ce60e9e6f59606'))
    logger.info("\nRESPONSE :")
    logger.info(response)
    logger.info("\nURL : \n" + response.request.url)
    logger.info("\nBODY : " )
    logger.info(response.request.body)
    logger.info("\nHEADERS : " )
    logger.info (response.request.headers)
    logger.info ("\nRESPONSE_TEXT : ")
    logger.info(response.text)

def main ():
    for computerName in hostNameList :
        notification(computerName)
        logger.info (f'____START-Computer object creation for {computerName} initiated by {loginUser}____')
        validateHostnameLength(computerName)
        if not ad_search_computer(computerName) :                      
            createComputerObject(computerName)
        else:
            logger.info ('Try different Computer Name.')            
            sys.exit("Exiting the Program Now")
    
    compObjectCreationValidation()
    logger.info (f'___END-Computer object creation for {computerName} initiated by {loginUser}____')
main()
