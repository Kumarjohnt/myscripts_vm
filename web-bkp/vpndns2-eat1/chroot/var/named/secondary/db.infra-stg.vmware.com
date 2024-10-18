$ORIGIN .
$TTL 3600	; 1 hour
infra-stg.vmware.com	IN SOA	ib-master1-sjc31.eng.vmware.com. si-admin.vmware.com. (
				545        ; serial
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
$ORIGIN infra-stg.vmware.com.
cilt-dmz-1		A	10.113.70.17
cilt-dmz-2		A	10.113.70.18
cilt-drtest-intstg	A	10.188.13.106
cilt-drtest-intstg-vmc	A	10.58.27.131
cilt-infrstgdr		A	10.119.32.181
$TTL 30	; 30 seconds
cop-lt-wdc-app1		A	10.128.248.50
cop-lt-wdc-db1		A	10.128.248.51
$TTL 18000	; 5 hours
devops-stg-a12		A	10.188.68.2
devops-stg-a15		A	10.188.68.8
devops-stg-a161		A	10.188.68.9
devops-stg-a162		A	10.188.68.10
devops-stg-a20		A	10.188.68.13
devops-stg-a25		A	10.188.68.15
devops-stg-a26		A	10.188.68.16
$TTL 30	; 30 seconds
dummy			A	10.128.248.1
$TTL 18000	; 5 hours
dummy-stg-sql		A	10.188.68.14
dummy-stg-sql1		A	10.188.68.11
dummy-stg-sql2		A	10.188.68.12
$TTL 300	; 5 minutes
jenkins			A	10.28.116.48
jenkinsci		A	10.128.248.16
$TTL 3600	; 1 hour
k8-master1		A	10.128.95.121
k8-node1		A	10.128.95.122
k8-node2		A	10.128.95.123
$TTL 300	; 5 minutes
linux-stg-app2		A	10.188.68.3
nexus			A	10.28.116.48
$TTL 30	; 30 seconds
puppet6			A	10.128.248.22
$TTL 3600	; 1 hour
srm-test-01		A	10.113.14.61
srm-test-01-vmc		A	10.81.26.4
srmm-test		A	10.113.14.62
test-acl		A	192.168.254.50
