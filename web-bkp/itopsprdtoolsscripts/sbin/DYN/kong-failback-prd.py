#/home/prasad/Python-3.6.1/python

import sys
import json
import httplib2

http = httplib2.Http()
http.force_exception_to_status_code = True

# First do the login and save the session token
token = ""

loginParams = {
'customer_name': 'vmwarecorporate',
'user_name': 'cdnapistguser',
'password': 'y^e.Y^Y2UTuzy^Y.A!U'
}

response, content = http.request('https://api2.dynect.net/REST/Session/', 'POST', json.dumps(loginParams), headers={'Content-type': 'application/json'})
result = json.loads(content)

token = result["data"]["token"]
#print ( token )


args = {
'publish': 'Y',
'eligible': 'true'
}



response, content = http.request('https://api2.dynect.net/REST/DSFRecord/O3u_MFeh4yTnz_pCKpXFNKlh3YE/VTVe3E7WF8g-RobRoP3oUbog6yw/', 'PUT', json.dumps(args), headers={'Content-type': 'application/json', 'Auth-Token':  token})

response, content = http.request('https://api2.dynect.net/REST/DSFRecordSet/O3u_MFeh4yTnz_pCKpXFNKlh3YE/sXrs7pY1DM-TiLXsTNJIT1gcP_8/', 'PUT', json.dumps(args), headers={'Content-type': 'application/json', 'Auth-Token':  token})








