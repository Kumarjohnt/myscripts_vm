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


##this gets the DSF recordset ids based on the label in the pool####
response, content = http.request('https://api2.dynect.net/REST/DSFRecordSet/sZJV94OqneHd1nFyw5EW2BqL0U4/', 'GET', headers={'Content-type': 'application/json', 'Auth-Token':  token})
result3 = json.loads(content)
for x in result3["data"]:
 req = "https://api2.dynect.net"+x
 response, content = http.request(req, 'GET', headers={'Content-type': 'application/json', 'Auth-Token':  token})
 result4 = json.loads(content)
 for y in result4['data']['records']:
  #print ( y['label'])
  if y['label'] == 'sc2-pool-ip':
   dsfrecordsetURI = x
#   print ('dfsrecordseturi is '+dsfrecordsetURI)

##this gets the DSF record ids based on the label in the pool###
response, content = http.request('https://api2.dynect.net/REST/DSFRecord/sZJV94OqneHd1nFyw5EW2BqL0U4/', 'GET', headers={'Content-type': 'application/json', 'Auth-Token':  token})
result5 = json.loads(content)
for x in result5["data"]:
 req = "https://api2.dynect.net"+x
 response, content = http.request(req, 'GET', headers={'Content-type': 'application/json', 'Auth-Token':  token})
 result6 = json.loads(content)
 #print ( result6['data']['label'] )
 if result6['data']['label'] == 'sc2-pool-ip':
  dsfrecordURI = x
#  print ('dfsrecorduri is'+dsfrecordURI)


args = {
'publish': 'Y',
'automation': 'auto_down',
'eligible': 'true'
}
record = 'https://api2.dynect.net'+dsfrecordURI
recordset = 'https://api2.dynect.net'+dsfrecordsetURI

response, content = http.request(record, 'PUT', json.dumps(args), headers={'Content-type': 'application/json', 'Auth-Token':  token})
p = json.loads(content)
print ( 'status of the transaction is:  '+p['status'])

response, content = http.request(recordset, 'PUT', json.dumps(args), headers={'Content-type': 'application/json', 'Auth-Token':  token})
q = json.loads(content)
print ( 'status of the transaction is:  '+q['status'] )
