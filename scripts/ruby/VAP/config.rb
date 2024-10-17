require 'httparty'
url = "https://10.128.129.230:9000/core/authn/basic"

data = {
  "requestType" : "LOGIN"
  "username" : admin@ucp.local

response = HTTParty.post(url,{ body: { "requestType" : "LOGIN"

