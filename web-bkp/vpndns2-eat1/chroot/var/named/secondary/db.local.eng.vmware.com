$ORIGIN .
$TTL 300	; 5 minutes
local.eng.vmware.com	IN SOA	ns1.eng.vmware.com. si-admin.vmware.com. (
				2017101491 ; serial
				900        ; refresh (15 minutes)
				300        ; retry (5 minutes)
				2419200    ; expire (4 weeks)
				60         ; minimum (1 minute)
				)
			NS	ns1-bcp-eat1.eng.vmware.com.
			NS	ns2-bcp-eat1.eng.vmware.com.
			NS	ns2-ph1-eat.eng.vmware.com.
			NS	ns3-pod3-eat1.eng.vmware.com.
			NS	ns1-pod3-eat1.eng.vmware.com.
			NS	ns1-ph1-eat.eng.vmware.com.
			NS	ns2-pod3-eat1.eng.vmware.com.
			A	10.17.0.20
$ORIGIN local.eng.vmware.com.
$TTL 600	; 10 minutes
ad-ldap			CNAME	wdc-ad-vip.vmware.com.
$TTL 300	; 5 minutes
artifactory		CNAME	sc-prd-build-artifactory.eng.vmware.com.
$ORIGIN artifactory.local.eng.vmware.com.
*			CNAME	sc-prd-artifactory-haproxy-vip.eng.vmware.com.
$ORIGIN local.eng.vmware.com.
bmps			CNAME	sc-prd-scm-bmps001.eng.vmware.com.
bugzilla		CNAME	bugzilla-sc2.vdp.oc.vmware.com.
build-alt-toolchain	CNAME	l3st.wdc-03-isi04.oc.vmware.com.
build-apps		CNAME	l3st.wdc-03-isi04.oc.vmware.com.
build-apps-dynamic	CNAME	wdc-build-isilon02.eng.vmware.com.
build-artifactory	CNAME	sc-prd-build-artifactory.eng.vmware.com.
build-bower-mirror	CNAME	build-bower-mirror101.eng.vmware.com.
$TTL 600	; 10 minutes
build-cache		CNAME	ns-g8-dm30.eng.vmware.com.
$TTL 300	; 5 minutes
build-components	CNAME	build-components-haproxy-vip-ng.eng.vmware.com.
build-download		CNAME	build-download-haproxy-vip-ng.eng.vmware.com.
build-logs		CNAME	mtliaas-build-logs.eng.vmware.com.
build-maven-repo	CNAME	wdc-prd-build-maven-haproxy-vip-ng-a.eng.vmware.com.
$TTL 600	; 10 minutes
build-p4proxy		A	10.206.152.98
$TTL 300	; 5 minutes
build-p4tickets		CNAME	sc-prd-scm-tickets002.eng.vmware.com.
build-packages		CNAME	build-packages101.eng.vmware.com.
build-pgbouncer		CNAME	build-pgbouncer-vip-ng.eng.vmware.com.
build-redis		CNAME	redis-vela-build-core.vela.decc.vmware.com.
build-scripts		CNAME	l3st.wdc-03-isi04.oc.vmware.com.
build-selector		CNAME	build-web-haproxy111.eng.vmware.com.
build-signproxy4	CNAME	w2-build-signproxy4.eng.vmware.com.
build-squid		A	10.225.64.131
			A	10.225.64.133
			A	10.225.64.135
			A	10.225.64.137
