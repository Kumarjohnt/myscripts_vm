#Import required modules
import re,csv,sys,json,requests,warnings
from getpass import getpass
from requests.auth import HTTPBasicAuth
from requests.packages.urllib3.exceptions import InsecureRequestWarning
warnings.simplefilter('ignore',InsecureRequestWarning)
from avi.sdk.avi_api import ApiSession



#Variables
user=input("Username: ")
pwd=getpass()
controller_ip = "10.188.117.89"
avi_version = "20.1.4"
tenant = "Corp-GSLB-TNT"
state = sys.argv[1]



#Login Session
login = requests.post('https://'+controller_ip+'/login', data = {'username':user, 'password':pwd}, verify = False)



#Fuction Definition

def gslb_status(gslb):
    gslb_response = requests.get('https://'+controller_ip+'/api/gslbservice', headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False)
    gslb_results = gslb_response.json()['results']
    for i in gslb_results:
        fqdn = i['domain_names'][0]
        if fqdn == gslb:
            ref = i['url']
            gslb_url_response = requests.get(ref, headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False) 
            gslb_url_res = gslb_url_response.json()
            gslb_sc2_pool_name = gslb_url_res['groups'][0]['name']
            gslb_sc2_pool_ip = gslb_url_res['groups'][0]['members'][0]['ip']['addr']
            gslb_sc2_mem_state = gslb_url_res['groups'][0]['members'][0]['enabled']
            gslb_wdc_pool_name = gslb_url_res['groups'][1]['name']
            gslb_wdc_pool_ip = gslb_url_res['groups'][1]['members'][0]['ip']['addr']
            gslb_wdc_mem_state = gslb_url_res['groups'][1]['members'][0]['enabled']
            print("GSLB: ", fqdn)
            print(gslb_sc2_pool_name, "-->", gslb_sc2_pool_ip, "-->", gslb_sc2_mem_state)
            print(gslb_wdc_pool_name, "-->", gslb_wdc_pool_ip, "-->", gslb_wdc_mem_state)
            print("--------------------------------------------------------------------------------------------")
            
            
