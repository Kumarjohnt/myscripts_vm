#!/usr/bin/ruby
###################################################
# This script configures network based on site    #
# Author - core-infra-linux@vmware.com	          #
# usage  - /root/Workspace/reip.rb <vmsite>       #
###################################################
require 'fileutils'
vmsite = ARGV[0]
sc2_src = "/root/Workspace/failover-to-sc2/"
vmc_src = "/root/Workspace/failback-to-vmc/"

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

if vmsite.nil?
	puts "\nEnter the site sc2/SC2 or vmc/VMC ex: /root/Workspace/reip.rb sc2"

elsif vmsite === "vmc" || vmsite === "VMC" then 
	ntwk(vmsite,vmc_src)

elsif vmsite === "sc2" || vmsite === "SC2" then
	ntwk(vmsite,sc2_src)

else 
	puts "\nPlease enter correct site code sc2|vmc"
end