$TTL 600	; 10 minutes
build-storage14		CNAME	ns-g8-dm30.eng.vmware.com.
build-storage15		CNAME	ns-g8-dm30.eng.vmware.com.
build-storage16		CNAME	ns-g8-dm30.eng.vmware.com.
build-storage17		CNAME	ns-g8-dm30.eng.vmware.com.
build-storage18		CNAME	ns-g8-dm30.eng.vmware.com.
build-storage19		CNAME	ns-g8-dm30.eng.vmware.com.
build-storage20		CNAME	ns-g8-dm30.eng.vmware.com.
$TTL 300	; 5 minutes
build-storage22		CNAME	releng-pa14.eng.vmware.com.
build-storage23		CNAME	releng-pa15.eng.vmware.com.
build-storage24		CNAME	releng-pa14.eng.vmware.com.
build-storage25		CNAME	releng-pa15.eng.vmware.com.
build-storage26		CNAME	releng-pa14.eng.vmware.com.
build-storage27		CNAME	releng-pa15.eng.vmware.com.
build-storage28		CNAME	releng-pa14.eng.vmware.com.
build-toolchain		CNAME	l3st.wdc-03-isi04.oc.vmware.com.
build-toolchain-dynamic	CNAME	wdc-build-isilon02.eng.vmware.com.
build-toolchain-oracle-java CNAME l3build.wdc-03-isi01.oc.vmware.com.
build-toolshed		CNAME	build-toolshed101.eng.vmware.com.
buildapi		CNAME	build-web-haproxy-vip-ng.eng.vmware.com.
builddb			CNAME	build-pgbouncer-vip-ng.eng.vmware.com.
buildweb		CNAME	build-web-haproxy-vip-ng.eng.vmware.com.
cloud-pxe		A	10.147.244.4
coverity		CNAME	coverity-sc2.eng.vmware.com.
cpbu-logs		CNAME	nvlinas107.eng.vmware.com.
decc-af			CNAME	sc-prd-artifactory-haproxydecc-vip.eng.vmware.com.
$ORIGIN decc-af.local.eng.vmware.com.
*			CNAME	sc-prd-artifactory-haproxydecc-vip.eng.vmware.com.
$ORIGIN local.eng.vmware.com.
decc-graphs		CNAME	decc-hydra-decc-graphs-nsxtvip.decc.vmware.com.
decc-health		CNAME	decc-hydra-decc-health-nsxtvip.decc.vmware.com.
domaindnszones		NS	paengdc01.eng.vmware.com.
$TTL 600	; 10 minutes
engweb			CNAME	engweb-vip-sjc31.eng.vmware.com.
engweb-ipv6		CNAME	engweb-vip-sjc31-ipv6.eng.vmware.com.
$TTL 300	; 5 minutes
esp			CNAME	esp.vela.decc.vmware.com.
$ORIGIN esp.local.eng.vmware.com.
*			CNAME	esp.vela.decc.vmware.com.
$ORIGIN local.eng.vmware.com.
exit15			CNAME	wdc-exit15.eng.vmware.com.
forestdnszones		NS	paengdc01.eng.vmware.com.
git			CNAME	sc-prd-scm-gitlabrails-vip101.eng.vmware.com.
gitlab			CNAME	sc-prd-scm-gitlabrails-vip101.eng.vmware.com.
$ORIGIN gitlabpages.local.eng.vmware.com.
*			CNAME	sc-prd-scm-gitlabpages-vip101.eng.vmware.com.
$ORIGIN local.eng.vmware.com.
gulel			CNAME	gulel-wdc.eng.vmware.com.
machineweb		CNAME	build-web-haproxy-vip-ng.eng.vmware.com.
mts-git			CNAME	wdc-git.eng.vmware.com.
nimbus-pxecache		CNAME	wdc-prd-rdops-pxecache-vip.eng.vmware.com.
nimbus-vmw		CNAME	wdc-prd-nimbus-api.eng.vmware.com.
osm			CNAME	osm.vela.decc.vmware.com.
osspi			CNAME	osspi.vela.decc.vmware.com.
p4swarm			CNAME	sc-prd-scm-swarm003.eng.vmware.com.
p4swarm-it		CNAME	sc-prd-scm-swarm001.eng.vmware.com.
$TTL 600	; 10 minutes
perforce		CNAME	perforce-pri.eng.vmware.com.
perforce-aog		CNAME	perforce-aog-pri.eng.vmware.com.
$TTL 300	; 5 minutes
perforce-bfr1		CNAME	perforce-bfr1-pri.eng.vmware.com.
perforce-bfr2		CNAME	perforce-bfr2-pri.eng.vmware.com.
perforce-bfr3		CNAME	perforce-bfr3-pri.eng.vmware.com.
$TTL 600	; 10 minutes
perforce-bison		CNAME	perforce-bison-pri.eng.vmware.com.
perforce-camel		CNAME	perforce-camel-pri.eng.vmware.com.
perforce-hyena		CNAME	perforce-hyena-pri.eng.vmware.com.
$TTL 300	; 5 minutes
perforce-it		CNAME	perforce-it-pri.eng.vmware.com.
perforce-it-eis		CNAME	perforce-it-eis-pri.eng.vmware.com.
$TTL 600	; 10 minutes
perforce-koala		CNAME	perforce-koala-pri.eng.vmware.com.
$TTL 300	; 5 minutes
perforce-mtsro		CNAME	perforce-mtsro-pri.eng.vmware.com.
$TTL 600	; 10 minutes
perforce-panda		CNAME	perforce-panda-pri.eng.vmware.com.
perforce-puppy		CNAME	perforce-puppy-pri.eng.vmware.com.
perforce-qa		CNAME	perforce-qa-pri.eng.vmware.com.
perforce-releng		CNAME	perforce-releng-pri.eng.vmware.com.
perforce-rhino		CNAME	perforce-rhino-pri.eng.vmware.com.
perforce-shark		CNAME	perforce-shark-pri.eng.vmware.com.
perforce-tiger		CNAME	perforce-tiger-pri.eng.vmware.com.
perforce-toolchain	CNAME	perforce-toolchain-pri.eng.vmware.com.
$TTL 300	; 5 minutes
perforce-toolchain-bfr	CNAME	perforce-toolchain-bfr1.eng.vmware.com.
perforce-toolchain-bfr1	CNAME	perforce-toolchain-bfr1-pri.eng.vmware.com.
$TTL 600	; 10 minutes
perforce-vc		CNAME	perforce-vc-pri.eng.vmware.com.
perforce-viper		CNAME	perforce-viper-pri.eng.vmware.com.
perforce-whale		CNAME	perforce-whale-pri.eng.vmware.com.
perforce-zebra		CNAME	perforce-zebra-pri.eng.vmware.com.
$TTL 300	; 5 minutes
prd-bms-cdn-devhub-vip	CNAME	sc-prd-bms-devhub-vip.eng.vmware.com.
$TTL 600	; 10 minutes
proxy			A	10.114.50.7
$TTL 300	; 5 minutes
releng-pa1		A	10.17.4.40
releng-pa10		A	10.17.4.101
releng-pa11		A	10.17.4.102
releng-pa14		A	10.17.4.93
releng-pa15		A	10.17.4.97
releng-pa2		A	10.17.4.46
releng-pa4		A	10.17.209.22
releng-pa6		A	10.17.4.41
releng-pa7		A	10.17.4.44
releng-pa8		A	10.17.4.45
releng-pa9		A	10.17.4.100
reviewboard		CNAME	reviewboard.vela.decc.vmware.com.
sc-prd-perforce-gobuild-bfr CNAME perforce-bfr2-pri.eng.vmware.com.
sc-prd-perforce-mbs-bfr	CNAME	perforce-bfr1.eng.vmware.com.
scm-commander		CNAME	scm-commander-pri.eng.vmware.com.
scm-fs2			A	10.17.4.42
scm-trees		CNAME	l3st.wdc-03-isi04.oc.vmware.com.
scm-trees-dynamic	CNAME	wdc-build-isilon02.eng.vmware.com.
smb-build-toolchain-dynamic CNAME l3build-smb.wdc-03-isi01.oc.vmware.com.
stg-bms-cdn-devhub-vip	CNAME	sc-stg-bms-devhub-vip.eng.vmware.com.
suite-http		A	10.142.7.107
suite-new		CNAME	suite1-new.eng.vmware.com.
svs			CNAME	sc1-vcd01-prd-svs-vip-web.eng.vmware.com.
symbols			CNAME	build-web-haproxy-vip-ng.eng.vmware.com.
targetmatch		CNAME	tms-core-wdc.hydra.decc.vmware.com.
test-eat1		A	192.168.16.100
