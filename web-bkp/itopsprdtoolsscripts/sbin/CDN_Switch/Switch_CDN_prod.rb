#!/usr/bin/ruby

# Flow is Login -> Token -> GET Record ID -> Update -> Publish -> Delete Session/ Logout 
# sharmasachin@vmware.com 
# 2 jan 2018


require 'net/https'
require 'uri'
require 'json'
require 'getoptlong'
require 'highline/import'
require 'base64'


# Empty Hash. Please add sites for CDN Resillency in Alphabatic Order

=begin

'site.vmware.com' => {
                        'akamai'          => ' ',
                        'incapsula'       => ' ',
                        'rname'           => ' ',
        },

=end

cdnhash = {
         'appdefense-live.vmware.com' => {
                  'akamai'          => 's751x.vmware.com.edgekey.net.',
                  'incapsula'       => 'iqxicc3.x.incapdns.net.',
                  'rname'           => 'appdefense-live.cdnswitch.vmware.com.',
          },

         'appdefense.vmware.com' => {
                  'akamai'          => 'ta751.vmware.com.ds.edgekey.net.',
                  'incapsula'       => '5s6fwcl.x.incapdns.net.',
                  'rname'           => 'appdefense.cdnswitch.vmware.com.',
          },

          'blogs.vmware.com' => {
                'akamai'          => 'ta751.vmware.com.ds.edgekey.net.',
                'incapsula'        => 'r35g2.x.incapdns.net.',
                'rname'           => 'blogs.cdnswitch.vmware.com.',
        },
       
            'blogs.air-watch.com' => {
                  'akamai'          => 'air-watch.com.edgekey.net.',
                  'incapsula'       => 'l29k7sy.x.incapdns.net.',
                  'rname'           => 'blogs-airwatch.cdnswitch.vmware.com.',

          },
 
          'campaign.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'       => 'hh55x.x.incapdns.net.',
                'rname'           => 'campaign.cdnswitch.vmware.com.',
        },

          'code.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'        => 'exn8e.x.incapdns.net.',
                'rname'            => 'code.cdnswitch.vmware.com.',
        },

           'content.vmwarelearningplatform.com' => {
                  'akamai'          => 's14788x.vmware.com.edgekey.net.',
                  'incapsula'       => 'hx95omf.x.incapdns.net.',
                  'rname'           => 'content-vlp.cdnswitch.vmware.com.',

          },

         'help.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'       => 'uubexfl.x.incapdns.net.',
                'rname'           => 'help.cdnswitch.vmware.com.',
        },

	 'help-stage.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'       => 'wdnitwt.x.incapdns.net.',
                'rname'           => 'help-stage.cdnswitch.vmware.com.',
        },

         'ikb.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'        => 'kxhsdw6.x.incapdns.net.',
                'rname'           => 'ikb.cdnswitch.vmware.com.',
        },
 
          'kb.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'       => 'khmrp.x.incapdns.net.',
                'rname'           => 'kb.cdnswitch.vmware.com.',
        },

        'labs.vmware.com' => {
                'akamai'          => 's751x.vmware.com.edgekey.net.',
                'incapsula'       => '3gdci.x.incapdns.net.',
                'rname'           => 'labs.cdnswitch.vmware.com.',
        },

        'marketplace.vmware.com' => {
                        'akamai'          => 'ta751.vmware.com.ds.edgekey.net.',
                        'incapsula'       => 'yjr6w.x.incapdns.net.',
                        'rname'           => 'marketplace.cdnswitch.vmware.com.',
        },
  
        'my.vmware.com' => {
                'akamai'      => 'ta751.vmware.com.ds.edgekey.net.',
                'incapsula'   => '5alxq.x.incapdns.net.',
                'rname'       => 'my.cdnswitch.vmware.com.',
        },

        'partnerweb.vmware.com' => {
                'akamai'          => 'esd751.vmware.com.ds.edgekey.net.',
                'incapsula'       => '7b23w.x.incapdns.net.',
                'rname'	          => 'partnerweb.cdnswitch.vmware.com.',
        },

        'www.vmware.com' => {
                'akamai'          => 'www.vmware.com.ds.edgekey.net.',
                'incapsula'       => 'k9i8f.x.incapdns.net.',
                'rname'		  => 'www.cdnswitch.vmware.com.',
        },

        'www.air-watch.com' => {
                  'akamai'          => 'air-watch.com.edgekey.net.',
                  'incapsula'       => 'u4v48.x.incapdns.net.',
                  'rname'           => 'www-airwatch.cdnswitch.vmware.com.',
          },

       'www.vmwarelearningplatform.com' => {
                  'akamai'          => 's14788x.vmware.com.edgekey.net.',
                  'incapsula'       => 'tg3y4rb.x.incapdns.net.',
                  'rname'           => 'www-vlp.cdnswitch.vmware.com.',

          }, 

	'learningplatform.vmware.com' => {
                  'akamai'          => 's14788x.vmware.com.edgekey.net.',
                  'incapsula'       => 'ys25ft4.x.incapdns.net.',
                  'rname'           => 'www-lp.cdnswitch.vmware.com.',

          },
	'www.learningplatform.vmware.com' => {
                  'akamai'          => 's14788x.vmware.com.edgekey.net.',
                  'incapsula'       => 'ys25ft4.x.incapdns.net.',
                  'rname'           => 'www-lp.cdnswitch.vmware.com.',

          },

	'content.learningplatform.vmware.com' => {
                  'akamai'          => 's14788x.vmware.com.edgekey.net.',
                  'incapsula'       => 'vt8i7hu.x.incapdns.net.',
                  'rname'           => 'content-lp.cdnswitch.vmware.com.',

          },

