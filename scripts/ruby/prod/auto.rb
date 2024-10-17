#!/usr/bin/ruby
#########################################################
# This script  auto configures network based on site    #
# Author - core-infra-linux@vmware.com	                #
#########################################################
require 'fileutils'
site = ["vmc" , "sc2"]
vmcgw = '10.58.16.1'
sc2gw = '10.188.245.254'
sc2_src = "/root/Workspace/failover-to-sc2/"
vmc_src = "/root/Workspace/failback-to-vmc/"
vmgw = `/usr/sbin/route -n | grep UG | awk '{print $2}'`.chomp
vmip = `/usr/sbin/ifconfig -a | grep "inet 10" |awk '{print $2}'`
def ntwk(vsite,fsrc)
        puts "\nConfiguring VM for #{vsite} site"
        FileUtils.cp("#{fsrc}/ifcfg-ens192", "/etc/sysconfig/network-scripts/ifcfg-ens192")
        FileUtils.cp("#{fsrc}/resolv.conf", "/etc/resolv.conf")
        FileUtils.cp("#{fsrc}/hosts", "/etc/hosts")
        `/usr/bin/systemctl restart network`
        `ping -c 5 8.8.8.8`
        if $? === 0
                puts "\nSuccessfully configured as #{vsite} VM"
        else
                puts "\nNetwork Configuration for #{vsite} Failed as network is not reachable"
                exit 0
        end
end
#Ping SC2 GW
`/usr/sbin/arping -c5 #{sc2gw}`
sc2resp = $? != 0

#Ping VMC GW
`/usr/sbin/arping -c5 #{vmcgw}`
vmcresp = $? != 0

#Ping VM GW
`/usr/sbin/arping -c10 #{vmgw}`
resp = $? != 0

if resp === false
 puts "Network is already configured as per site"

elsif resp === true && vmgw === vmcgw && sc2resp === false
 puts "going to configure as sc2"
 ntwk(site[1],sc2_src)

elsif resp === true && vmgw === sc2gw && vmcresp === false
 puts "going to config as vmc"
 ntwk(site[0], vmc_src)

else
 puts "Nothing to do"

end	
