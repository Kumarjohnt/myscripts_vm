#!/usr/bin/ruby
#########################################################
# This script auto configures DNS based on site         #
# Author - kdwivedi@vmware.com				#
#########################################################
require 'infoblox'
require '/root/workspace/keys/passwd.rb'
site = ["vmc" , "sc2"]
hname = "cilt-infrstgdr.infra-stg.vmware.com"
vmgw = `/usr/sbin/route -n | grep UG | awk '{print $2}'`.chomp
vmdns = `/usr/bin/cat /etc/resolv.conf | grep nameserver | awk 'NR==1{ print $2 }'`.chomp
cplain = passw
def ntwk(vdns,arghname)
        puts "\nChecking DNS"
        curr_ip = `/usr/sbin/ip a s | grep ens  | grep inet | awk '{ print $2 }' | awk -F'/' '{ print $1}'`.chomp
	puts "Current ip is #{curr_ip}"
        `/usr/bin/host #{curr_ip} #{vdns} | grep #{arghname}`
        record_found = $? != 0 #means record not found
        puts "Does #{arghname} needs to be configured with #{curr_ip} ? - #{record_found}"
        if record_found === true
	       		connection = Infoblox::Connection.new(username: 'svc.coreinfra_robot', password: passw, host: 'infoblox.eng.vmware.com', ssl_opts: {verify: false})
               		hostrec = Infoblox::Host.find(connection, {"name~" => "cilt-infrstgdr.infra-stg.vmware.com"}).first
	       		puts hostrec
               		hostrec.ipv4addrs[0].ipv4addr = "#{curr_ip}"
	       		hostrec.put
               		newdnsname = `nslookup #{curr_ip}`
               		puts = "DNS name #{newdnsname}"
			exit 0
        else
               		puts "DNS configuration is correct"
			exit 0
        end
end

#Ping VM GW
`ping -c10 #{vmgw}`
resp = $? != 0


if resp === false
 puts "Network Reachable Checking DNS"
 ntwk(vmdns,hname)

else
 puts "VM is not in network, Please bring VM into network"

end