########################### CDN Subdomain Hash ###############

        'cloud.vmware.com' => {
                        'akamai'          => 'ta751.vmware.com.ds.edgekey.net.',
                        'incapsula'       => 'b34luge.x.incapdns.net.',
                        'rname'           => 'cloud.cdnswitch.vmware.com.',
        },

        'console.cloud.vmware.com' => {
                        'akamai'          => 'cloud.vmware.com.edgekey.net.',
                        'incapsula'       => 'ab9763m.x.incapdns.net.',
                        'rname'           => 'console-cloud.cdnswitch.vmware.com.',
        },
        
         'form-handler-prd.cloud.vmware.com' => {
                        'akamai'          => 'cloud.vmware.com.edgekey.net.',
                        'incapsula'       => '77k3pd9.x.incapdns.net.',
                        'rname'           => 'form-handler-prd-cloud.cdnswitch.vmware.com.',
        },

        'prd-provider-svc.cloud.vmware.com' => {
                        'akamai'          => 'cloud.vmware.com.edgekey.net.',
                        'incapsula'       => '6b8m97c.x.incapdns.net.',
                        'rname'           => 'prd-provider-svc-cloud.cdnswitch.vmware.com.',
        },

#      'labs.hol.vmware.com' => {
#                        'akamai'          => 'vmwlp.com.edgekey.net.',
#                        'incapsula'       => 'vmwlp.com.edgekey.net.',
#                        'rname'           => 'labs-hol.cdnswitch.vmware.com.',
#        },

        'connect.hcx.vmware.com' => {
                        'akamai'          => 's14749x.vmware.com.edgekey.net.',
                        'incapsula'       => '2jnzvau.x.incapdns.net.',
                        'rname'           => 'connect-hcx.cdnswitch.vmware.com.',
        },


}

# Increasing Scope of Local Variable. Else will be limited to opts Help Object

site = nil
cdn  = nil

if ARGV.length != 2  
  puts <<-EOF
        
        Example ./Switch_CDN.rb --site=code.vmware.com --cdn=akamai

           -h, --help:
           show help

           --site, -s:
           Site Name

          --cdn, -c:
          Change to CDN Akamai or Incapsula
      EOF
   exit 0
end

exit unless HighLine.agree("\nThis will Switch CDN for site.Do you want to proceed?  \"yes|y\" or \"no|n")

# HTTP POST/GET Debug Logs 