def gslb_disable_sc2(gslb):
    gslb_response = requests.get('https://'+controller_ip+'/api/gslbservice', headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False)
    gslb_results = gslb_response.json()['results']
    for i in gslb_results:
        fqdn = i['domain_names'][0]
        if fqdn == gslb:
            ref = i['url']
            gslb_url_response = requests.get(ref, headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False) 
            gslb_url_res = gslb_url_response.json()
            gslb_url_res['groups'][0]['members'][0]['enabled'] = False
            final_response = requests.put(ref, data = json.dumps(gslb_url_res), headers = {'Content-Type':'application/json', 'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version, 'X-CSRFToken':login.cookies['csrftoken'], "Referer":"https://10.188.117.89/swagger"}, cookies = dict(sessionid = login.cookies['sessionid'], csrftoken = login.cookies['csrftoken']), params = {'page_size': '-1'}, verify = False)
            final_res = final_response.json()
            final_pool_name = final_res['groups'][0]['name']
            final_pool_ip = final_res['groups'][0]['members'][0]['ip']['addr']
            final_mem_state = final_res['groups'][0]['members'][0]['enabled']
            print(fqdn, "-->", final_response.status_code, "-->", final_pool_name, "-->", final_pool_ip, "-->", final_mem_state)
            print("--------------------------------------------------------------------------------------------")  


def gslb_enable_sc2(gslb):
    gslb_response = requests.get('https://'+controller_ip+'/api/gslbservice', headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False)
    gslb_results = gslb_response.json()['results']
    for i in gslb_results:
        fqdn = i['domain_names'][0]
        if fqdn == gslb:
            ref = i['url']
            gslb_url_response = requests.get(ref, headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False) 
            gslb_url_res = gslb_url_response.json()
            gslb_url_res['groups'][0]['members'][0]['enabled'] = True
            final_response = requests.put(ref, data = json.dumps(gslb_url_res), headers = {'Content-Type':'application/json', 'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version, 'X-CSRFToken':login.cookies['csrftoken'], "Referer":"https://10.188.117.89/swagger"}, cookies = dict(sessionid = login.cookies['sessionid'], csrftoken = login.cookies['csrftoken']), params = {'page_size': '-1'}, verify = False)
            final_res = final_response.json()
            final_pool_name = final_res['groups'][0]['name']
            final_pool_ip = final_res['groups'][0]['members'][0]['ip']['addr']
            final_mem_state = final_res['groups'][0]['members'][0]['enabled']
            print(fqdn, "-->", final_response.status_code, "-->", final_pool_name, "-->", final_pool_ip, "-->", final_mem_state)
            print("--------------------------------------------------------------------------------------------")
                  

def gslb_disable_wdc(gslb):
    gslb_response = requests.get('https://'+controller_ip+'/api/gslbservice', headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False)
    gslb_results = gslb_response.json()['results']
    for i in gslb_results:
        fqdn = i['domain_names'][0]
        if fqdn == gslb:
            ref = i['url']
            gslb_url_response = requests.get(ref, headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False) 
            gslb_url_res = gslb_url_response.json()
            gslb_url_res['groups'][1]['members'][0]['enabled'] = False
            final_response = requests.put(ref, data = json.dumps(gslb_url_res), headers = {'Content-Type':'application/json', 'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version, 'X-CSRFToken':login.cookies['csrftoken'], "Referer":"https://10.188.117.89/swagger"}, cookies = dict(sessionid = login.cookies['sessionid'], csrftoken = login.cookies['csrftoken']), params = {'page_size': '-1'}, verify = False)
            final_res = final_response.json()
            final_pool_name = final_res['groups'][1]['name']
            final_pool_ip = final_res['groups'][1]['members'][0]['ip']['addr']
            final_mem_state = final_res['groups'][1]['members'][0]['enabled']
            print(fqdn, "-->", final_response.status_code, "-->", final_pool_name, "-->", final_pool_ip, "-->", final_mem_state)
            print("--------------------------------------------------------------------------------------------")


def gslb_enable_wdc(gslb):
    gslb_response = requests.get('https://'+controller_ip+'/api/gslbservice', headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False)
    gslb_results = gslb_response.json()['results']
    for i in gslb_results:
        fqdn = i['domain_names'][0]
        if fqdn == gslb:
            ref = i['url']
            gslb_url_response = requests.get(ref, headers = {'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version}, cookies = dict(sessionid = login.cookies['sessionid']), params = {'page_size': '-1'}, verify = False) 
            gslb_url_res = gslb_url_response.json()
            gslb_url_res['groups'][1]['members'][0]['enabled'] = True
            final_response = requests.put(ref, data = json.dumps(gslb_url_res), headers = {'Content-Type':'application/json', 'X-Avi-Tenant':tenant, 'X-Avi-Version':avi_version, 'X-CSRFToken':login.cookies['csrftoken'], "Referer":"https://10.188.117.89/swagger"}, cookies = dict(sessionid = login.cookies['sessionid'], csrftoken = login.cookies['csrftoken']), params = {'page_size': '-1'}, verify = False)
            final_res = final_response.json()
            final_pool_name = final_res['groups'][1]['name']
            final_pool_ip = final_res['groups'][1]['members'][0]['ip']['addr']
            final_mem_state = final_res['groups'][1]['members'][0]['enabled']
            print(fqdn, "-->", final_response.status_code, "-->", final_pool_name, "-->", final_pool_ip, "-->", final_mem_state)
            print("--------------------------------------------------------------------------------------------")

 

#Function Calls:-

with open('gslb_details.csv') as csvfile:
    reader=csv.DictReader(csvfile)
    for row in reader:
        if state == 'status':
            gslb_status(row['gslb'])
        if state == 'disable_sc2':
            gslb_disable_sc2(row['gslb'])
        if state == 'enable_sc2':
            gslb_enable_sc2(row['gslb'])
        if state == 'disable_wdc':
            gslb_disable_wdc(row['gslb'])
        if state == 'enable_wdc':
            gslb_enable_wdc(row['gslb'])
        


#Logout Session
logout = requests.post('https://'+controller_ip+'/logout', headers = {'X-CSRFToken':login.cookies['csrftoken'], 'Referer':'https://'+controller_ip}, cookies = login.cookies, verify = False)

