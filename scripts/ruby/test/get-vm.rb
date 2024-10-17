require 'rubygems'
require 'rbvmomi'
require 'httparty'
require 'pry'


base_uri = "https://vc-dev-1.vmware.com"


# puts "Enter VM Name"
# vm_name = gets.chomp
vm_name='entl-lt-rac3'
#puts "======Connecting to #{base_uri}======"

auth1 = {:username	=> 'adm.kdwivedi', :password =>''}
auth = HTTParty.post("#{base_uri}/rest/com/vmware/cis/session", :basic_auth => auth1, :verify => false)

puts "======listing details for #{vm_name}======"
vm1 = auth.to_s
a1 = JSON.parse(vm1)
header = {}
header["Content-Type"]  = 'application/json' 
header["Accept"] = 'application/json'
header["vmware-api-session-id"] = a1['value']

list_vm = base_uri + "/rest/vcenter/vm?filter.names=#{vm_name}"


@response = HTTParty.get(list_vm, headers: header, verify: false)
	# if @response["value"] == []
 #    	return @response
 #    end


vm_obj_id = @response["value"][0]["vm"]


@vm_details  = HTTParty.get("#{base_uri}/rest/vcenter/vm/#{vm_obj_id}", headers: header, verify: false)
binding.pry


 Dvd = @vm_details["value"]["cdroms"][0]["value"]["start_connected"]
 memory = @vm_details["value"]["memory"]["size_MiB"]
 memory_ha = @vm_details["value"]["memory"]["hot_add_enabled"]
 #Disks

  disks = @vm_details["value"]["disks"]




puts "DVD Connected = #{Dvd}"
puts "Memory = #{memory/1024} GB , Hot ADD Enabled = #{memory_ha}"
puts "==Disk Detatils=="
disks.reverse.each do |disk|
	puts "Size => #{disk["value"]["capacity"]/(1024*1024*1024)} GB, label => #{disk["value"]["label"]}, Controller => #{disk["value"]["scsi"]["bus"]}:#{disk["value"]["scsi"]["unit"]}"
end