$stderr = File.new( '/var/log/cdnswtich-log.log', 'a' )

# New Help Object 

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--site', '-s', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--cdn', '-c', GetoptLong::REQUIRED_ARGUMENT ],
)

opts.each do |opt,arg|
  case opt
    when '--site'
         site = arg 
    when '--cdn'
        if arg == 'akamai' or arg == 'incapsula' 
            cdn = arg
        else 
             puts "Site or CDN is not correct" 
             exit
       end
  end
end 

# Setting Record and Recordvalue from CDN Hash

recordvalue = cdnhash[site][cdn]
rc = cdnhash[site]['rname']

# To make sure address has some value. Else Exit !

if recordvalue.nil? or recordvalue.empty? or rc.nil? or rc.empty?
    puts "Record or Recordvalue seems empty or null."
    exit
end

#puts recordvalue
#puts rc

# Decoding Passwd Hash.

phash = 'NVV5WS5hWHlxRUBZI3khVVQ='
plpass  = Base64.decode64(phash)

# Dyn Api Call's to update CNAME Record 
if __FILE__ == $0
  # Set the desired parameters on the command line 
  CUSTOMER_NAME = 'vmwarecorporate'
  USER_NAME = 'cdnswitchstguser'
  PASSWORD = plpass
  ZONE = 'cdnswitch.vmware.com'
  FQDN = rc 
  ADDRESS = recordvalue
    
  # Set up our HTTP object with the required host and path
  url = URI.parse('https://api2.dynect.net/REST/Session/')
  headers = { "Content-Type" => 'application/json' }
  http = Net::HTTP.new(url.host, url.port)
  http.set_debug_output $stderr
  http.use_ssl = true
  
  # Login and get an authentication token that will be used for all subsequent requests.
  session_data = { :customer_name => CUSTOMER_NAME, :user_name => USER_NAME, :password => PASSWORD }
  
  resp = http.post(url.path, session_data.to_json, headers)
  data = resp.body
  result = JSON.parse(data)
  if result['status'] == 'success'    
  	auth_token = result['data']['token']
  else
    puts "Command Failed:\n"
    # the messages returned from a failed command are a list
    result['msgs'][0].each{|key, value| print key, " : ", value, "\n"}
  end
  # New headers to use from here on with the auth-token set
  headers = { "Content-Type" => 'application/json', 'Auth-Token' => auth_token }

# Get CNAME Record's REcordID. Record id keep chnages after modification. https://api.dynect.net/REST/CNAMERecord/<zone>/<fqdn>/<record_id>/
   url = URI.parse("https://api2.dynect.net/REST/CNAMERecord/#{ZONE}/#{FQDN}/") 
   resp = http.get(url.path, headers)
   data = resp.body
   jsond = JSON.parse(data)
   arec = jsond['data']
   arcstr = arec.to_s
   sptary = arcstr.split("/")
   lemt = sptary.last
   RCDID = lemt.gsub(/[^\d]/, '')

  # Update the CNAME record

  url = URI.parse("https://api2.dynect.net/REST/CNAMERecord/#{ZONE}/#{FQDN}/#{RCDID}/") 
  record_data = { :rdata => { :cname => "#{ADDRESS}" }, :ttl => "60" }
 # To get Record id has to HTTP GET with FQDN. 
 # resp = http.get(url.path, headers)
  resp = http.put(url.path, record_data.to_json, headers)
  print "\n",'PUT ARecord Response: ', resp.body, "\n"; 
  
 
  # Publish the changes
  url = URI.parse("https://api2.dynect.net/REST/Zone/#{ZONE}/") 
  publish_data = { "publish" => "true" }
  resp = http.put(url.path, publish_data.to_json, headers)
  print "\n", 'PUT Zone Response: ', resp.body, "\n"; 
  
  # Logout
  url = URI.parse('https://api2.dynect.net/REST/Session/')
  resp  = http.delete(url.path, headers)
  print "\n", 'DELETE Session Response: ', resp.body, "\n"; 
end

$stderr = STDOUT
