#!/usr/bin/ruby
require 'httparty'
uri="https://ib-gm-stg.nsstestlab.com/wapi/v2.5/record:host?name"
puts "enter fqdn"
fqdn = gets.chomp
auth = {:username => "svc.coreinfra_robot", :password => "Vmware@123"}
urL = "#{uri}=#{fqdn}&_return_fields=name&_return_as_object=1"
puts urL
@response = HTTParty.get("#{uri}=#{fqdn}", :basic_auth => auth, :verify => FALSE)
puts @response.to_hash
