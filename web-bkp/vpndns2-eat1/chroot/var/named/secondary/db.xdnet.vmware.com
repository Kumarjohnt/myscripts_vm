$ORIGIN .
$TTL 3600	; 1 hour
xdnet.vmware.com	IN SOA	ib-master1-sjc31.eng.vmware.com. si-admin.vmware.com. (
				46         ; serial
				3600       ; refresh (1 hour)
				900        ; retry (15 minutes)
				2419200    ; expire (4 weeks)
				300        ; minimum (5 minutes)
				)
			NS	ib-ns1-blr3.net.vmware.com.
			NS	ib-ns2-wdc.net.vmware.com.
			NS	ib-ns1-wdc.net.vmware.com.
			NS	ib-ns2-sc2.net.vmware.com.
			NS	ib-ns1-sc2.net.vmware.com.
$ORIGIN xdnet.vmware.com.
apm-proxy		A	10.190.28.14
bugzilla		A	10.190.28.16
bugzilla-biny		A	10.190.28.38
build-squid		A	10.190.28.35
build-stage-web		A	10.190.28.39
buildweb		A	10.190.28.21
engweb			A	10.190.28.22
git			A	10.190.28.23
gitcmd			A	10.190.28.41
gitlab			A	10.190.28.33
gitlab-stage		A	10.190.28.40
gitlab-stage-env	A	10.190.28.37
jenkins			A	10.190.28.34
login			CNAME	apm-proxy
opengrok		A	10.190.28.24
p4web			A	10.190.28.25
perforce		A	10.190.28.26
quality			A	10.190.28.15
racetrack		A	10.190.28.27
resister-sso-user	A	10.190.28.17
reviewboard		A	10.190.28.29
reviewboard-qa		A	10.190.28.28
reviewboard-stage	A	10.190.28.36
sftp2			A	10.190.28.30
vmlibrary		A	10.190.28.31
wiki			A	10.190.28.32
