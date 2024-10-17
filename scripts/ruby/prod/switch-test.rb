#!/usr/bin/ruby

require  'infoblox'
require 'uri'
require 'json'
require 'getoptlong'
require 'highline/import'

# Only 1 Argument is allowed 

if ARGV.length != 1
  puts "Please use only One Option  i.e. switch_cstg --WDC|SC2"
  exit 0
end

# HTTP POST/GET Debug Logs 


# Defining address Local variable with nil. Local variables do not, like globals and instance variables, have the value nil before initialization. :)

address = nil
oadress = nil
# New Help Object 

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--WDC', '-W', GetoptLong::NO_ARGUMENT ],
  [ '--SC2', '-S', GetoptLong::NO_ARGUMENT ],
)

opts.each do |opt|
  case opt
    when '--help'
      puts <<-EOF

switch_cstg --WDC|SC2

-h, --help:
   show help

--WDC, -W:
   Switch to MyVMWARE WDC IP

--SC2, -S:
   Switch to MyVMWARE SC2 IP
      EOF
      exit 
    when '--WDC'
        exit unless HighLine.agree("This will Update DNS for my-cstg.vmware.com to WDC 10.128.141.14 Do you want to proceed?  \"yes|y\" or \"no|n")
        address = '10.128.141.14' 
        oadress = '10.188.240.18'
    when '--SC2'
        exit unless HighLine.agree("This will Update DNS for my-cstg.vmware.com to SC2 10.188.240.18 Do you want to proceed?  \"yes|y\" or \"no|n")
        address = '10.188.240.18'
        oadress = '10.128.141.14'
    else 
          puts "Please try Options. switch_cstg.rb --SC2|--WDC "
          exit
  end
end

# To make sure address has some value. Else Exit !
if address.nil?
  puts "Please try Options. ./switch_cstg.rb --SC2|--WDC "
  exit
end

#puts "#{oadress} #{address}"
#ADDRESS = address
#puts "Hi #{ADDRESS}"
#exit




connection = Infoblox::Connection.new(username: 'apistg', password: 'Nss@myvmware!', host: 'ib-cp-sjc5.vmware.com', ssl_opts: {verify: false})#,logger: Logger.new(STDOUT))

a_record = Infoblox::Arecord.find(connection, {
  name:    'my-cstg-test.mystgswitch.vmware.com', 
  ipv4addr: "#{oadress}"
}).first
a_record.name     = 'my-cstg-test.mystgswitch.vmware.com'
a_record.ipv4addr = "#{address}"
a_record.ttl      = 60
a_record.view     = nil
a_record.put
