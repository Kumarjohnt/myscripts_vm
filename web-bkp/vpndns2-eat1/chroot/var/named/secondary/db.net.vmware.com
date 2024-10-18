$ORIGIN .
$TTL 3600	; 1 hour
net.vmware.com		IN SOA	ib-master1-sjc31.eng.vmware.com. si-admin.vmware.com. (
				4945       ; serial
				3600       ; refresh (1 hour)
				900        ; retry (15 minutes)
				2419200    ; expire (4 weeks)
				300        ; minimum (5 minutes)
				)
			NS	ib-ns2-sc2.net.vmware.com.
			NS	ib-ns1-sc2.net.vmware.com.
			NS	ib-ns1-wdc.net.vmware.com.
			NS	ib-ns2-wdc.net.vmware.com.
			NS	ib-ns1-blr3.net.vmware.com.
$ORIGIN net.vmware.com.
access01-mgmt-sjc05	A	10.188.7.177
access02-mgmt-sjc05	A	10.188.7.176
acsnet1-pao12		CNAME	pao12-sw01-oob01
acsnet1-pao13		CNAME	pao13-sw01-oob01
acsnet2-pao12		CNAME	pao12-sw01-oob21
acsnet2-pao13		CNAME	pao13-sw01-oob21
acsnet3-pao13		CNAME	pao13-sw02-oob01
acsnet4-pao13		CNAME	pao13-sw02-oob21
aduc-dev		A	10.205.70.163
ams04-cs-ca01		A	10.96.128.231
ams04-fw-eg01		A	10.96.128.240
ams04-fw-eg02		A	10.96.128.241
ams04-sd-vce01		A	10.96.136.33
ams04-sw-core01		A	10.96.136.35
ams04-sw-dmz01		A	10.96.128.242
ams04-sw-fp01		A	10.96.128.233
ams04-sw-fp02		A	10.96.128.234
ams04-sw07-av01		A	10.96.128.239
ams04-sw07-ma01		A	10.96.128.237
ams04-sw07-pa01		A	10.96.128.236
ams04-sw07-ua01		A	10.96.128.235
ams04-sw07-wa01		A	10.96.128.238
ams04-wc-lc01		A	10.96.135.130
ams04-wc-lc02		A	10.96.135.131
ams2-esxi01-perimeter-mgmt A	10.27.194.65
ams2-esxi02-perimeter-mgmt A	10.27.194.66
ams2-esxi03-perimeter-mgmt A	10.27.194.67
ams2-esxi04-perimeter-mgmt A	10.27.194.68
ams2-nsxedg-prod-mgr	A	10.27.194.69
ams2-nsxedg-prod-mgr01	A	10.27.194.70
ams2-nsxedg-prod-mgr02	A	10.27.194.71
ams2-nsxedg-prod-mgr03	A	10.27.194.72
arecord1		A	10.148.158.37
arecord2		A	10.148.158.37
atl01-cs01-ca01		A	10.88.40.32
			AAAA	2606:9680:2040:4e20::2001
atl01-cs02-ca01		A	10.88.40.33
			AAAA	2606:9680:2040:4e20::2002
atl01-cs03-ca01		A	10.88.40.34
			AAAA	2606:9680:2040:4e20::2003
atl01-cs04-ca01		A	10.88.40.35
			AAAA	2606:9680:2040:4e20::2004
atl01-cs07-ca01		A	10.88.40.36
			AAAA	2606:9680:2040:4e20::2005
atl01-csdc-ca01		A	10.88.40.29
			AAAA	2606:9680:2040:4e20::2006
atl01-csdca02-ca01	A	10.88.40.40
			AAAA	2606:9680:2040:4e20::2009
atl01-csdcb02-ca01	A	10.88.40.41
			AAAA	2606:9680:2040:4e20::200a
atl01-cstfa-ca01	A	10.88.40.30
			AAAA	2606:9680:2040:4e20::2007
atl01-cstfb-ca01	A	10.88.40.31
			AAAA	2606:9680:2040:4e20::2008
atl01-fw-eg01		A	10.88.14.123
atl01-fw-eg02		A	10.88.14.124
atl01-fw-egp01		A	10.88.14.63
atl01-fw-egp02		A	10.88.14.64
atl01-sw-core01		A	10.84.0.1
atl01-sw-dmz01		A	10.88.40.37
			AAAA	2606:9680:2040:4e20::1
atl01-sw-fp01		A	10.88.40.38
			AAAA	2606:9680:2040:4e20::2
atl01-sw-fp02		A	10.88.40.39
			AAAA	2606:9680:2040:4e20::3
atl01-sw-ma01		A	10.84.0.150
			AAAA	2606:9680:2040:4e20::1001
atl01-sw-ma02		A	10.84.0.160
			AAAA	2606:9680:2040:4e20::1002
atl01-sw00-ua01		A	10.88.40.13
			AAAA	2606:9680:2040:4e20::5001
atl01-sw01-ua01		A	10.88.40.14
			AAAA	2606:9680:2040:4e20::5002
atl01-sw01-ua02		A	10.88.40.15
			AAAA	2606:9680:2040:4e20::5003
atl01-sw01-wa01		A	10.88.40.24
			AAAA	2606:9680:2040:4e20::3001
atl01-sw02-ua01		A	10.88.40.16
			AAAA	2606:9680:2040:4e20::5004
atl01-sw02-wa01		A	10.88.40.25
			AAAA	2606:9680:2040:4e20::3002
atl01-sw03-ua01		A	10.88.40.17
			AAAA	2606:9680:2040:4e20::5005
atl01-sw03-wa01		A	10.88.40.26
			AAAA	2606:9680:2040:4e20::3003
atl01-sw04-ua01		A	10.88.40.18
			AAAA	2606:9680:2040:4e20::5006
atl01-sw04-wa01		A	10.88.40.27
			AAAA	2606:9680:2040:4e20::3004
atl01-sw07-ua01		A	10.88.40.19
			AAAA	2606:9680:2040:4e20::5007
atl01-sw07-ua02		A	10.88.40.20
			AAAA	2606:9680:2040:4e20::5008
atl01-sw07-wa01		A	10.88.40.28
			AAAA	2606:9680:2040:4e20::3005
atl01-swdc-ua01		A	10.88.40.10
			AAAA	2606:9680:2040:4e20::500b
atl01-swdc-wa01		A	10.88.40.21
			AAAA	2606:9680:2040:4e20::3008
atl01-swtfa-ua01	A	10.88.40.11
			AAAA	2606:9680:2040:4e20::5009
atl01-swtfa-wa01	A	10.88.40.22
			AAAA	2606:9680:2040:4e20::3006
atl01-swtfb-ua01	A	10.88.40.12
			AAAA	2606:9680:2040:4e20::500a
atl01-swtfb-wa01	A	10.88.40.23
			AAAA	2606:9680:2040:4e20::3007
atl01-wc-lc01		AAAA	2606:9680:2040:22e0::1
atl01-wc-lc02		AAAA	2606:9680:2040:22e0::2
aus03-wc-lc01		A	10.25.218.130
aus03-wc-lc02		A	10.25.218.131
auth-cstg-ext-sc2-snat-1 A	10.188.246.112
auth-cstg-ext-sc2-snat-2 A	10.188.246.113
auth-cstg-ext-wdc-snat-1 A	10.128.141.60
auth-cstg-ext-wdc-snat-2 A	10.128.141.61
auth-cstg-int-sc2-snat-1 A	10.188.246.114
auth-cstg-int-sc2-snat-2 A	10.188.246.115
auth-cstg-int-wdc-snat-1 A	10.128.141.62
auth-cstg-int-wdc-snat-2 A	10.128.141.63
auth-prd-ext-snat-1	A	10.188.245.214
auth-prd-ext-snat-2	A	10.188.245.215
auth-prd-int-snat-1	A	10.188.245.216
auth-prd-int-snat-2	A	10.188.245.217
av1-1n-pao29-oob	A	10.18.251.186
av1-6f-del2		A	10.119.193.223
			AAAA	2402:740:47:4e20::4001
av1-7f-syd1		A	10.109.166.29
av4-22f-sea2		A	10.62.1.44
avi-blr3-dfgw-vlan1330-selfip A	10.110.133.17
avi-blr3-dfgw-vlan1330-selfip1 A 10.110.133.18
avi-blr3-dfgw-vlan1330-selfip2 A 10.110.133.19
avi-blr3-dfgw-vlan1331-selfip A	10.110.134.5
avi-blr3-dfgw-vlan1331-selfip1 A 10.110.134.6
avi-blr3-dfgw-vlan1331-selfip2 A 10.110.134.7
avi-blr3-dmz-vlan2513-selfip A	10.112.251.44
avi-blr3-dmz-vlan2513-selfip1 A	10.112.251.43
avi-blr3-dmz-vlan2513-selfip2 A	10.112.251.45
avi-blr3-dmz-vlan2515-selfip A	10.112.251.168
avi-blr3-dmz-vlan2515-selfip1 A	10.112.251.164
avi-blr3-dmz-vlan2515-selfip2 A	10.112.251.165
avi-blr3-dmz-vlan500-selfip A	10.5.0.24
avi-blr3-dmz-vlan500-selfip1 A	10.5.0.25
avi-blr3-dmz-vlan500-selfip2 A	10.5.0.26
avi-blr3-int-vlan1330-selfip1 A	10.110.133.21
avi-blr3-int-vlan1330-selfip2 A	10.110.133.22
avi-blr3-int-vlan753-selfip A	10.110.75.82
avi-blr3-int-vlan753-selfip1 A	10.110.75.81
avi-blr3-int-vlan753-selfip2 A	10.110.75.83
avi-controller-atl-oc	A	10.87.144.5
avi-controller-atl-oc-1	A	10.87.144.2
avi-controller-atl-oc-2	A	10.87.144.3
avi-controller-atl-oc-3	A	10.87.144.4
avi-controller-c3po	A	10.21.10.142
avi-controller-c3po-1	A	10.21.10.143
avi-controller-c3po-2	A	10.21.10.144
avi-controller-c3po-3	A	10.21.10.145
avi-controller-fed-sjc5-tkg-prd	A 10.188.164.38
avi-controller-fed-sjc5-tkg-prd-1 A 10.188.164.39
avi-controller-fed-sjc5-tkg-prd-2 A 10.188.164.40
avi-controller-fed-sjc5-tkg-prd-3 A 10.188.164.41
avi-controller-lab	A	10.128.36.195
avi-controller-lab-1	A	10.128.36.192
avi-controller-lab-2	A	10.128.36.193
avi-controller-lab-3	A	10.128.36.194
avi-controller-r2d2	A	10.107.231.19
avi-controller-r2d2-1	A	10.107.231.20
avi-controller-r2d2-2	A	10.107.231.21
avi-controller-r2d2-3	A	10.107.231.22
avi-controller-tas-sc2-1 A	10.187.26.1
avi-eat1-vlan2515-1-selfip A	10.128.242.101
avi-eat1-vlan3889-2-selfip A	10.128.242.102
avi-eat1-vlan3889-3-selfip A	10.128.242.246
avi-eat1-vlan3889-4-selfip A	10.128.242.247
avi-eng-sjc31-gslb-se-1	A	10.166.1.133
avi-eng-sjc31-gslb-se-2	A	10.166.1.134
avi-eng-sjc31-gslb-selfip-1 A	10.166.1.135
avi-eng-sjc31-gslb-selfip-2 A	10.166.1.136
avi-eng-sjc31-se-1	A	10.166.1.131
avi-eng-sjc31-se-2	A	10.166.1.132
avi-eng-sjc31-vlan116-selfip-1 A 10.166.16.15
avi-eng-sjc31-vlan116-selfip-2 A 10.166.16.16
avi-lab-se-dfgw-test-1	A	10.128.36.79
avi-lab-se-dfgw-test-2	A	10.128.36.80
avi-lab-se-dfgw-test-data-1 A	10.128.36.81
avi-lab-se-dfgw-test-data-2 A	10.128.36.82
avi-nprd-gslb-eat1-se-1	A	10.128.213.1
avi-nprd-gslb-eat1-se-2	A	10.128.213.2
avi-nprd-gslb-sjc5-se-1	A	10.188.124.61
avi-nprd-gslb-sjc5-se-2	A	10.188.124.62
avi-nrt1-dmz1-vlan2517-selfip A	10.117.251.113
avi-nrt1-dmz1-vlan2517-selfip-1	A 10.117.251.114
avi-nrt1-dmz1-vlan2517-selfip-2	A 10.117.251.115
avi-nrt1-dmz2-vlan2516-selfip A	10.117.251.73
avi-nrt1-dmz2-vlan2516-selfip-1	A 10.117.251.74
avi-nrt1-dmz2-vlan2516-selfip-2	A 10.117.251.75
avi-nrt1-int-vlan1273-selfip A	10.117.127.46
avi-nrt1-int-vlan1273-selfip-1 A 10.117.127.47
avi-nrt1-int-vlan1273-selfip-2 A 10.117.127.48
avi-pnq1-dmz1-selfip-1	A	10.110.229.20
avi-pnq1-dmz1-selfip-2	A	10.110.229.21
avi-pnq1-dmz2-selfip-1	A	10.110.229.50
avi-pnq1-dmz2-selfip-2	A	10.110.229.51
avi-pnq1-int-selfip-1	A	10.110.227.80
avi-pnq1-int-selfip-2	A	10.110.227.81
avi-poc-controller	A	10.40.142.63
avi-poc-controller1	A	10.40.142.64
avi-poc-controller2	A	10.40.142.65
avi-poc-controller3	A	10.40.142.66
avi-poc-se-data-nic	A	10.40.143.71
			A	10.40.143.72
avi-poc-se1		A	10.40.142.67
avi-poc-se1-selfip	A	10.40.143.64
avi-poc-se2		A	10.40.142.68
avi-poc-se2-selfip	A	10.40.143.65
avi-poc-se3		A	10.40.142.69
avi-poc-se4		A	10.40.142.70
avi-poc-vs		A	10.40.143.68
avi-poc-vs1		A	10.90.20.15
avi-prd-ext-sjc5-vlan2217-selfip-1 A 10.113.63.221
avi-prd-ext-sjc5-vlan2217-selfip-2 A 10.113.63.222
avi-se-1-dmz-blr3	A	10.110.74.137
avi-se-1-int-blr3	A	10.110.74.135
avi-se-2-dfgw-blr3	A	10.110.74.134
avi-se-2-dmz-blr3	A	10.110.74.138
avi-se-2-int-blr3	A	10.110.74.136
avi-se-atl-3a		A	10.84.48.29
avi-se-atl-4a		A	10.84.48.30
avi-se-atl-dmz-1	A	10.87.144.6
avi-se-atl-dmz-2	A	10.87.144.8
avi-se-atl-dmz-dataip-1	A	10.87.144.7
avi-se-atl-dmz-dataip-2	A	10.87.144.9
avi-se-c3po-1		A	10.21.10.146
avi-se-c3po-2		A	10.21.10.147
avi-se-c3po-3		A	10.21.10.148
avi-se-c3po-4		A	10.21.10.149
avi-se-dr-eat1-1	A	10.128.243.66
avi-se-dr-eat1-1-dataip-vlan1000 A 10.188.9.106
avi-se-dr-eat1-1-dataip-vlan1526 A 10.113.60.23
avi-se-dr-eat1-2	A	10.128.243.67
avi-se-dr-eat1-2-dataip-vlan1000 A 10.188.9.234
avi-se-dr-eat1-2-dataip-vlan1526 A 10.113.60.24
avi-se-eat1-1-eth1	A	10.128.42.13
avi-se-eat1-1-eth4	A	10.128.141.8
avi-se-eat1-1-eth5	A	10.128.38.15
avi-se-eat1-1-eth6	A	10.128.45.10
avi-se-eat1-1-eth8	A	10.128.40.12
avi-se-eat1-1-eth9	A	10.128.156.8
avi-se-eat1-1-untrust-1	A	10.128.141.50
avi-se-eat1-1-untrust-2	A	10.128.156.144
avi-se-eat1-1-untrust-3	A	10.128.38.105
avi-se-eat1-1-untrust-4	A	10.128.40.86
avi-se-eat1-1-untrust-5	A	10.128.42.164
avi-se-eat1-1-untrust-6	A	10.128.45.139
avi-se-eat1-1-untrust-7	A	10.130.64.176
avi-se-eat1-2-eth1	A	10.128.40.13
avi-se-eat1-2-eth4	A	10.128.141.9
avi-se-eat1-2-eth5	A	10.128.38.16
avi-se-eat1-2-eth6	A	10.128.45.11
avi-se-eat1-2-eth8	A	10.128.42.14
avi-se-eat1-2-eth9	A	10.128.156.9
avi-se-eat1-2-untrust-1	A	10.128.141.51
avi-se-eat1-2-untrust-2	A	10.128.156.145
avi-se-eat1-2-untrust-3	A	10.128.38.106
avi-se-eat1-2-untrust-4	A	10.128.40.87
avi-se-eat1-2-untrust-5	A	10.128.42.165
avi-se-eat1-2-untrust-6	A	10.128.45.140
avi-se-eat1-2-untrust-7	A	10.130.64.177
avi-se-eat1-3-untrust-1	A	10.128.148.111
avi-se-eat1-3-untrust-2	A	10.128.152.249
avi-se-eat1-3-untrust-3	A	10.128.176.184
avi-se-eat1-3-untrust-4	A	10.130.67.70
avi-se-eat1-3-untrust-5	A	10.200.38.182
avi-se-eat1-4-untrust-1	A	10.128.148.112
avi-se-eat1-4-untrust-2	A	10.128.152.250
avi-se-eat1-4-untrust-3	A	10.128.176.185
avi-se-eat1-4-untrust-4	A	10.130.67.71
avi-se-eat1-4-untrust-5	A	10.200.38.183
avi-se-eat1-5		A	10.128.213.14
avi-se-eat1-5-stg-selfip A	10.128.206.74
avi-se-eat1-5-untrust-1	A	10.128.11.168
avi-se-eat1-5-untrust-10 A	10.128.82.189
avi-se-eat1-5-untrust-11 A	10.128.99.102
avi-se-eat1-5-untrust-12 A	10.130.24.110
avi-se-eat1-5-untrust-13 A	10.130.40.247
avi-se-eat1-5-untrust-14 A	10.130.44.214
avi-se-eat1-5-untrust-2	A	10.128.128.248
avi-se-eat1-5-untrust-3	A	10.128.16.144
avi-se-eat1-5-untrust-4	A	10.128.20.251
avi-se-eat1-5-untrust-5	A	10.128.242.104
avi-se-eat1-5-untrust-7	A	10.128.36.149
avi-se-eat1-5-untrust-8	A	10.128.37.129
avi-se-eat1-5-untrust-9	A	10.128.76.76
avi-se-eat1-6		A	10.128.213.15
avi-se-eat1-6-stg-selfip A	10.128.206.75
avi-se-eat1-6-untrust-1	A	10.128.11.169
avi-se-eat1-6-untrust-10 A	10.128.82.190
avi-se-eat1-6-untrust-11 A	10.128.99.103
avi-se-eat1-6-untrust-12 A	10.130.24.111
avi-se-eat1-6-untrust-13 A	10.130.40.248
avi-se-eat1-6-untrust-14 A	10.130.44.215
avi-se-eat1-6-untrust-2	A	10.128.128.249
avi-se-eat1-6-untrust-3	A	10.128.16.145
avi-se-eat1-6-untrust-4	A	10.128.20.252
avi-se-eat1-6-untrust-5	A	10.128.242.105
avi-se-eat1-6-untrust-7	A	10.128.36.150
avi-se-eat1-6-untrust-8	A	10.128.37.130
avi-se-eat1-6-untrust-9	A	10.128.76.77
avi-se-eat1-7		A	10.128.242.9
avi-se-eat1-7-eth2	A	10.128.40.111
avi-se-eat1-7-eth3	A	10.128.45.142
avi-se-eat1-7-eth4	A	10.128.141.110
avi-se-eat1-7-eth5	A	10.130.64.181
avi-se-eat1-7-eth6	A	10.128.38.147
avi-se-eat1-7-eth7	A	10.128.42.172
avi-se-eat1-7-eth8	A	10.128.242.51
avi-se-eat1-8		A	10.128.242.43
avi-se-eat1-8-eth1	A	10.128.156.147
avi-se-eat1-8-eth2	A	10.128.40.110
avi-se-eat1-8-eth3	A	10.128.45.141
avi-se-eat1-8-eth4	A	10.128.141.109
avi-se-eat1-8-eth5	A	10.130.64.180
avi-se-eat1-8-eth6	A	10.128.38.146
avi-se-eat1-8-eth7	A	10.128.42.171
avi-se-eat1-8-eth8	A	10.128.242.49
avi-se-int-prd2-eat1-1	A	10.128.243.138
avi-se-int-prd2-eat1-2	A	10.128.243.139
avi-se-int-prd2-vlan1524-selfip-1 A 10.113.13.21
avi-se-int-prd2-vlan1524-selfip-2 A 10.113.13.22
avi-se-int-prd2-vlan3883-selfip-1 A 10.128.153.221
avi-se-int-prd2-vlan3883-selfip-2 A 10.128.153.222
avi-se-int-sin3-vlan3-selfip-1 A 10.111.0.161
avi-se-int-sin3-vlan3-selfip-2 A 10.111.0.162
avi-se-int-vmc2-dmz-selfip-1 A	10.81.152.14
avi-se-int-vmc2-dmz-selfip-2 A	10.81.152.15
avi-se-lab-1		A	10.128.36.128
avi-se-lab-2		A	10.128.36.129
avi-se-lab-3		A	10.128.36.121
avi-se-lab-self-ip-1	A	10.128.36.11
avi-se-lab-self-ip-2	A	10.128.36.12
avi-se-lab-self-ip-3	A	10.128.36.96
avi-se-lab-vlan3837-self-ip-1 A	10.128.37.11
avi-se-lab-vlan3837-self-ip-2 A	10.128.37.12
avi-se-lab-vlan3837-self-ip-3 A	10.128.37.94
avi-se-nprd-gslb-eat1-vlan3161-selfip-1	A 10.128.130.91
avi-se-nprd-gslb-eat1-vlan3161-selfip-2	A 10.128.130.92
avi-se-nprd-gslb-sjc5-vlan1010-selfip-1	A 10.188.21.111
avi-se-nprd-gslb-sjc5-vlan1010-selfip-2	A 10.188.21.112
avi-se-nprd-tas-wdc-1	A	10.216.228.9
avi-se-nprd-tas-wdc-2	A	10.216.228.10
avi-se-nprd-tas-wdc-selfip-1 A	10.216.228.11
avi-se-nprd-tas-wdc-selfip-2 A	10.216.228.12
avi-se-onecloud-5	A	10.148.218.214
avi-se-onecloud-5-vlan1612-1 A	10.148.81.106
avi-se-onecloud-5-vlan1612-2 A	10.148.81.107
avi-se-onecloud-5-vlan1652-1 A	10.127.8.184
avi-se-onecloud-5-vlan1652-2 A	10.127.8.185
avi-se-onecloud-5-vlanx1612-1 A	10.148.232.105
avi-se-onecloud-5-vlanx1612-2 A	10.148.232.106
avi-se-onecloud-5-vlanx1652-1 A	10.127.249.206
avi-se-onecloud-5-vlanx1652-2 A	10.127.249.207
avi-se-onecloud-6	A	10.148.218.215
avi-se-ork-int-1	A	10.66.37.25
avi-se-ork-int-2	A	10.66.37.26
avi-se-ork-int-vlan1923-1 A	10.26.196.20
avi-se-ork-int-vlan1923-2 A	10.26.196.19
avi-se-ork-int-vlan1933-1 A	10.26.193.10
avi-se-ork-int-vlan1933-2 A	10.26.193.9
avi-se-ork-int-vlan56-1	A	10.26.169.224
avi-se-ork-int-vlan56-2	A	10.26.169.223
avi-se-ork-int-vlan80-1	A	10.66.37.27
avi-se-ork-int-vlan80-2	A	10.66.37.28
avi-se-perf-self-ip-1	A	10.220.255.253
avi-se-perf-self-ip-2	A	10.220.255.254
avi-se-prd-ext-sjc5-3	A	10.188.119.128
avi-se-prd-ext-sjc5-3-vlan2102-selfip-1	A 10.188.240.51
avi-se-prd-ext-sjc5-3-vlan2102-selfip-2	A 10.188.240.52
avi-se-prd-ext-sjc5-4	A	10.188.119.129
avi-se-prd-ext-sjc5-vlan2107-selfip-1 A	10.188.245.221
avi-se-prd-ext-sjc5-vlan2107-selfip-2 A	10.188.245.222
avi-se-prd-ext-vcsa-eat1-1 A	10.128.242.63
avi-se-prd-ext-vcsa-eat1-2 A	10.128.242.64
avi-se-prd-int-sjc5-3	A	10.188.118.222
avi-se-prd-int-sjc5-3-selfip A	10.188.46.226
avi-se-prd-int-sjc5-4	A	10.188.118.223
avi-se-prd-int-sjc5-4-selfip A	10.188.46.227
avi-se-prd-int-vlan1000-selfip-3 A 10.188.8.231
avi-se-prd-int-vlan1000-selfip-4 A 10.188.8.232
avi-se-prd-int-vlan1022-selfip-3 A 10.188.26.91
avi-se-prd-int-vlan1022-selfip-4 A 10.188.26.92
avi-se-prd-int-vlan1063-selfip-3 A 10.188.192.21
avi-se-prd-int-vlan1063-selfip-4 A 10.188.192.22
avi-se-prd-int-vlan1073-selfip-3 A 10.188.117.15
avi-se-prd-int-vlan1073-selfip-4 A 10.188.117.16
avi-se-prd-int-vlan1074-selfip-1 A 10.188.119.9
avi-se-prd-int-vlan1074-selfip-2 A 10.188.119.10
avi-se-prd-int-vlan1074-selfip-3 A 10.188.119.11
avi-se-prd-int-vlan1074-selfip-4 A 10.188.119.12
avi-se-prd-int-vlan1075-selfip-3 A 10.188.120.31
avi-se-prd-int-vlan1075-selfip-4 A 10.188.120.32
avi-se-prd-int-vlan1076-selfip-3 A 10.188.123.90
avi-se-prd-int-vlan1076-selfip-4 A 10.188.123.91
avi-se-prd-int-vlan1522-selfip-3 A 10.113.76.11
avi-se-prd-int-vlan1522-selfip-4 A 10.113.76.12
avi-se-prd-int-vlan1524-selfip-3 A 10.113.12.11
avi-se-prd-int-vlan1524-selfip-4 A 10.113.12.12
avi-se-prd-int-vlan1526-selfip-3 A 10.113.61.21
avi-se-prd-int-vlan1526-selfip-4 A 10.113.61.22
avi-se-prd-int-vlan1531-selfip-3 A 10.113.161.11
avi-se-prd-int-vlan1531-selfip-4 A 10.113.161.12
avi-se-prd-int-vlan1537-selfip-3 A 10.119.16.231
avi-se-prd-int-vlan1537-selfip-4 A 10.119.16.232
avi-se-prd-int-vlan1542-selfip-3 A 10.119.60.11
avi-se-prd-int-vlan1542-selfip-4 A 10.119.60.12
avi-se-prd-int-vlan1600-selfip-3 A 10.188.13.122
avi-se-prd-int-vlan1600-selfip-4 A 10.188.13.123
avi-se-prd-int-vlan1602-selfip-3 A 10.188.44.41
avi-se-prd-int-vlan1602-selfip-4 A 10.188.44.42
avi-se-prd-int-vlan1902-selfip-3 A 10.113.68.41
avi-se-prd-int-vlan1902-selfip-4 A 10.113.68.42
avi-se-prd-int-vlan1904-selfip-3 A 10.113.15.51
avi-se-prd-int-vlan1904-selfip-4 A 10.113.15.52
avi-se-prd-int-vlan1906-selfip-3 A 10.113.53.81
avi-se-prd-int-vlan1906-selfip-4 A 10.113.53.82
avi-se-prd-int-vlan1909-selfip-3 A 10.119.32.191
avi-se-prd-int-vlan1909-selfip-4 A 10.119.32.192
avi-se-prd-tas-wdc-1	A	10.216.228.15
avi-se-prd-tas-wdc-2	A	10.216.228.16
avi-se-prd-tas-wdc-selfip-1 A	10.216.228.17
avi-se-prd-tas-wdc-selfip-2 A	10.216.228.18
avi-se-r2d2-1		A	10.107.231.24
avi-se-r2d2-2		A	10.107.231.25
avi-se-r2d2-3		A	10.107.231.26
avi-se-r2d2-4		A	10.107.231.27
avi-se-scm-dev-eat-1	A	10.206.155.71
avi-se-scm-dev-eat-2	A	10.206.155.72
avi-se-scm-dev-eat-dataip-1 A	10.206.155.73
avi-se-scm-dev-eat-dataip-2 A	10.206.155.74
avi-se-scm-dev-sc2-1	A	10.182.41.70
avi-se-scm-dev-sc2-2	A	10.182.41.71
avi-se-selfip-dfgw-routing-1 A	10.26.193.7
avi-se-selfip-dfgw-routing-2 A	10.26.193.8
avi-se-sjc31-eth3-floater A	10.166.87.16
avi-se-sjc31-eth4-floater A	10.166.31.121
avi-se-sjc5-1-selfip	A	10.188.46.224
avi-se-sjc5-1-trust-16	A	10.188.12.250
avi-se-sjc5-15-vlan1073-1 A	10.188.117.135
avi-se-sjc5-15-vlan1531-1 A	10.113.161.155
avi-se-sjc5-16-vlan1073-2 A	10.188.117.136
avi-se-sjc5-16-vlan1531-2 A	10.113.161.156
avi-se-sjc5-2-eth6	A	10.188.120.9
avi-se-sjc5-2-selfip	A	10.188.46.225
avi-se-sjc5-2-trust-16	A	10.188.12.251
avi-se-sjc5-5-eth1	A	10.188.124.16
avi-se-sjc5-5-trust-9	A	10.113.160.232
avi-se-sjc5-6-eth1	A	10.188.124.15
avi-se-sjc5-6-trust-9	A	10.113.160.233
avi-se-sjc5-as-1	A	10.113.78.101
avi-se-sjc5-as-2	A	10.113.78.102
avi-se-sjc5-vlan105-selfip-1 A	10.188.194.152
avi-se-sjc5-vlan105-selfip-2 A	10.188.194.153
avi-se-sjc5-vlan1526-selfip-1 A	10.113.61.32
avi-se-sjc5-vlan1526-selfip-2 A	10.113.61.33
avi-se-sof2-daas-dmz-prod-dataip-vlan2502-1 A 10.29.166.13
avi-se-sof2-daas-dmz-prod-dataip-vlan2502-2 A 10.29.166.14
avi-se-sof2-daas-prod-1	A	10.29.168.25
avi-se-sof2-daas-prod-2	A	10.29.168.26
avi-se-sof2-daas-prod-dataip-vlan1000-1	A 10.29.168.28
avi-se-sof2-daas-prod-dataip-vlan1000-2	A 10.29.168.29
avi-se-stg-ext-sjc5-vlan2102-selfip-1 A	10.188.240.15
avi-se-stg-ext-sjc5-vlan2102-selfip-2 A	10.188.240.16
avi-se-stg-ext-sjc5-vlan2107-selfip-1 A	10.188.245.171
avi-se-stg-ext-sjc5-vlan2107-selfip-2 A	10.188.245.172
avi-se-stg-ext-sjc5-vlan2108-selfip-1 A	10.188.246.110
avi-se-stg-ext-sjc5-vlan2108-selfip-2 A	10.188.246.111
avi-se-stg-self-ip-1-vlan2214 A	10.113.70.9
avi-se-stg-self-ip-2-vlan2214 A	10.113.70.10
avi-se-tas-sc2-1	A	10.187.26.3
avi-se-tas-sc2-2	A	10.187.26.4
avi-se-tas-sc2-selfip-1	A	10.187.26.5
avi-se-tas-sc2-selfip-2	A	10.187.26.6
avi-se-vcsa-dmz-vlan42-selfip-1	A 10.128.42.19
avi-se-vcsa-dmz-vlan42-selfip-2	A 10.128.42.20
avi-se-wdc-devtkg1-vlan709-selfip1 A 10.166.125.1
avi-se-wdc-devtkg2-vlan709-selfip2 A 10.166.125.2
avi-se-wdctkg-1-eth3	A	10.200.25.2
avi-se-wdctkg-2-eth3	A	10.200.25.1
avi-se1-dfgw-blr3	A	10.110.74.133
avi-se1-eat1-pod3	A	10.132.16.135
avi-se1-eat1-pod3-vmpublic A	10.145.240.8
avi-se1-eat1-pod3-wdc-pod3-techops A 10.142.7.57
avi-se1-sjc31		A	10.166.1.6
avi-se1-sjc31-eth3	A	10.166.27.8
avi-se1-sjc31-eth5	A	10.166.16.3
avi-se1-ws1-rnd		A	10.126.119.176
avi-se1-ws1-rnd-dataip	A	10.126.119.145
avi-se2-eat1-pod3	A	10.132.16.136
avi-se2-eat1-pod3-vmpublic A	10.145.240.9
avi-se2-eat1-pod3-wdc-pod3-techops A 10.142.7.58
avi-se2-sjc31		A	10.166.1.7
avi-se2-sjc31-eth3	A	10.166.27.9
avi-se2-sjc31-eth5	A	10.166.16.4
avi-se2-ws1-rnd		A	10.126.119.240
avi-se2-ws1-rnd-dataip	A	10.126.119.146
avi-se3-sjc31		A	10.166.1.5
avi-se3-sjc31-eth3	A	10.166.87.14
avi-se3-sjc31-eth4	A	10.166.31.119
avi-se4-sjc31		A	10.166.1.11
avi-se4-sjc31-eth3	A	10.166.87.15
avi-se4-sjc31-eth4	A	10.166.31.120
avi-segrp-prd-ext-sjc5-2-floater A 10.113.63.9
avi-selfip-int-ork-dfwg-1 A	10.26.196.31
avi-selfip-int-ork-dfwg-2 A	10.26.196.32
avi-sin3-dmz1-selfip-1	A	10.107.16.43
avi-sin3-dmz1-selfip-2	A	10.107.16.44
avi-sin3-dmz2-selfip-1	A	10.107.16.60
avi-sin3-dmz2-selfip-2	A	10.107.16.59
avi-sin3-int-selfip-1	A	10.107.16.18
avi-sin3-int-selfip-2	A	10.107.16.19
avi-techops-pod3-se-1	A	10.132.16.65
avi-techops-pod3-se-2	A	10.132.16.66
avi-techops-pod3-vlan72-selfip-1 A 10.142.7.115
avi-techops-pod3-vlan72-selfip-2 A 10.142.7.116
avi-techops-sjc31-vlan-selfip-2	A 10.166.1.62
avi-techops-sjc31-vlan11-selfip-1 A 10.166.1.61
avi-test-selfip		A	10.40.142.72
avi-xdnet-int-se1	A	10.188.9.132
avi-xdnet-int-se2	A	10.188.9.133
avi-xdnet-se1		A	10.190.28.50
avi-xdnet-se2		A	10.190.28.51
avicontroller-apac	A	10.111.0.128
avicontroller1-apac	A	10.111.0.129
avicontroller2-apac	A	10.111.0.130
avicontroller3-apac	A	10.111.0.131
avise-prd-int-vlan1000-selfip1 A 10.188.9.209
avise-prd-int-vlan1000-selfip2 A 10.188.9.211
avise-vlan1046-selfip1	A	10.188.62.20
avise-vlan1046-selfip2	A	10.188.62.21
avise1-ams2-vlan206-selfip-1 A	10.27.190.10
avise1-blr3-int-vlan743-selfip-1 A 10.110.74.158
avise1-dmz-nrt02	A	10.217.194.12
avise1-dmz-nrt1		A	10.117.127.42
avise1-dmz-pnq1		A	10.110.228.17
avise1-dmz-sin3		A	10.107.17.131
avise1-dmz-vmc2-dmz-selfip-1 A	10.81.148.14
avise1-int-blr3		A	10.110.74.181
avise1-int-nrt02	A	10.217.194.10
avise1-int-nrt1		A	10.117.126.17
avise1-int-pnq1		A	10.110.228.35
avise1-int-sin3		A	10.107.17.134
avise1-sjc5-dmz-prod-vlan2102-selfip-1 A 10.188.240.94
avise1-sjc5-dmz-prod-vlan2103-selfip-1 A 10.188.244.177
avise1-sjc5-dmz-prod-vlan2107-selfip-1 A 10.188.245.94
avise1-sjc5-dmz-prod-vlan2108-selfip-1 A 10.188.246.94
avise1-sjc5-dmz-stage-vlan2102-selfip-1	A 10.188.240.126
avise1-sjc5-dmz-stage-vlan2107-selfip-1	A 10.188.245.158
avise1-sjc5-dmz-stage-vlan2201-selfip-1	A 10.113.208.222
avise1-sjc5-dmz-stage-vlan2202-selfip-1	A 10.113.210.94
avise1-sjc5-prod-vlan1011-selfip-1 A 10.188.19.134
avise1-sjc5-prod-vlan105-selfip-1 A 10.188.194.147
avise1-sjc5-prod-vlan1074-selfip-1 A 10.188.118.160
avise1-sjc5-prod-vlan1076-selfip-1 A 10.188.122.238
avise1-sjc5-prod-vlan1602-selfip-1 A 10.188.44.125
avise1-sjc5-stage-vlan105-selfip-1 A 10.188.194.136
avise1-sjc5-stage-vlan1524-selfip-1 A 10.113.12.118
avise1-sjc5-stage-vlan1526-selfip-1 A 10.113.60.124
avise1-sjc5-stage-vlan1542-selfip-1 A 10.119.60.53
avise2-ams2-vlan206-selfip-2 A	10.27.190.11
avise2-blr3-int-vlan743-selfip-2 A 10.110.74.159
avise2-dmz-nrt02	A	10.217.194.13
avise2-dmz-nrt1		A	10.117.127.43
avise2-dmz-pnq1		A	10.110.228.18
avise2-dmz-sin3		A	10.107.17.132
avise2-dmz-vmc2-dmz-selfip-2 A	10.81.148.15
avise2-int-blr3		A	10.110.74.182
avise2-int-nrt02	A	10.217.194.11
avise2-int-nrt1		A	10.117.126.18
avise2-int-pnq1		A	10.110.228.36
avise2-int-sin3		A	10.107.17.135
avise2-sjc5-dmz-prod-vlan2102-selfip-2 A 10.188.240.95
avise2-sjc5-dmz-prod-vlan2103-selfip-2 A 10.188.244.178
avise2-sjc5-dmz-prod-vlan2107-selfip-2 A 10.188.245.95
avise2-sjc5-dmz-prod-vlan2108-selfip-2 A 10.188.246.95
avise2-sjc5-dmz-stage-vlan2102-selfip-2	A 10.188.240.127
avise2-sjc5-dmz-stage-vlan2107-selfip-2	A 10.188.245.159
avise2-sjc5-dmz-stage-vlan2201-selfip-2	A 10.113.208.223
avise2-sjc5-dmz-stage-vlan2202-selfip-2	A 10.113.210.95
avise2-sjc5-prod-vlan1011-selfip-2 A 10.188.19.135
avise2-sjc5-prod-vlan105-selfip-2 A 10.188.194.148
avise2-sjc5-prod-vlan1074-selfip-2 A 10.188.118.161
avise2-sjc5-prod-vlan1076-selfip-2 A 10.188.122.239
avise2-sjc5-prod-vlan1602-selfip-2 A 10.188.44.126
avise2-sjc5-stage-vlan105-selfip-2 A 10.188.194.137
avise2-sjc5-stage-vlan1524-selfip-2 A 10.113.12.119
avise2-sjc5-stage-vlan1526-selfip-2 A 10.113.60.125
avise2-sjc5-stage-vlan1542-selfip-2 A 10.119.60.54
avise3-int-blr3		A	10.110.74.183
avise4-int-blr3		A	10.110.74.184
avise5-int-blr3		A	10.110.74.185
avise6-int-blr3		A	10.110.74.186
aws-mf-fw-eg01		A	10.228.32.19
aws-mf-fw-eg02		A	10.228.32.76
aws-mf-fw-eg03		A	10.228.32.121
aws-mf-fw-eg04		A	10.228.32.131
aws-mf-fw-eg05		A	10.228.32.166
aws-mf-fw-eg06		A	10.228.32.113
aws-mf-fw-eg07		A	10.228.32.14
aws-mf-fw-eg08		A	10.228.32.121
b-dd-sha02		AAAA	2402:740:4048:2410::10
bcn01-wc-lc01		A	10.96.65.130
bcn01-wc-lc02		A	10.96.65.131
bkk01-cs-ca01		AAAA	2402:740:2042:4e20::2001
bkk01-cs17-ca01		A	10.109.219.17
bkk01-fw-egp01		AAAA	2402:740:2042:4e20::4
bkk01-fw-egp02		AAAA	2402:740:2042:4e20::5
bkk01-sd-vce01		A	10.109.219.132
bkk01-sw-core01		A	10.109.219.192
			AAAA	2402:740:2042:4e20:ffff:ffff:ffff:ff7f
bkk01-sw-dmz01		A	10.109.219.14
			AAAA	2402:740:2042:4e20::1
bkk01-sw-fp01		AAAA	2402:740:2042:4e20::2
bkk01-sw-fp02		AAAA	2402:740:2042:4e20::3
bkk01-sw07-va01		AAAA	2402:740:2042:4e20::5002
bkk01-sw07-wa01		AAAA	2402:740:2042:4e20::3001
bkk01-sw17-ua01		A	10.109.219.4
bkk01-sw17-va01		A	10.109.219.5
bkk01-sw17-wa01		A	10.109.219.6
bkk01-wc-lc01		A	10.109.219.9
			AAAA	2402:740:2042:22e0::1
bkk01-wc-lc02		A	10.109.219.10
			AAAA	2402:740:2042:22e0::2
blr02-cs01-ca01		A	10.112.64.145
blr02-cs02-ca01		A	10.112.64.146
blr02-cs02-ca02		A	10.112.64.99
blr02-cs02-ca04		A	10.112.64.150
blr02-cs03-ca01		A	10.112.64.147
blr02-cs04-ca01		A	10.112.64.148
blr02-cs09-ca01		A	10.112.64.149
blr02-sw-core01		A	10.112.95.233
blr02-sw01-ua01		A	10.112.64.249
blr02-sw01-ua02		A	10.112.64.250
blr02-sw01-ua03		A	10.112.64.231
blr02-sw01-va01		A	10.110.43.15
blr02-sw01-wa01		A	10.110.67.77
blr02-sw02-ua01		A	10.112.64.242
blr02-sw02-ua02		A	10.112.64.243
blr02-sw02-va01		A	10.110.43.6
blr02-sw02-wa01		A	10.110.67.73
blr02-sw03-ua01		A	10.112.64.244
blr02-sw03-ua02		A	10.112.64.245
blr02-sw03-va01		A	10.110.43.16
blr02-sw03-wa01		A	10.110.67.76
blr02-sw04-ua01		A	10.112.64.237
blr02-sw04-ua02		A	10.112.64.238
blr02-sw04-va01		A	10.110.43.10
blr02-sw04-va02		A	10.110.43.11
blr02-sw04-wa01		A	10.110.67.74
blr02-sw07-ca01		A	10.112.64.185
blr02-sw07-ua01		A	10.112.64.181
blr02-sw07-ua02		A	10.112.64.182
blr02-sw07-ua03		A	10.112.64.183
blr02-sw07-va01		A	10.110.43.21
blr02-sw07-wa01		A	10.110.67.79
blr02-sw09-ua01		A	10.112.64.247
blr02-sw09-ua02		A	10.112.64.248
blr02-sw09-ua03		A	10.112.64.217
blr02-sw09-va01		A	10.110.43.12
blr02-sw09-va02		A	10.110.43.14
blr02-sw09-wa01		A	10.110.67.75
blr02-wc-lc01		A	10.110.67.70
blr02-wc-lc02		A	10.110.67.71
blr03-fw-egp01		A	10.112.153.209
blr03-fw-egp02		A	10.112.153.210
blr07-cs-ca01		A	10.54.140.131
			AAAA	2402:740:44:4e20::2001
blr07-cs-ca02		A	10.54.140.126
			AAAA	2402:740:44:4e20::2002
blr07-cs02-ca01		A	10.54.140.127
			AAAA	2402:740:44:4e20::2003
blr07-cs03-ca01		A	10.54.140.128
			AAAA	2402:740:44:4e20::2004
blr07-cs04-ca01		A	10.54.140.129
			AAAA	2402:740:44:4e20::2005
blr07-cs05-ca01		A	10.54.140.130
			AAAA	2402:740:44:4e20::2006
blr07-cs06-ca01		AAAA	2402:740:44:4e20::2007
blr07-cs06-ca02		A	10.54.140.132
blr07-cs07-ca01		A	10.54.140.133
			AAAA	2402:740:44:4e20::2008
blr07-cs08-ca01		A	10.54.140.134
			AAAA	2402:740:44:4e20::2009
blr07-cs09-ca01		A	10.54.140.135
			AAAA	2402:740:44:4e20::200a
blr07-cs10-ca01		A	10.54.140.136
			AAAA	2402:740:44:4e20::200b
blr07-cs10-ca02		A	10.54.140.137
			AAAA	2402:740:44:4e20::200c
blr07-cs11-ca01		A	10.54.140.138
			AAAA	2402:740:44:4e20::200d
blr07-fw-cntrx-ing01	A	10.54.140.184
			AAAA	2402:740:44:4e20::7
blr07-fw-egp01		AAAA	2402:740:44:4e20::4
blr07-fw-egp02		AAAA	2402:740:44:4e20::5
blr07-fw-hcl-ing01	A	10.54.140.183
			AAAA	2402:740:44:4e20::6
blr07-lab-ua01		A	10.107.115.252
blr07-sw-core01		A	10.54.147.242
blr07-sw-dmz01		A	10.54.140.189
			AAAA	2402:740:44:4e20::1
blr07-sw-fp01		A	10.54.140.185
			AAAA	2402:740:44:4e20::2
blr07-sw-fp02		A	10.54.140.186
			AAAA	2402:740:44:4e20::3
blr07-sw-opslabcore01	A	10.107.115.254
blr07-sw01-ma01		A	10.54.140.113
			AAAA	2402:740:44:4e20::1001
blr07-sw01-ua01		A	10.54.140.139
			AAAA	2402:740:44:4e20::5001
blr07-sw01-wa01		A	10.54.140.107
			AAAA	2402:740:44:4e20::3001
blr07-sw02-av01		A	10.54.140.159
			AAAA	2402:740:44:4e20::4001
blr07-sw02-av02		A	10.54.140.160
			AAAA	2402:740:44:4e20::4002
blr07-sw02-ma01		A	10.54.140.114
			AAAA	2402:740:44:4e20::1002
blr07-sw02-ua01		A	10.54.140.140
			AAAA	2402:740:44:4e20::5002
blr07-sw02-ua02		A	10.54.140.141
			AAAA	2402:740:44:4e20::5003
blr07-sw02-wa01		A	10.54.140.110
blr07-sw02-wa02		AAAA	2402:740:44:4e20::3002
blr07-sw03-av01		A	10.54.140.161
			AAAA	2402:740:44:4e20::4003
blr07-sw03-av02		A	10.54.140.162
			AAAA	2402:740:44:4e20::4004
blr07-sw03-ma01		A	10.54.140.115
			AAAA	2402:740:44:4e20::1003
blr07-sw03-ua01		A	10.54.140.142
			AAAA	2402:740:44:4e20::5004
blr07-sw03-ua02		A	10.54.140.143
			AAAA	2402:740:44:4e20::5005
blr07-sw03-wa01		A	10.107.75.11
			A	10.54.140.111
			AAAA	2402:740:44:4e20::3003
blr07-sw04-av01		A	10.54.140.163
			AAAA	2402:740:44:4e20::4005
blr07-sw04-av02		A	10.54.140.164
			AAAA	2402:740:44:4e20::4006
blr07-sw04-ma01		A	10.54.140.116
			AAAA	2402:740:44:4e20::1004
blr07-sw04-ua01		A	10.54.140.144
			AAAA	2402:740:44:4e20::5006
blr07-sw04-ua02		A	10.54.140.145
			AAAA	2402:740:44:4e20::5007
blr07-sw04-wa01		A	10.54.140.112
blr07-sw04-wa02		AAAA	2402:740:44:4e20::3004
blr07-sw05-av01		A	10.54.140.165
			AAAA	2402:740:44:4e20::4007
blr07-sw05-av02		A	10.54.140.166
			AAAA	2402:740:44:4e20::4008
blr07-sw05-ma01		A	10.54.140.117
			AAAA	2402:740:44:4e20::1005
blr07-sw05-ua01		A	10.54.140.146
			AAAA	2402:740:44:4e20::5008
blr07-sw05-ua02		A	10.54.140.147
			AAAA	2402:740:44:4e20::5009
blr07-sw05-wa01		A	10.54.140.101
			AAAA	2402:740:44:4e20::3005
blr07-sw06-av01		A	10.54.140.167
			AAAA	2402:740:44:4e20::4009
blr07-sw06-ma01		A	10.54.140.118
			AAAA	2402:740:44:4e20::1006
blr07-sw06-ma02		A	10.54.140.119
			AAAA	2402:740:44:4e20::1007
blr07-sw06-ma03		A	10.54.140.179
			AAAA	2402:740:44:4e20::1008
blr07-sw06-ma04		A	10.54.140.180
			AAAA	2402:740:44:4e20::1009
blr07-sw06-test01	A	10.107.75.252
blr07-sw06-ua01		A	10.54.140.148
			AAAA	2402:740:44:4e20::500a
blr07-sw06-ua02		A	10.54.140.149
			AAAA	2402:740:44:4e20::500b
blr07-sw06-wa01		A	10.54.140.102
			AAAA	2402:740:44:4e20::3006
blr07-sw07-av01		A	10.54.140.168
			AAAA	2402:740:44:4e20::400a
blr07-sw07-av02		A	10.54.140.169
			AAAA	2402:740:44:4e20::400b
blr07-sw07-ma01		A	10.54.140.120
			AAAA	2402:740:44:4e20::100a
blr07-sw07-ua01		A	10.54.140.150
			AAAA	2402:740:44:4e20::500c
blr07-sw07-ua02		A	10.54.140.151
			AAAA	2402:740:44:4e20::500d
blr07-sw07-wa01		A	10.107.75.3
			A	10.54.140.103
			AAAA	2402:740:44:4e20::3007
blr07-sw08-av01		A	10.54.140.170
			AAAA	2402:740:44:4e20::400c
blr07-sw08-av02		A	10.54.140.171
			AAAA	2402:740:44:4e20::400d
blr07-sw08-ma01		A	10.54.140.121
			AAAA	2402:740:44:4e20::100b
blr07-sw08-ua01		A	10.54.140.152
			AAAA	2402:740:44:4e20::500e
blr07-sw08-ua02		A	10.54.140.153
			AAAA	2402:740:44:4e20::500f
blr07-sw08-wa01		A	10.107.75.4
			A	10.54.140.104
			AAAA	2402:740:44:4e20::3008
blr07-sw09-av01		A	10.54.140.172
			AAAA	2402:740:44:4e20::400e
blr07-sw09-av02		A	10.54.140.173
			AAAA	2402:740:44:4e20::400f
blr07-sw09-ma01		A	10.54.140.122
			AAAA	2402:740:44:4e20::100c
blr07-sw09-ua01		A	10.54.140.154
			AAAA	2402:740:44:4e20::5010
blr07-sw09-ua02		A	10.54.140.155
			AAAA	2402:740:44:4e20::5011
blr07-sw09-wa01		A	10.54.140.106
			AAAA	2402:740:44:4e20::3009
blr07-sw10-av01		A	10.107.75.88
			AAAA	2402:740:44:4e20::4010
blr07-sw10-av02		A	10.54.140.174
			AAAA	2402:740:44:4e20::4011
blr07-sw10-av03		A	10.54.140.175
			AAAA	2402:740:44:4e20::4012
blr07-sw10-av04		A	10.54.140.176
			AAAA	2402:740:44:4e20::4013
blr07-sw10-ma01		A	10.54.140.123
			AAAA	2402:740:44:4e20::100d
blr07-sw10-ma02		A	10.54.140.124
			AAAA	2402:740:44:4e20::100e
blr07-sw10-ua01		A	10.54.140.156
			AAAA	2402:740:44:4e20::5012
blr07-sw10-ua02		A	10.54.140.157
			AAAA	2402:740:44:4e20::5013
blr07-sw10-wa01		A	10.54.140.108
			AAAA	2402:740:44:4e20::300a
blr07-sw10-wa02		A	10.54.140.109
			AAAA	2402:740:44:4e20::300b
blr07-sw11-av01		A	10.54.140.177
			AAAA	2402:740:44:4e20::4014
blr07-sw11-av02		A	10.54.140.178
			AAAA	2402:740:44:4e20::4015
blr07-sw11-ma01		A	10.54.140.125
			AAAA	2402:740:44:4e20::100f
blr07-sw11-ua01		A	10.54.140.158
			AAAA	2402:740:44:4e20::5014
blr07-sw11-wa01		A	10.54.140.105
			AAAA	2402:740:44:4e20::300c
blr07-wc-lc01		A	10.54.138.2
			AAAA	2402:740:44:22e0::1
blr07-wc-lc02		A	10.54.138.3
			AAAA	2402:740:44:22e0::2
blr12-cs05-ca01		A	10.205.192.51
			AAAA	2402:740:45:4e20::2003
blr12-cs06-ca01		A	10.205.192.52
			AAAA	2402:740:45:4e20::2002
blr12-cs07-ca01		A	10.205.192.53
			AAAA	2402:740:45:4e20::2001
blr12-fw-eg01		A	10.205.192.3
blr12-fw-eg02		A	10.205.192.4
blr12-fw-egp01		AAAA	2402:740:45:4e20::4
blr12-fw-egp02		AAAA	2402:740:45:4e20::5
blr12-nsx-eg01		A	10.205.192.19
blr12-nsx-eg02		A	10.205.192.20
blr12-rt-ig01		A	10.205.192.57
blr12-rt-ig02		A	10.205.192.58
blr12-rt-mpls01		A	10.22.16.1
blr12-rt-mpls02		A	10.22.16.2
blr12-rt-rr01		A	10.22.16.3
blr12-rt-rr02		A	10.22.16.4
blr12-sd-vce01		A	10.22.16.5
blr12-sw-core01		A	10.22.16.51
			AAAA	2402:740:45:4e20:ffff:ffff:ffff:ff7f
blr12-sw-dmz01		A	10.205.192.2
			AAAA	2402:740:45:4e20::1
blr12-sw-fp01		A	10.205.192.5
			AAAA	2402:740:45:4e20::2
blr12-sw-fp02		A	10.205.192.6
			AAAA	2402:740:45:4e20::3
blr12-sw-lab01		A	10.205.231.249
blr12-sw-lab02		A	10.205.231.250
blr12-sw-lab03		A	10.205.231.248
blr12-sw05-av01		A	10.205.192.28
			AAAA	2402:740:45:4e20::4006
blr12-sw05-av02		A	10.205.192.29
			AAAA	2402:740:45:4e20::4007
blr12-sw05-ma01		A	10.205.192.38
			AAAA	2402:740:45:4e20::1003
blr12-sw05-pa01		A	10.205.192.43
			AAAA	2402:740:45:4e20::6005
blr12-sw05-pa02		A	10.205.192.44
			AAAA	2402:740:45:4e20::6006
blr12-sw05-ua01		A	10.205.192.7
			AAAA	2402:740:45:4e20::5009
blr12-sw05-ua02		A	10.205.192.8
			AAAA	2402:740:45:4e20::500a
blr12-sw05-ua03		A	10.205.192.9
			AAAA	2402:740:45:4e20::500b
blr12-sw05-ua04		A	10.205.192.10
			AAAA	2402:740:45:4e20::500c
blr12-sw05-wa01		A	10.205.192.22
			AAAA	2402:740:45:4e20::3005
blr12-sw06-av01		A	10.205.192.30
			AAAA	2402:740:45:4e20::4004
blr12-sw06-av02		A	10.205.192.34
			AAAA	2402:740:45:4e20::4005
blr12-sw06-ma01		A	10.205.192.39
			AAAA	2402:740:45:4e20::1002
blr12-sw06-pa01		A	10.205.192.45
			AAAA	2402:740:45:4e20::6003
blr12-sw06-pa02		A	10.205.192.46
			AAAA	2402:740:45:4e20::6004
blr12-sw06-ua01		A	10.205.192.11
			AAAA	2402:740:45:4e20::5005
blr12-sw06-ua02		A	10.205.192.12
			AAAA	2402:740:45:4e20::5006
blr12-sw06-ua03		A	10.205.192.13
			AAAA	2402:740:45:4e20::5007
blr12-sw06-ua04		A	10.205.192.14
			AAAA	2402:740:45:4e20::5008
blr12-sw06-wa01		A	10.205.192.23
			AAAA	2402:740:45:4e20::3003
blr12-sw06-wa02		A	10.205.192.25
			AAAA	2402:740:45:4e20::3004
blr12-sw07-av01		A	10.205.192.31
			AAAA	2402:740:45:4e20::4001
blr12-sw07-av02		A	10.205.192.32
			AAAA	2402:740:45:4e20::4002
blr12-sw07-av03		A	10.205.192.33
			AAAA	2402:740:45:4e20::4003
blr12-sw07-ma01		A	10.205.192.40
			AAAA	2402:740:45:4e20::1001
blr12-sw07-pa01		A	10.205.192.47
			AAAA	2402:740:45:4e20::6001
blr12-sw07-pa02		A	10.205.192.48
			AAAA	2402:740:45:4e20::6002
blr12-sw07-ua01		A	10.205.192.15
			AAAA	2402:740:45:4e20::5001
blr12-sw07-ua02		A	10.205.192.16
			AAAA	2402:740:45:4e20::5002
blr12-sw07-ua03		A	10.205.192.17
			AAAA	2402:740:45:4e20::5003
blr12-sw07-ua04		A	10.205.192.18
			AAAA	2402:740:45:4e20::5004
blr12-sw07-wa01		A	10.205.192.24
			AAAA	2402:740:45:4e20::3001
blr12-sw07-wa02		A	10.205.192.26
			AAAA	2402:740:45:4e20::3002
blr12-wc-lc01		A	10.205.192.129
			AAAA	2402:740:45:22e0::1
blr12-wc-lc02		A	10.205.192.130
			AAAA	2402:740:45:22e0::2
blr12-wc-lc03		A	10.205.231.252
blr13-cs00-ca01		A	10.177.216.159
blr13-cs01-ca01		A	10.177.216.168
blr13-cs02-ca01		A	10.177.216.178
blr13-cs03-ca01		A	10.177.216.113
blr13-cs04-ca01		A	10.177.216.114
blr13-cs05-ca01		A	10.177.216.124
blr13-cs06-ca01		A	10.231.75.41
blr13-cs07-ca01		A	10.177.216.143
blr13-cs08-ca01		A	10.177.216.188
blr13-cs09-ca01		A	10.177.216.198
blr13-cs10-ca01		A	10.177.216.208
blr13-cs11-ca01		A	10.177.216.216
blr13-cs12-ca01		A	10.177.216.224
blr13-cs13-ca01		A	10.177.216.232
blr13-cs2g-ca01		A	10.231.75.72
blr13-fw-egp01		A	10.177.219.219
blr13-fw-egp02		A	10.177.219.220
blr13-fw-wl-eg01	A	10.177.216.233
blr13-fw-wl-eg02	A	10.177.216.234
blr13-sw-core01		A	10.177.231.130
blr13-sw-dmz01		A	10.177.216.103
blr13-sw-fp01		A	10.177.216.101
blr13-sw-fp02		A	10.177.216.102
blr13-sw00-av01		A	10.177.216.154
blr13-sw00-av21		A	10.177.216.157
blr13-sw00-ma01		A	10.177.216.153
blr13-sw00-pa01		A	10.177.216.155
blr13-sw00-pa21		A	10.177.216.158
blr13-sw00-ua01		A	10.177.216.162
blr13-sw00-ua21		A	10.177.216.156
blr13-sw01-av01		A	10.177.216.164
blr13-sw01-ma01		A	10.177.216.163
blr13-sw01-pa01		A	10.177.216.165
blr13-sw01-ua01		A	10.177.216.167
blr13-sw01-wa01		A	10.177.216.166
blr13-sw02-av01		A	10.177.216.170
blr13-sw02-av21		A	10.177.216.174
blr13-sw02-ma01		A	10.177.216.169
blr13-sw02-pa01		A	10.177.216.171
blr13-sw02-pa21		A	10.177.216.175
blr13-sw02-ua01		A	10.177.216.173
blr13-sw02-ua21		A	10.177.216.177
blr13-sw02-wa01		A	10.177.216.172
blr13-sw02-wa21		A	10.177.216.176
blr13-sw03-av01		A	10.177.216.106
blr13-sw03-av21		A	10.177.216.110
blr13-sw03-ma01		A	10.177.216.104
blr13-sw03-ma03		A	10.231.75.4
blr13-sw03-pa01		A	10.177.216.107
blr13-sw03-pa21		A	10.177.216.111
blr13-sw03-ua01		A	10.177.216.105
blr13-sw03-ua21		A	10.177.216.109
blr13-sw03-wa01		A	10.177.216.108
blr13-sw03-wa21		A	10.177.216.112
blr13-sw04-av01		A	10.177.216.117
blr13-sw04-av21		A	10.231.75.27
blr13-sw04-ma01		A	10.231.75.21
blr13-sw04-pa01		A	10.231.75.24
blr13-sw04-pa21		A	10.231.75.28
blr13-sw04-ua01		A	10.177.216.115
blr13-sw04-ua21		A	10.177.216.120
blr13-sw04-wa01		A	10.177.216.119
blr13-sw04-wa21		A	10.231.75.29
blr13-sw05-av01		A	10.177.216.133
blr13-sw05-av21		A	10.177.216.130
blr13-sw05-ma01		A	10.177.216.125
blr13-sw05-pa01		A	10.177.216.127
blr13-sw05-pa21		A	10.177.216.131
blr13-sw05-ua01		A	10.177.216.126
blr13-sw05-ua21		A	10.177.216.129
blr13-sw05-wa01		A	10.177.216.128
blr13-sw05-wa21		A	10.177.216.132
blr13-sw06-av01		A	10.177.216.136
blr13-sw06-av21		A	10.177.216.140
blr13-sw06-ma01		A	10.177.216.134
blr13-sw06-pa01		A	10.177.216.137
blr13-sw06-pa21		A	10.177.216.141
blr13-sw06-ua01		A	10.177.216.135
blr13-sw06-ua21		A	10.177.216.139
blr13-sw06-wa01		A	10.177.216.138
blr13-sw06-wa21		A	10.177.216.142
blr13-sw07-av01		A	10.177.216.146
blr13-sw07-av21		A	10.177.216.150
blr13-sw07-ma01		A	10.177.216.144
blr13-sw07-pa01		A	10.177.216.147
blr13-sw07-pa21		A	10.177.216.151
blr13-sw07-ua01		A	10.177.216.145
blr13-sw07-ua21		A	10.177.216.149
blr13-sw07-wa01		A	10.177.216.148
blr13-sw07-wa21		A	10.177.216.152
blr13-sw08-av01		A	10.177.216.180
blr13-sw08-av21		A	10.177.216.184
blr13-sw08-ma01		A	10.177.216.179
blr13-sw08-pa01		A	10.177.216.181
blr13-sw08-pa21		A	10.177.216.185
blr13-sw08-ua01		A	10.177.216.183
blr13-sw08-ua21		A	10.177.216.187
blr13-sw08-wa01		A	10.177.216.182
blr13-sw08-wa21		A	10.177.216.186
blr13-sw09-av01		A	10.177.216.190
blr13-sw09-av21		A	10.177.216.194
blr13-sw09-ma01		A	10.177.216.189
blr13-sw09-pa01		A	10.177.216.191
blr13-sw09-pa21		A	10.177.216.195
blr13-sw09-ua01		A	10.177.216.193
blr13-sw09-ua21		A	10.177.216.197
blr13-sw09-wa01		A	10.177.216.192
blr13-sw09-wa21		A	10.177.216.196
blr13-sw10-av01		A	10.177.216.200
blr13-sw10-av21		A	10.177.216.204
blr13-sw10-ma01		A	10.177.216.199
blr13-sw10-pa01		A	10.177.216.201
blr13-sw10-pa21		A	10.177.216.205
blr13-sw10-ua01		A	10.177.216.203
blr13-sw10-ua21		A	10.177.216.207
blr13-sw10-wa01		A	10.177.216.202
blr13-sw10-wa21		A	10.177.216.206
blr13-sw11-av01		A	10.177.216.210
blr13-sw11-av21		A	10.177.216.213
blr13-sw11-ma01		A	10.177.216.209
blr13-sw11-pa01		A	10.231.75.133
blr13-sw11-pa21		A	10.231.75.137
blr13-sw11-ua01		A	10.177.216.212
blr13-sw11-ua21		A	10.177.216.215
blr13-sw11-wa01		A	10.177.216.211
blr13-sw11-wa21		A	10.177.216.214
blr13-sw12-av01		A	10.177.216.218
blr13-sw12-av21		A	10.177.216.221
blr13-sw12-ma01		A	10.177.216.217
blr13-sw12-pa01		A	10.231.75.143
blr13-sw12-pa21		A	10.231.75.147
blr13-sw12-ua01		A	10.177.216.220
blr13-sw12-ua21		A	10.177.216.223
blr13-sw12-wa01		A	10.177.216.219
blr13-sw12-wa21		A	10.177.216.222
blr13-sw13-av01		A	10.177.216.226
blr13-sw13-av21		A	10.177.216.229
blr13-sw13-ma01		A	10.177.216.225
blr13-sw13-pa01		A	10.231.75.153
blr13-sw13-pa21		A	10.231.75.157
blr13-sw13-ua01		A	10.177.216.228
blr13-sw13-ua21		A	10.177.216.231
blr13-sw13-wa01		A	10.177.216.227
blr13-sw13-wa21		A	10.177.216.230
blr13-sw2g-ma01		A	10.177.216.160
blr13-sw2g-pa01		A	10.177.216.161
blr13-sw2g-pa21		A	10.231.75.77
blr13-wc-lc01		A	10.177.224.2
blr13-wc-lc02		A	10.177.224.3
blr14-fw-cntrx-ing01	A	10.235.252.148
blr14-fw-egp01		A	10.235.252.139
blr14-fw-egp02		A	10.235.252.140
blr14-fw-gss-lab01	A	10.235.252.21
blr14-fw-gss-lab02	A	10.235.252.22
blr14-fw-hcl-ing01	A	10.235.252.147
blr14-sd-vch01		A	10.22.28.13
blr14-sd-vch02		A	10.22.28.14
blr14-sw-gsscore01	A	10.109.51.4
blr14-sw01-wa01		A	10.109.51.61
bom01-cs03-ca01		A	10.120.193.238
bom01-fw-eg01		A	10.120.193.242
bom01-fw-eg02		A	10.120.193.243
bom01-sd-vce01		A	10.120.200.65
bom01-sw-core01		A	10.120.192.1
bom01-sw-dmz01		A	10.120.193.239
bom01-sw-fp01		A	10.120.193.231
bom01-sw-fp02		A	10.120.193.232
bom01-sw03-av01		A	10.120.193.236
bom01-sw03-ua01		A	10.120.193.233
bom01-sw03-ua02		A	10.120.193.234
bom01-sw03-va01		A	10.120.193.235
bom01-sw03-wa01		A	10.120.193.237
bom01-wc-lc01		A	10.120.199.130
bom01-wc-lc02		A	10.120.199.131
bos02-nsx-eg01		A	10.118.251.45
bos02-nsx-eg02		A	10.118.251.46
bos02-sw02-la01		A	10.16.1.161
bos02-sw02-la21		A	10.16.1.162
bos02-sw02-la22		A	10.16.1.163
bos03-fw-egp01		A	10.21.80.14
bos03-fw-egp02		A	10.21.80.15
bos03-fw-scm01		A	10.21.95.169
bos03-fw-scm02		A	10.21.95.170
bos03-sd-vce01		A	10.21.95.215
bos03-sw-fp01		A	10.21.80.16
bos03-sw-fp02		A	10.21.80.17
bos04-cs-ca01		A	10.62.128.151
			AAAA	2606:9680:2041:4e20::2001
bos04-fw-egp01		A	10.62.128.131
			AAAA	2606:9680:2041:4e20::4
bos04-fw-egp02		A	10.62.128.132
			AAAA	2606:9680:2041:4e20::5
bos04-sd-vce01		A	10.62.128.1
bos04-sw-core01		A	10.62.128.190
			AAAA	2606:9680:2041:4e20:ffff:ffff:ffff:ff7f
bos04-sw-dmz01		A	10.62.128.141
			AAAA	2606:9680:2041:4e20::1
bos04-sw-fp01		A	10.62.128.143
			AAAA	2606:9680:2041:4e20::2
bos04-sw-fp02		A	10.62.128.144
			AAAA	2606:9680:2041:4e20::3
bos04-sw20-av01		A	10.62.128.161
			AAAA	2606:9680:2041:4e20::4001
bos04-sw20-av21		A	10.62.128.163
			AAAA	2606:9680:2041:4e20::4002
bos04-sw20-pa01		A	10.62.128.171
			AAAA	2606:9680:2041:4e20::6001
bos04-sw20-ua01		A	10.62.128.155
			AAAA	2606:9680:2041:4e20::5001
bos04-sw20-ua02		A	10.62.128.156
			AAAA	2606:9680:2041:4e20::5002
bos04-sw20-wa01		A	10.62.128.165
			AAAA	2606:9680:2041:4e20::3001
bos04-sw21-av01		A	10.62.128.162
			AAAA	2606:9680:2041:4e20::4003
bos04-sw21-ma01		A	10.62.128.175
			AAAA	2606:9680:2041:4e20::1001
bos04-sw21-pa01		A	10.62.128.172
			AAAA	2606:9680:2041:4e20::6002
bos04-sw21-ua01		A	10.62.128.157
			AAAA	2606:9680:2041:4e20::5003
bos04-sw21-wa01		A	10.62.128.166
			AAAA	2606:9680:2041:4e20::3002
bos04-wc-lc01		A	10.62.129.81
			AAAA	2606:9680:2041:22e0::1
			AAAA	2606:9680:2045:22e0::1
bos04-wc-lc02		A	10.62.129.82
			AAAA	2606:9680:2041:22e0::2
			AAAA	2606:9680:2045:22e0::2
bos07-fw-eg01		A	10.16.1.41
bos07-fw-eg02		A	10.16.1.42
bos07-fw-sc02		A	10.118.251.22
bos07-sd-vce01		A	10.16.0.1
bos07-sw-core01		A	10.16.1.62
bos07-sw-dmz01		A	10.16.1.61
bos07-sw-fp01		A	10.16.1.11
bos07-sw-fp02		A	10.16.1.12
bos07-sw03-ua01		A	10.16.1.21
bos07-sw03-ua02		A	10.16.1.22
bos07-sw03-ua21		A	10.16.1.23
bos07-sw03-ua22		A	10.16.1.24
bos07-sw03-ua31		A	10.16.1.25
bos07-sw03-ua32		A	10.16.1.26
bos07-sw03-ua33		A	10.16.1.27
bos07-sw04-ma01		A	10.16.1.60
bos07-sw04-pa01		A	10.16.1.19
bos07-sw04-ua01		A	10.16.1.28
bos07-sw04-wa01		A	10.16.1.16
bos07-wc-lc01		A	10.16.1.131
bos07-wc-lc02		A	10.16.1.132
bos09-cs-ca01		A	10.62.192.151
			AAAA	2606:9680:2042:4e20::2001
bos09-cs-ca02		A	10.62.192.181
bos09-cs01-ca21		A	10.62.192.152
			AAAA	2606:9680:2042:4e20::2002
bos09-cs02-ca01		A	10.62.192.153
			AAAA	2606:9680:2042:4e20::2003
bos09-cs02-ca21		A	10.62.192.154
			AAAA	2606:9680:2042:4e20::2004
bos09-fw-eg01		A	10.62.192.131
bos09-fw-eg02		A	10.62.192.132
bos09-fw-egp01		AAAA	2606:9680:2042:4e20::4
bos09-fw-egp02		AAAA	2606:9680:2042:4e20::5
bos09-fw-sc01		A	10.62.192.133
			AAAA	2606:9680:2042:4e20::6
bos09-fw-sc02		A	10.62.192.134
			AAAA	2606:9680:2042:4e20::7
bos09-fw-scm01		A	10.62.192.135
			AAAA	2606:9680:2042:4e20::8
bos09-fw-scm02		A	10.62.192.136
			AAAA	2606:9680:2042:4e20::9
bos09-sd-vce01		A	10.62.192.1
bos09-sw-core01		A	10.62.192.190
			AAAA	2606:9680:2042:4e20:ffff:ffff:ffff:ff7f
bos09-sw-dmz01		A	10.62.192.141
			AAAA	2606:9680:2042:4e20::1
bos09-sw-fp01		A	10.62.192.143
			AAAA	2606:9680:2042:4e20::2
bos09-sw-fp02		A	10.62.192.144
			AAAA	2606:9680:2042:4e20::3
bos09-sw01-av01		A	10.62.192.161
			AAAA	2606:9680:2042:4e20::4001
bos09-sw01-av21		A	10.62.192.162
bos09-sw01-ma01		A	10.62.192.175
			AAAA	2606:9680:2042:4e20::1001
bos09-sw01-ma21		A	10.62.192.176
			AAAA	2606:9680:2042:4e20::1002
bos09-sw01-ua01		A	10.62.192.155
			AAAA	2606:9680:2042:4e20::5001
bos09-sw01-ua21		A	10.62.192.156
			AAAA	2606:9680:2042:4e20::5002
bos09-sw01-wa01		A	10.62.192.165
			AAAA	2606:9680:2042:4e20::3001
bos09-sw01-wa21		A	10.62.192.166
			AAAA	2606:9680:2042:4e20::3002
bos09-sw02-av01		A	10.62.192.163
			AAAA	2606:9680:2042:4e20::4002
bos09-sw02-av21		A	10.62.192.164
bos09-sw02-ma01		A	10.62.192.177
			AAAA	2606:9680:2042:4e20::1003
bos09-sw02-ma21		A	10.62.192.178
			AAAA	2606:9680:2042:4e20::1004
bos09-sw02-ua01		A	10.62.192.157
			AAAA	2606:9680:2042:4e20::5003
bos09-sw02-ua21		A	10.62.192.158
			AAAA	2606:9680:2042:4e20::5004
bos09-sw02-wa01		A	10.62.192.167
			AAAA	2606:9680:2042:4e20::3003
bos09-sw02-wa21		A	10.62.192.168
			AAAA	2606:9680:2042:4e20::3004
bos09-wc-lc01		A	10.62.194.17
			AAAA	2606:9680:2042:22e0::1
bos09-wc-lc02		A	10.62.194.18
			AAAA	2606:9680:2042:22e0::2
c1-10f-nrt1		A	10.16.195.121
c1-10f-sha1		A	10.164.196.31
c1-11f-sha1		A	10.164.196.30
c1-12f-nrt1		A	10.16.195.122
c1-13f-icn1		A	10.109.208.98
			AAAA	2402:740:4046:4e20::2001
c1-13f-nrt1		A	10.16.195.120
c1-14f-mel3		A	10.117.192.8
c1-17f-jfk2		A	10.62.96.81
c1-1f-aus3		A	10.25.207.133
c1-1f-blr7		CNAME	c1-1st-blr7
c1-1st-blr7		A	10.107.97.65
c1-26f-sea2		A	10.62.1.63
c1-28f-cdg1		A	10.96.6.40
c1-2f-aus3		A	10.25.207.115
c1-2f-blr7		CNAME	c3-2nd-blr7
c1-2f-bos2		A	10.118.251.14
c1-2f-bos3		A	10.21.80.9
c1-2f-cos1		A	10.25.33.1
c1-2f-maa2		A	10.109.80.10
c1-2f-nrt1		A	10.117.67.109
c1-38f-tpe1		A	10.110.250.10
c1-3f-aus3		A	10.25.207.116
c1-3f-blr7		CNAME	c4-3rd-blr7
c1-3f-del2		AAAA	2402:740:47:4e20::2001
c1-3f-f32-sjo1		A	10.25.224.123
			AAAA	2801:1d4:40:4e20::2001
c1-3f-gru1		CNAME	c1-gru1.vmware.com.
c1-4f-blr11		A	10.108.224.50
c1-4f-blr9		A	10.88.34.8
c1-4f-den1		A	10.20.8.21
c1-4f-ewr2		A	10.25.135.41
c1-5f-aus2		A	10.25.1.88
c1-5f-den1		A	10.20.8.13
c1-5f-f33-sjo1		A	10.25.244.131
			AAAA	2801:1d4:40:4e23::2003
c1-5f-zrh2		A	10.30.55.107
c1-6f-blr7		CNAME	c7-6th-blr7
c1-6f-nrt1		A	10.117.67.64
c1-6f-sin1		A	10.16.209.13
c1-7f-blr7		CNAME	c10-7th-blr7
c1-7f-kul1		A	10.109.213.122
c1-7f-sfo2		A	10.118.71.4
c1-8f-bcn1		A	10.96.64.231
			AAAA	2a0d:1e00:4043:4e20::2001
c1-9f-blr7		CNAME	c12-9th-blr7
c1-ber			A	10.207.144.181
c1-dca01-atl01		A	10.88.2.101
c1-dcb01-atl01		A	10.88.2.102
c1-del2			A	10.119.193.226
c1-den2			A	10.201.193.15
c1-dfw2			CNAME	c1-7f-dfw2
c1-dxb1			CNAME	dxb01-cs07-ca01
c1-ewr2			A	10.25.135.41
c1-gf-bma1		A	10.16.148.150
c1-gf-jnb1		A	10.30.6.113
c1-gru1			CNAME	c1-gru1.vmware.com.
c1-lax			A	10.204.96.186
c1-lon			A	10.204.32.186
c1-nyc			A	10.204.0.185
c1-ord			A	10.204.176.181
c1-pao12		CNAME	pao12-cs-ca01
c1-pao13		CNAME	pao13-cs-ca01
c1-pao16		CNAME	pao16-cs-ca01
c1-par			A	10.207.224.181
c1-sin			A	10.204.192.182
c1-tor			A	10.201.128.179
c1-waw1			CNAME	waw01-cs-ca01
c1-zrh2			A	10.30.55.107
c10-7th-blr7		A	10.107.97.74
c12-9th-blr7		A	10.107.97.76
c2-10f-nrt1		A	10.16.195.121
c2-13f-nrt1		A	10.16.195.123
c2-1f-aus3		A	10.25.207.132
c2-1f-blr7		CNAME	c2-1st-blr7
c2-1f-lhr1		A	10.27.174.233
c2-1st-blr7		A	10.107.97.66
c2-2f-bos2		A	10.118.140.250
c2-2f-cos1		A	10.25.33.2
c2-3f-f32-sjo1		A	10.25.244.130
			AAAA	2801:1d4:40:4e23::2002
c2-4f-blr11		A	10.108.224.51
c2-4f-blr9		A	10.88.34.7
c2-5f-den1		A	10.20.8.23
c2-6f-blr7		CNAME	c8-6th-blr7
c2-6f-sin1		A	10.16.209.17
c2-dca01-atl01		A	10.88.2.105
c2-dcb01-atl01		A	10.88.2.106
c2-dfw2			CNAME	c2-7f-dfw2
c2-gf-lhr1		A	10.27.174.231
c2-pao12		CNAME	pao12-cs01-ca21
c2-pao13		CNAME	pao13-cs01-ca21
c3-12f-nrt1		A	10.16.195.122
c3-13f-nrt1		A	10.117.67.30
c3-1f-aus3		A	10.25.207.134
c3-2nd-blr7		A	10.107.97.67
c3-5f-den1		A	10.20.8.34
c3-6f-blr7		CNAME	c9-6th-blr7
c3-lhr1			CNAME	c2-gf-lhr1
c3-pao13		CNAME	pao13-cs02-ca01
c4-2nd-nrt1		A	10.117.67.109
c4-3rd-blr7		A	10.107.97.68
c4-5f-den1		A	10.20.8.35
c4-pao12		A	10.18.248.121
c4-pao13		CNAME	pao13-cs02-ca21
c5-13f-nrt1		A	10.16.195.123
c5-5f-atl01		A	10.88.2.119
c5-lhr1			CNAME	c2-1f-lhr1
c6-6f-nrt1		A	10.117.67.64
c6-pek2			A	10.117.0.238
c7-13f-nrt1		A	10.117.67.30
c7-6th-blr7		A	10.107.97.71
c8-6th-blr7		A	10.107.97.72
c8-8f-atl01		A	10.88.2.122
c9-6th-blr7		A	10.107.97.73
camera1-8f-bcn1		AAAA	2a0d:1e00:4043:4e20::6002
can01-cs35-ca01		A	10.109.181.133
			AAAA	2402:740:4042:4e20::2001
can01-sw-core01		AAAA	2402:740:4042:4e20:ffff:ffff:ffff:ff7f
can01-sw-dmz01		AAAA	2402:740:4042:4e20::1
can01-sw-fp01		AAAA	2402:740:4042:4e20::2
can01-sw-fp02		AAAA	2402:740:4042:4e20::3
can01-sw35-av01		A	10.109.181.132
			AAAA	2402:740:4042:4e20::4001
can01-sw35-ua01		AAAA	2402:740:4042:4e20::5001
can01-sw35-wa01		AAAA	2402:740:4042:4e20::3001
can01-wc-lc01		AAAA	2402:740:4042:22e0::1
can01-wc-lc02		AAAA	2402:740:4042:22e0::2
cdg01-fw-egp01		AAAA	2a0d:1e00:6041:4e20::4
cdg01-fw-egp02		AAAA	2a0d:1e00:6041:4e20::5
cdg01-sd-vce01		A	10.96.6.38
cdg01-sw-core01		A	10.96.11.88
			AAAA	2a0d:1e00:6041:4e20:ffff:ffff:ffff:ff7f
cdg01-sw-dmz01		A	10.96.6.23
			AAAA	2a0d:1e00:6041:4e20::1
cdg01-sw-fp01		A	10.96.6.25
			AAAA	2a0d:1e00:6041:4e20::2
cdg01-sw-fp02		A	10.96.6.26
			AAAA	2a0d:1e00:6041:4e20::3
cdg01-sw28-av01		A	10.96.6.35
			AAAA	2a0d:1e00:6041:4e20::4001
cdg01-sw28-ma01		A	10.96.6.32
			AAAA	2a0d:1e00:6041:4e20::1001
cdg01-sw28-ua01		A	10.96.6.34
			AAAA	2a0d:1e00:6041:4e20::5001
cdg01-sw28-ua02		A	10.96.6.21
			AAAA	2a0d:1e00:6041:4e20::5002
cdg01-sw28-wa01		A	10.96.6.33
			AAAA	2a0d:1e00:6041:4e20::3001
cdg01-sw29-av01		A	10.96.6.28
			AAAA	2a0d:1e00:6041:4e20::4002
cdg01-sw29-ua01		A	10.96.6.29
			AAAA	2a0d:1e00:6041:4e20::5002
cdg01-sw29-wa01		A	10.96.6.30
			AAAA	2a0d:1e00:6041:4e20::3002
cdg01-sw30-av01		A	10.96.6.31
			AAAA	2a0d:1e00:6041:4e20::4003
cdg01-sw30-ua01		A	10.96.6.27
			AAAA	2a0d:1e00:6041:4e20::5003
cdg01-sw30-wa01		A	10.96.6.22
			AAAA	2a0d:1e00:6041:4e20::3003
cdg01-wc-lc01		A	10.16.144.249
			AAAA	2a0d:1e00:6041:22e0::1
cdg01-wc-lc02		A	10.16.144.250
			AAAA	2a0d:1e00:6041:22e0::2
cdg02-cs01-ca01		A	10.207.224.184
cdg02-fw-eg01		A	10.207.224.182
cdg02-fw-eg02		A	10.207.224.183
cdg02-sd-vce01		A	10.207.224.188
cdg02-sd-vce02		A	10.207.224.189
cdg02-sw01-ua01		A	10.207.224.185
cdg02-sw01-ua02		A	10.207.224.186
cdg02-sw01-ua03		A	10.207.224.187
core01-asr-atl01	A	10.88.9.13
core01-mgmt-ams02	A	10.26.212.244
core01-mgmt-sin3	A	10.110.212.11
core01-mgmt-sjc05	A	10.188.7.251
core01-mgmt-sjc31	A	10.166.80.32
core02-asr-atl01	A	10.88.9.14
core02-mgmt-ams02	A	10.26.212.245
core02-mgmt-sin3	A	10.110.212.12
core02-mgmt-sjc05	A	10.188.7.252
core02-mgmt-sjc31	A	10.166.80.33
core1-bcn1		A	10.96.70.26
			AAAA	2a0d:1e00:4043:4e20:ffff:ffff:ffff:ff7f
core1-ber		A	10.207.144.190
core1-blr10		A	10.54.192.13
core1-dca		A	10.204.160.189
core1-del2		A	10.119.192.1
			AAAA	2402:740:47:4e20:ffff:ffff:ffff:ff7f
core1-den2		A	10.201.193.254
core1-icn1		AAAA	2402:740:4046:4e20:ffff:ffff:ffff:ff7f
core1-lax		A	10.204.96.190
core1-nyc		A	10.204.0.189
core1-ord		A	10.204.176.189
core1-par		A	10.207.224.190
core1-sin		A	10.204.192.190
core1-sjo1		AAAA	2801:1d4:40:4e20:ffff:ffff:ffff:ff7f
core3-tor		A	10.201.128.172
core4-tor		A	10.201.128.173
core5-tor		A	10.201.128.174
core7-tor		A	10.201.128.176
corp-nprd-gslb-vs-eat1	A	10.128.130.90
corp-nprd-gslb-vs-sjc5	A	10.188.21.132
cos01-cs-ca01		A	10.25.33.3
cp-prd-ams04-s1		A	10.96.130.242
cp-prd-atl-pbk		A	10.84.54.45
cp-prd-blr07-o1		A	10.107.0.50
cp-prd-blr07-s1		A	10.54.145.242
cp-prd-blr12-s1		A	10.205.227.10
cp-prd-blr12-s2		A	10.205.227.11
cp-prd-blr13-o1		A	10.231.68.10
cp-prd-blr13-o2		A	10.231.68.11
cp-prd-blr13-s1		A	10.177.230.242
cp-prd-blr13-s2		A	10.177.230.243
cp-prd-bos04-s1		A	10.62.131.12
cp-prd-bos07-s1		A	10.16.3.10
cp-prd-bos07-s2		A	10.16.3.11
cp-prd-bos09-s1		A	10.62.197.10
cp-prd-dca01-s1		A	10.204.162.10
cp-prd-den03-s1		A	10.17.35.10
cp-prd-eze01-s1		A	10.204.98.20
cp-prd-hkg1-s1e		A	10.177.3.242
cp-prd-lhr6-s1e		A	10.204.35.11
cp-prd-lin02-s1		A	10.98.133.242
cp-prd-maa04-s1		A	10.120.140.242
cp-prd-maa04-s1-old	AAAA	2402:740:50:2410::21
cp-prd-nrt02-s1		A	10.65.194.242
cp-prd-nrt02-s1-old	A	10.217.194.30
cp-prd-ord01-s1		A	10.204.178.2
cp-prd-pdx03-s1		A	10.204.67.10
cp-prd-pdx03-s2		A	10.204.67.11
cp-prd-pnq4-o1e		A	10.205.155.10
cp-prd-pnq4-s1e		A	10.226.4.242
cp-prd-rdu01-s1		A	10.204.226.40
cp-prd-sfo03-s1		A	10.201.7.10
cp-prd-sfo03-s2		A	10.201.7.11
cp-prd-sin3-ins		A	10.111.0.29
cp-prd-sin3-pbk		A	10.111.0.95
cp-prd-sof2-pbk		A	10.23.108.110
cp-prd-svq1-s1e		A	10.71.19.6
cp-prd-svq1-s2e		A	10.71.19.7
cp-prd-waw1-s1e		A	10.26.93.31
cp-prd-yyz01-s1		A	10.201.133.11
cp-temp-pek3-s1e	A	10.117.226.32
cp-temp-pek3-s2e	A	10.117.226.33
cp-temp-sin1-s1		A	10.16.200.33
cp-temp-sin1-s2		A	10.16.200.34
dca01-cs-ca01		A	10.204.160.151
			AAAA	2606:9680:2043:4e20::2001
dca01-fw-eg01		A	10.204.160.133
dca01-fw-eg02		A	10.204.160.134
dca01-sd-vce01		A	10.204.160.1
dca01-sw-core01		A	10.204.160.190
			AAAA	2606:9680:2043:4e20:ffff:ffff:ffff:ff7f
dca01-sw-dmz01		A	10.204.160.131
			AAAA	2606:9680:2043:4e20::1
dca01-sw-fp01		A	10.204.160.141
			AAAA	2606:9680:2043:4e20::2
dca01-sw-fp02		A	10.204.160.142
			AAAA	2606:9680:2043:4e20::3
dca01-sw01-ua02		A	10.204.160.186
dca01-sw01-ua03		A	10.204.160.187
dca01-sw06-av01		A	10.204.160.165
			AAAA	2606:9680:2043:4e20::4001
dca01-sw06-ma01		A	10.204.160.171
			AAAA	2606:9680:2043:4e20::1001
dca01-sw06-pa01		A	10.204.160.175
			AAAA	2606:9680:2043:4e20::6001
dca01-sw06-ua01		A	10.204.160.155
			AAAA	2606:9680:2043:4e20::5001
dca01-sw06-ua02		A	10.204.160.156
			AAAA	2606:9680:2043:4e20::5002
dca01-sw06-wa01		A	10.204.160.161
			AAAA	2606:9680:2043:4e20::3001
dca01-wc-lc01		A	10.204.163.17
			AAAA	2606:9680:2043:22e0::1
dca01-wc-lc02		A	10.204.163.18
			AAAA	2606:9680:2043:22e0::2
del02-sd-vce01		A	10.119.200.153
del02-wc-lc01		A	10.119.200.2
del02-wc-lc02		A	10.119.200.3
den01-sd-vce01		A	10.21.28.65
den01-sw03-av01		A	10.25.180.143
			AAAA	2606:9680:2045:4e20::4001
den01-sw03-wa01		A	10.25.182.193
den02-cs01-ca01		A	10.201.192.184
den02-fw-egp01		A	10.201.193.3
den02-fw-egp02		A	10.201.193.4
den02-sd-vce01		A	10.201.192.188
den02-sd-vce02		A	10.201.192.189
den02-sw-core01		A	10.201.192.190
den02-sw01-ua01		A	10.201.192.185
den02-sw01-ua02		A	10.201.192.186
den02-sw01-ua03		A	10.201.192.187
den03-cs01-ca01		A	10.17.33.1
den03-fw-eg01		A	10.17.33.31
den03-fw-eg02		A	10.17.33.32
den03-gw1		A	10.17.33.139
den03-gw2		A	10.17.33.138
den03-sw-core01		A	10.17.33.62
den03-sw-dmz01		A	10.17.33.61
den03-sw-fp01		A	10.17.33.11
den03-sw-fp02		A	10.17.33.12
den03-sw01-ma01		A	10.17.33.41
den03-sw01-pa01		A	10.17.33.27
den03-sw01-ua01		A	10.17.33.21
den03-sw01-wa01		A	10.17.33.50
den03-sw02-av01		A	10.17.33.25
den03-sw02-ua01		A	10.17.33.22
den03-sw02-wa01		A	10.17.33.51
den03-sw03-av01		A	10.17.33.26
den03-sw03-ua01		A	10.17.33.23
den03-sw03-wa01		A	10.17.33.52
den03-wc-lc01		A	10.17.33.131
den03-wc-lc02		A	10.17.33.132
den1-nsx-eg01-np	A	10.25.180.147
den1-nsx-eg02-np	A	10.25.180.148
dfw02-cs-ca01		A	10.118.80.116
dfw02-cs-ca02		A	10.118.80.117
dfw02-nsx-eg01		A	10.118.80.114
dfw02-nsx-eg02		A	10.118.80.115
dfw02-sd-vce01		A	10.118.95.17
dfw02-sw-fp01		A	10.118.203.68
dfw02-sw-fp02		A	10.118.203.69
dfw02-sw07-av01		A	10.118.203.72
dfw02-sw07-ma01		A	10.118.203.70
dfw02-sw07-ua02		A	10.118.203.71
dhcp1-lhr06		A	10.204.35.2
			AAAA	2a0d:1e00:2040:2410::2
dhcp1-yyz01		A	10.201.133.2
dxb01-cs07-ca01		A	10.177.67.200
dxb01-cs23-ca01		A	10.177.67.208
dxb01-fw-egp01		A	10.177.67.206
dxb01-fw-egp02		A	10.177.67.207
dxb01-sw-core01		A	10.177.67.1
dxb01-sw-dmz01		A	10.177.67.211
dxb01-sw-fp01		A	10.177.67.201
dxb01-sw-fp02		A	10.177.67.202
dxb01-sw07-ma01		A	10.177.67.215
dxb01-sw07-ua01		A	10.177.67.214
dxb01-sw07-wa01		A	10.177.67.209
dxb01-sw23-av01		A	10.177.67.205
dxb01-sw23-ma01		A	10.177.67.210
dxb01-sw23-ua01		A	10.177.67.204
dxb01-sw23-wa01		A	10.177.67.203
dxb01-wc-lc01		A	10.177.69.130
dxb01-wc-lc02		A	10.177.69.131
eat01-fw-egp03		A	10.128.160.44
eat01-fw-egp04		A	10.128.160.45
eat01-fw-lab01		A	10.128.160.83
eat01-fw-lab02		A	10.128.160.84
eat01-sd-vch01		A	10.128.254.64
eat01-sd-vch02		A	10.128.254.65
eat1-esxi01-perimeter-mgmt A	10.200.33.129
eat1-esxi02-perimeter-mgmt A	10.200.33.130
eat1-esxi03-perimeter-mgmt A	10.200.33.131
eat1-esxi04-perimeter-mgmt A	10.200.33.132
eat1-nsx-eg01		A	10.128.175.26
eat1-nsx-eg02		A	10.128.175.27
eat1-nsxedg-backup	A	10.200.33.137
eat1-nsxedg-jump1	A	10.200.33.138
eat1-nsxedg-prod-mgr	A	10.200.33.133
eat1-nsxedg-prod-mgr01	A	10.200.33.134
eat1-nsxedg-prod-mgr02	A	10.200.33.135
eat1-nsxedg-prod-mgr03	A	10.200.33.136
ekahau-sof-w01		A	10.93.39.39
evn01-cs-ca01		A	10.30.96.7
evn01-fw-egp01		A	10.30.96.20
evn01-fw-egp02		A	10.30.96.21
evn01-ns-eni01		A	10.30.96.18
evn01-sd-vce01		A	10.26.218.4
evn01-sw-core01		A	10.26.218.3
evn01-sw-dmz01		A	10.26.130.42
evn01-sw-engcore01	A	10.26.218.8
evn01-sw-fp01		A	10.30.96.110
evn01-sw-fp02		A	10.30.96.111
evn01-sw01-av01		A	10.30.96.31
evn01-sw01-av02		A	10.30.96.32
evn01-sw01-ma01		A	10.30.96.8
evn01-sw01-ma02		A	10.26.218.19
evn01-sw01-pa01		A	10.30.96.91
evn01-sw01-ta01		A	10.30.96.9
evn01-sw01-ua01		A	10.30.96.17
evn01-sw01-ua02		A	10.30.96.12
evn01-sw01-wa01		A	10.30.96.51
evn01-sw06-av01		A	10.30.96.35
evn01-sw06-av02		A	10.30.96.36
evn01-sw06-ua01		A	10.30.96.15
evn01-sw06-ua02		A	10.30.96.16
evn01-sw06-wa01		A	10.30.96.56
evn01-wc-lc01		A	10.30.96.129
evn01-wc-lc02		A	10.30.96.130
eze01-cs-ca01		A	10.204.101.23
			AAAA	2801:1d4:641:4e20::2001
eze01-fw-eg01		A	10.204.101.5
			AAAA	2801:1d4:641:4e20::4
eze01-fw-eg02		A	10.204.101.6
			AAAA	2801:1d4:641:4e20::5
eze01-sw-core01		A	10.204.101.62
			AAAA	2801:1d4:641:4e20:ffff:ffff:ffff:ff7f
eze01-sw-dmz01		A	10.204.101.3
			AAAA	2801:1d4:641:4e20::1
eze01-sw03-av01		A	10.204.101.37
			AAAA	2801:1d4:641:4e20::4001
eze01-sw03-ma01		A	10.204.101.43
			AAAA	2801:1d4:641:4e20::1001
eze01-sw03-ua01		A	10.204.101.27
			AAAA	2801:1d4:641:4e20::5001
eze01-sw03-wa01		A	10.204.101.33
			AAAA	2801:1d4:641:4e20::3001
eze01-wc-lc01		A	10.204.101.113
			AAAA	2801:1d4:641:22e0::1
eze01-wc-lc02		A	10.204.101.114
			AAAA	2801:1d4:641:22e0::2
failover-ork03		A	10.16.155.76
fg-r2d2-trust-1		A	10.107.228.1
fg-r2d2-trust-2		A	10.107.230.1
fg-r2d2-trust-3		A	10.107.231.1
fg-r2d2-trust-4		A	10.107.227.1
fg-r2d2-untrust-1	A	10.107.226.1
fg1-bcn1		AAAA	2a0d:1e00:4043:4e20::4
fg1-cloudpop-pao04	A	10.17.252.48
fg1-cntrx-blr13		A	10.177.216.234
fg1-cos1		A	10.118.31.145
fg1-dr-eat1		A	10.128.175.236
fg1-genesys-atl01	A	10.88.14.60
fg1-genesys-sjc05	A	10.188.0.81
fg1-hkg1		A	10.109.176.136
fg1-kylo		A	10.95.4.83
fg1-luke		A	10.183.142.200
fg1-ork3		A	10.66.44.3
fg1-pnq4		A	10.205.130.3
fg1-r2d2		A	10.107.231.10
fg1-sjo1		AAAA	2801:1d4:40:4e20::4
fg1-waw1		A	10.26.89.11
fg2-bcn1		AAAA	2a0d:1e00:4043:4e20::5
fg2-cloudpop-pao04	A	10.17.252.49
fg2-cos1		A	10.118.31.146
fg2-dr-eat1		A	10.128.175.237
fg2-genesys-atl01	A	10.88.14.61
fg2-genesys-sjc05	A	10.188.0.137
fg2-hkg1		A	10.109.176.137
fg2-kylo		A	10.95.4.22
fg2-luke		A	10.183.142.201
fg2-ork3		A	10.66.44.4
fg2-pnq4		A	10.205.130.4
fg2-r2d2		A	10.107.231.11
fg2-sjo1		AAAA	2801:1d4:40:4e20::5
fg2-waw1		A	10.26.89.12
fg3-cos1		A	10.118.31.147
fg3-sof6		AAAA	2a0d:1e00:46:4e20::6
fg4-cos1		A	10.118.31.148
fg4-sof6		AAAA	2a0d:1e00:46:4e20::7
fgp1-5060-sjc31		A	10.166.80.25
fgp1-5260-eat1		A	10.128.160.61
fgp1-sof6		AAAA	2a0d:1e00:46:4e20::4
fgp2-5060-sjc31		A	10.166.80.26
fgp2-5260-eat1		A	10.128.160.62
fgp2-sof6		AAAA	2a0d:1e00:46:4e20::5
floating-ip-1		A	10.128.36.123
floating-ip-2		A	10.128.36.124
fp1-n9k-aus2		A	10.25.1.89
fp1-n9k-aus3		A	10.25.207.104
fp1-n9k-bcn1		AAAA	2a0d:1e00:4043:4e20::2
fp1-n9k-cos1		A	10.118.31.136
fp1-n9k-den1		A	10.25.180.137
			AAAA	2606:9680:2045:4e20::2
fp1-n9k-hkg1		A	10.177.1.144
fp1-n9k-kul1		A	10.109.213.115
fp1-n9k-pao12		CNAME	pao12-sw-fp01
fp1-n9k-pao30		CNAME	pao30-sw-fp01
fp1-n9k-sfo2		A	10.118.71.20
fp2-n9k-aus2		A	10.25.1.90
fp2-n9k-aus3		A	10.25.207.105
fp2-n9k-bcn1		AAAA	2a0d:1e00:4043:4e20::3
fp2-n9k-cos1		A	10.118.31.137
fp2-n9k-den1		A	10.25.180.138
			AAAA	2606:9680:2045:4e20::3
fp2-n9k-hkg1		A	10.177.1.145
fp2-n9k-kul1		A	10.109.213.116
fp2-n9k-pao12		CNAME	pao12-sw-fp02
fp2-n9k-pao30		CNAME	pao30-sw-fp02
fp2-n9k-sfo2		A	10.118.71.21
galaxy-prod-proxy	A	10.253.21.44
gni-dev			CNAME	gni-dev.nsstestlab.com.
gsscore-can1		A	10.109.181.140
hkg01-cs04-ca01		A	10.109.175.73
			AAAA	2402:740:4043:4e20::2001
hkg01-fw-egp01		AAAA	2402:740:4043:4e20::4
hkg01-fw-egp02		AAAA	2402:740:4043:4e20::5
hkg01-sw-core01		A	10.177.1.129
			AAAA	2402:740:4043:4e20:ffff:ffff:ffff:ff7f
hkg01-sw-dmz01		A	10.177.1.146
			AAAA	2402:740:4043:4e20::1
hkg01-sw-fp01		AAAA	2402:740:4043:4e20::2
hkg01-sw-fp02		AAAA	2402:740:4043:4e20::3
hkg01-sw01-ma01		AAAA	2402:740:4043:4e20::1001
hkg01-sw01-ua01		AAAA	2402:740:4043:4e20::5001
hkg01-sw01-wa01		AAAA	2402:740:4043:4e20::3001
hkg01-sw04-ma01		A	10.177.1.147
hkg01-sw04-ua01		A	10.177.1.148
hkg01-sw04-wa01		A	10.177.1.142
hkg01-wc-lc01		A	10.177.4.130
			AAAA	2402:740:4043:22e0::1
hkg01-wc-lc02		A	10.177.4.131
			AAAA	2402:740:4043:22e0::2
htfb05-s3048-1		A	10.32.20.25
iad01-cs-ca01		A	10.42.71.201
iad01-cs06-ca01		A	10.42.71.202
iad01-fw-eg01		A	10.42.71.203
iad01-fw-eg02		A	10.42.71.204
iad01-sw-core01		A	10.42.70.1
iad01-sw-dmz01		A	10.42.71.207
iad01-sw-fp01		A	10.42.71.213
iad01-sw-fp02		A	10.42.71.214
iad01-sw04-ma01		A	10.42.71.208
iad01-sw04-ua01		A	10.42.71.205
iad01-sw04-wa01		A	10.42.71.211
iad01-sw06-ua01		A	10.42.71.206
iad01-sw06-wa01		A	10.42.71.212
iad01-wc-lc01		A	10.42.77.2
iad01-wc-lc02		A	10.42.77.3
iad1-gigamon-1		A	10.42.71.215
ib-atl01		A	10.84.55.35
ib-blr3			A	10.112.0.24
ib-cp-sjc5		A	10.188.9.100
ib-cp-sjc5-int-demo	A	10.188.26.99
ib-cpe-eat01		A	10.79.228.161
			AAAA	fd01:3:8:900::6
ib-cpe-sjc05		A	10.184.52.99
			AAAA	2620:124:6020:c500::2
ib-cpe-sjc31		A	10.78.36.33
			AAAA	fd01:0:106:d00::2
ib-dd-ams02		A	10.27.190.1
ib-dd-ams04		AAAA	2a0d:1e00:6040:2410::1
ib-dd-bcn01		AAAA	2a0d:1e00:4043:2410::1
ib-dd-blr12		A	10.205.227.1
			AAAA	2402:740:45:2410::1
ib-dd-bos03		A	10.21.82.1
ib-dd-bos04		A	10.62.131.1
			AAAA	2606:9680:2041:2410::1
ib-dd-bos09		A	10.62.197.1
			AAAA	2606:9680:2042:2410::1
ib-dd-can01		AAAA	2402:740:4042:2410::1
ib-dd-cdg1		A	10.16.144.110
			AAAA	2a0d:1e00:6041:2410::1
ib-dd-dca01		A	10.204.162.1
			AAAA	2606:9680:2043:2410::1
ib-dd-del02		AAAA	2402:740:47:2410::1
ib-dd-den03		A	10.17.35.1
ib-dd-den1		A	10.16.188.210
			AAAA	2606:9680:2045:2410::1
ib-dd-eze01		A	10.204.98.1
			AAAA	2801:1d4:641:2410::1
ib-dd-gru01		AAAA	2801:1d4:640:2410::1
ib-dd-hkg01		AAAA	2402:740:4043:2410::1
ib-dd-icn01		A	10.109.208.1
			AAAA	2402:740:4046:2410::1
ib-dd-lhr01		A	10.27.172.132
			AAAA	2a0d:1e00:2043:2410::132
ib-dd-lhr06		A	10.204.35.1
			AAAA	2a0d:1e00:2040:2410::1
ib-dd-lin02		A	10.27.227.1
			AAAA	2a0d:1e00:4040:2410::1
ib-dd-maa04		A	10.120.140.241
			AAAA	2402:740:50:2410::1
ib-dd-mel3		A	10.117.195.130
ib-dd-muc02		AAAA	2a0d:1e00:6042:2410::1
ib-dd-nrt02		A	10.217.194.1
			AAAA	2402:740:4044:2410::1
ib-dd-pao24		A	10.211.89.141
			AAAA	fc00:10:33:4::1
ib-dd-pao30		A	10.211.81.141
ib-dd-pdx03		A	10.204.67.1
ib-dd-pnq04		AAAA	2402:740:5a:2410::1
ib-dd-rdu01		A	10.204.226.1
ib-dd-rom01		AAAA	2a0d:1e00:4044:2410::1
ib-dd-sfo3		A	10.201.7.1
ib-dd-sha02		A	10.109.184.10
			AAAA	2402:740:4048:2410::10
ib-dd-sjo1		A	10.25.225.141
			AAAA	2801:1d4:40:2410::1
ib-dd-waw01		A	10.26.93.1
ib-ddnsmaster1-new	A	10.166.16.190
ib-failover-sin2	A	10.111.0.50
ib-failover-sjc05	A	10.172.40.100
ib-failover-sof2	A	10.23.108.150
ib-gm-stg		A	10.128.153.100
ib-gmc-sin2		A	10.111.0.100
ib-ns1-atl01		A	10.84.54.20
			AAAA	2606:9680:2040:2410::1
ib-ns1-blr3		A	10.112.16.130
ib-ns1-ork3		A	10.16.142.110
			AAAA	2a0d:1e00:2042:2414::110
ib-ns1-pao04		A	10.121.67.132
ib-ns1-sc2		A	10.113.61.110
ib-ns1-sc2-vip		A	10.113.60.195
ib-ns1-sjc05		A	10.188.8.1
ib-ns1-sjc05-vip	A	10.188.9.27
ib-ns1-sjc31		A	10.166.1.1
			AAAA	fd01:0:102:b::1
ib-ns1-wdc		A	10.128.242.1
ib-ns2-atl01		A	10.84.54.21
			AAAA	2606:9680:2040:2410::2
ib-ns2-blr3		A	10.112.16.131
ib-ns2-ork3		AAAA	2a0d:1e00:2042:2414::111
ib-ns2-pao04		A	10.121.67.133
ib-ns2-sc2		A	10.113.61.111
ib-ns2-sc2-vip		A	10.113.60.165
ib-ns2-sjc05		A	10.188.8.2
ib-ns2-sjc05-vip	A	10.188.9.28
ib-ns2-sjc31		A	10.166.1.2
			AAAA	fd01:0:102:b::2
ib-ns2-wdc		A	10.128.242.2
ib-ntp-blr09		CNAME	ib-dd-blr9.vmware.com.
ib-ntp-pnq04		CNAME	ib-dd-pnq04
ib-ntp-pnq4		CNAME	ib-dd-pnq04
ib-ntp-sof06		CNAME	ib-dd-sof6.eng.vmware.com.
ib-ntp-sof6		CNAME	ib-dd-sof6.eng.vmware.com.
ib-ntp-waw01		CNAME	ib-dd-waw01
ib-ork3			AAAA	2a0d:1e00:2042:2414::79
ib1-cpe-eat01		A	10.79.228.162
			AAAA	fd01:3:8:900::2
ib1-cpe-ha-eat01	A	10.79.228.164
ib1-cpe-ha-eat01-ipv6	AAAA	fd01:3:8:900::3
ib1-cpe-sjc05		A	10.184.52.100
ib1-cpe-sjc31		A	10.78.36.36
ib1-dd-ams02		A	10.27.190.2
ib1-dd-aus2		A	10.25.0.102
ib1-dd-blr12		A	10.205.227.2
ib1-dd-blr13		A	10.231.68.2
ib1-dd-blr2		A	10.112.64.2
ib1-dd-blr7		A	10.107.0.45
ib1-dd-bos07		A	10.16.3.2
ib1-dd-den1		A	10.16.188.131
ib1-dd-ha-ams02		A	10.27.190.13
ib1-dd-ha-bos07		A	10.16.3.4
ib1-dd-ha-nrt02		A	10.217.194.4
ib1-dd-ha-pao30		A	10.33.38.104
ib1-dd-nrt02		A	10.217.194.2
ib1-dd-pao12		A	10.20.145.202
ib1-dd-pao24		A	10.33.4.35
ib1-dd-pao30		A	10.33.38.102
			AAAA	fc00:10:33:38::102
ib1-dd-pdx03		A	10.204.67.2
ib1-dd-pek2		A	10.117.0.71
			AAAA	2402:740:4040:2400::2
ib1-dd-pnq04		A	10.205.155.2
ib1-dd-pnq04-ha		A	10.205.155.4
ib1-dd-sin1		A	10.16.200.51
ib1-dd-sjo1		A	10.25.225.171
ib1-dd-sof6		A	10.93.9.2
ib1-dd-svq01		A	10.71.19.2
ib1-dd-waw01		A	10.26.93.2
ib1-failover-ha-sin2	A	10.111.0.53
ib1-failover-ha-sof2	A	10.23.108.153
ib1-failover-sin2	A	10.111.0.51
ib1-failover-sjc5	A	10.172.40.101
ib1-failover-sof2	A	10.23.108.151
ib1-ha-dd-aus2		A	10.25.0.104
ib1-ha-dd-blr12		A	10.205.227.4
ib1-ha-dd-blr13		A	10.231.68.4
ib1-ha-dd-blr2		A	10.112.64.4
ib1-ha-dd-blr7		A	10.107.0.47
ib1-ha-dd-den1		A	10.16.188.133
ib1-ha-dd-pao12		A	10.20.145.28
ib1-ha-dd-pao24		A	10.33.4.37
ib1-ha-dd-pek2		A	10.117.0.73
ib1-ha-dd-sin1		A	10.16.200.53
ib1-ha-dd-sjo1		A	10.25.225.173
ib1-ha-dd-sof6		A	10.93.9.4
ib1-ha-dd-svq01		A	10.71.19.4
ib1-ha-failover-sjc5	A	10.172.40.103
ib1-ha-ns1-atl01	A	10.84.54.24
			AAAA	2606:9680:2040:2410::24
ib1-ha-ns1-ork3		A	10.16.142.40
ib1-ha-ns1-sjc31	A	10.166.1.112
ib1-ha-ns2-atl01	A	10.84.54.28
			AAAA	2606:9680:2040:2410::28
ib1-ha-ns2-ork3		A	10.16.142.74
ib1-ha-ns2-sjc31	A	10.166.1.116
ib1-ha-ork3		A	10.16.142.3
ib1-ns1-atl01		A	10.84.54.22
			AAAA	2606:9680:2040:2410::22
ib1-ns1-blr3		A	10.112.16.135
ib1-ns1-ork3		A	10.16.142.38
			AAAA	2a0d:1e00:2042:2414::38
ib1-ns1-sjc31		A	10.166.1.111
ib1-ns2-atl01		A	10.84.54.26
			AAAA	2606:9680:2040:2410::26
ib1-ns2-ork3		A	10.16.142.58
			AAAA	2a0d:1e00:2042:2414::58
ib1-ns2-sjc31		A	10.166.1.115
ib1-ork3		A	10.16.142.105
			AAAA	2a0d:1e00:2042:2414::105
ib1-pao12-lab		A	10.17.131.55
ib1-test		A	10.188.8.85
ib2-cpe-eat01		A	10.79.228.163
			AAAA	fd01:3:8:900::3
ib2-cpe-ha-eat01	A	10.79.228.165
ib2-cpe-ha-eat01-ipv6	AAAA	fd01:3:8:900::5
ib2-cpe-sjc05		A	10.184.52.101
ib2-cpe-sjc31		A	10.78.36.37
ib2-dd-ams02		A	10.27.190.12
ib2-dd-aus2		A	10.25.0.103
ib2-dd-blr12		A	10.205.227.3
ib2-dd-blr13		A	10.231.68.3
ib2-dd-blr2		A	10.112.64.3
ib2-dd-blr7		A	10.107.0.46
ib2-dd-bos07		A	10.16.3.3
ib2-dd-den1		A	10.16.188.132
ib2-dd-ha-ams02		A	10.27.190.14
ib2-dd-ha-bos07		A	10.16.3.5
ib2-dd-ha-nrt02		A	10.217.194.5
ib2-dd-ha-pao30		A	10.33.38.105
ib2-dd-nrt02		A	10.217.194.3
ib2-dd-pao12		A	10.20.145.201
ib2-dd-pao24		A	10.33.4.36
ib2-dd-pao30		A	10.33.38.103
			AAAA	fc00:10:33:38::103
ib2-dd-pdx03		A	10.204.67.3
ib2-dd-pek2		A	10.117.0.72
			AAAA	2402:740:4040:2400::3
ib2-dd-pnq04		A	10.205.155.3
ib2-dd-pnq04-ha		A	10.205.155.5
ib2-dd-sin1		A	10.16.200.52
ib2-dd-sjo1		A	10.25.225.172
ib2-dd-sof6		A	10.93.9.3
ib2-dd-svq01		A	10.71.19.3
ib2-dd-waw01		A	10.26.93.3
ib2-failover-ha-sin2	A	10.111.0.54
ib2-failover-ha-sof2	A	10.23.108.154
ib2-failover-sin2	A	10.111.0.52
ib2-failover-sjc5	A	10.172.40.102
ib2-failover-sof2	A	10.23.108.152
ib2-ha-dd-aus2		A	10.25.0.105
ib2-ha-dd-blr12		A	10.205.227.5
ib2-ha-dd-blr13		A	10.231.68.5
ib2-ha-dd-blr2		A	10.112.64.5
ib2-ha-dd-blr7		A	10.107.0.48
ib2-ha-dd-den1		A	10.16.188.134
ib2-ha-dd-pao12		A	10.20.145.29
ib2-ha-dd-pao24		A	10.33.4.38
ib2-ha-dd-pek2		A	10.117.0.74
ib2-ha-dd-sin1		A	10.16.200.54
ib2-ha-dd-sjo1		A	10.25.225.174
ib2-ha-dd-sof6		A	10.93.9.5
ib2-ha-dd-svq01		A	10.71.19.5
ib2-ha-failover-sjc5	A	10.172.40.104
ib2-ha-ns1-atl01	A	10.84.54.25
			AAAA	2606:9680:2040:2410::25
ib2-ha-ns1-ork3		A	10.16.142.35
ib2-ha-ns1-sjc31	A	10.166.1.114
ib2-ha-ns2-atl01	A	10.84.54.29
			AAAA	2606:9680:2040:2410::29
ib2-ha-ns2-ork3		A	10.16.142.77
ib2-ha-ns2-sjc31	A	10.166.1.118
ib2-ha-ork3		A	10.16.142.9
ib2-ns1-atl01		A	10.84.54.23
			AAAA	2606:9680:2040:2410::23
ib2-ns1-blr3		A	10.112.16.132
ib2-ns1-ork3		A	10.16.142.39
			AAAA	2a0d:1e00:2042:2414::39
ib2-ns1-sjc31		A	10.166.1.113
ib2-ns2-atl01		A	10.84.54.27
			AAAA	2606:9680:2040:2410::27
ib2-ns2-ork3		A	10.16.142.59
			AAAA	2a0d:1e00:2042:2414::59
ib2-ns2-sjc31		A	10.166.1.117
ib2-ork3		A	10.16.142.109
			AAAA	2a0d:1e00:2042:2414::109
ib2-pao12-lab		A	10.17.131.56
ib3-test		A	10.188.8.230
ib4-test		A	10.188.9.109
ichakarov-vm01		A	10.26.46.149
icn01-sd-vce01		A	10.109.207.132
icn01-sw13-av01		A	10.109.208.109
			AAAA	2402:740:4046:4e20::4001
jfk03-fw-egp01		A	10.204.0.186
jfk03-fw-egp02		A	10.204.0.187
jfk03-sd-vce01		A	10.204.0.188
jnb01-sw-fp01		A	10.30.6.117
jnb01-sw-fp02		A	10.30.6.118
kix01-cs25-ca01		A	10.109.112.8
kix01-sd-vce01		A	10.109.112.68
kix01-sw-dmz01		A	10.109.112.7
kix01-sw-fp01		A	10.109.112.25
kix01-sw-fp02		A	10.109.112.26
kix01-sw25-ua01		A	10.109.112.9
kix01-sw25-ua02		A	10.109.112.10
kix01-sw25-wa01		A	10.109.112.11
lab-idp			A	10.128.37.39
lax01-fw-egp01		A	10.204.96.187
lax01-fw-egp02		A	10.204.96.188
lax01-sd-vce02		A	10.204.96.189
lb-sjc5-vlan1074-selfip-1 A	10.188.118.10
lb-sjc5-vlan1074-selfip-2 A	10.188.118.11
lb-sjc5-vlan1074-selfip-3 A	10.188.118.12
lc1-blr14		A	10.235.252.149
lhr01-cs-ca01		A	10.27.175.143
			AAAA	2a0d:1e00:2043:4e20::2001
lhr01-cs00-ca01		A	10.27.175.141
			AAAA	2a0d:1e00:2043:4e20::2002
lhr01-cs00-ca21		A	10.27.175.142
			AAAA	2a0d:1e00:2043:4e20::2003
lhr01-cs02-ca01		A	10.27.175.144
			AAAA	2a0d:1e00:2043:4e20::2004
lhr01-cs03-ca01		A	10.27.175.145
			AAAA	2a0d:1e00:2043:4e20::2005
lhr01-sd-vce01		A	10.27.180.1
lhr01-sw-core01		A	10.27.175.254
			AAAA	2a0d:1e00:2043:4e20:ffff:ffff:ffff:ff7f
lhr01-sw-dmz01		A	10.27.175.253
			AAAA	2a0d:1e00:2043:4e20::1
lhr01-sw-fp01		A	10.27.175.211
			AAAA	2a0d:1e00:2043:4e20::2
lhr01-sw-fp02		A	10.27.175.212
			AAAA	2a0d:1e00:2043:4e20::3
lhr01-sw00-av01		A	10.27.175.181
			AAAA	2a0d:1e00:2043:4e20::4001
lhr01-sw00-av21		A	10.27.175.182
			AAAA	2a0d:1e00:2043:4e20::4002
lhr01-sw00-ua01		A	10.27.175.151
			AAAA	2a0d:1e00:2043:4e20::5001
lhr01-sw00-ua21		A	10.27.175.152
			AAAA	2a0d:1e00:2043:4e20::5002
lhr01-sw00-wa01		A	10.27.175.171
			AAAA	2a0d:1e00:2043:4e20::3001
lhr01-sw00-wa21		A	10.27.175.172
			AAAA	2a0d:1e00:2043:4e20::3002
lhr01-sw01-ma01		A	10.27.175.252
			AAAA	2a0d:1e00:2043:4e20::1001
lhr01-sw01-pa01		A	10.27.175.129
			AAAA	2a0d:1e00:2043:4e20::6001
lhr01-sw01-ua01		A	10.27.175.153
			AAAA	2a0d:1e00:2043:4e20::5003
lhr01-sw01-wa01		A	10.27.175.173
			AAAA	2a0d:1e00:2043:4e20::3003
lhr01-sw02-ua01		A	10.27.175.154
			AAAA	2a0d:1e00:2043:4e20::5004
lhr01-sw02-wa01		A	10.27.175.174
			AAAA	2a0d:1e00:2043:4e20::3004
lhr01-sw03-av01		A	10.27.175.185
			AAAA	2a0d:1e00:2043:4e20::4003
lhr01-sw03-ua01		A	10.27.175.155
			AAAA	2a0d:1e00:2043:4e20::5005
lhr01-sw03-wa01		A	10.27.175.175
			AAAA	2a0d:1e00:2043:4e20::3005
lhr01-wc-lc01		A	10.27.173.250
			AAAA	2a0d:1e00:2043:22e0::1
lhr01-wc-lc02		A	10.27.173.251
			AAAA	2a0d:1e00:2043:22e0::2
lhr06-cs-ca01		A	10.204.32.151
			AAAA	2a0d:1e00:2040:4e20::2001
lhr06-cs01-ca21		A	10.204.32.152
			AAAA	2a0d:1e00:2040:4e20::2002
lhr06-fw-eg01		A	10.204.32.133
			AAAA	2a0d:1e00:2040:4e20::4
lhr06-fw-eg02		A	10.204.32.134
			AAAA	2a0d:1e00:2040:4e20::5
lhr06-sd-vce01		A	10.204.32.1
lhr06-sw-core01		A	10.204.32.190
			AAAA	2a0d:1e00:2040:4e20:ffff:ffff:ffff:ff7f
lhr06-sw-dmz01		A	10.204.32.131
			AAAA	2a0d:1e00:2040:4e20::1
lhr06-sw-fp01		A	10.204.32.141
			AAAA	2a0d:1e00:2040:4e20::2
lhr06-sw-fp02		A	10.204.32.142
			AAAA	2a0d:1e00:2040:4e20::3
lhr06-sw01-av01		A	10.204.32.165
			AAAA	2a0d:1e00:2040:4e20::4001
lhr06-sw01-av21		A	10.204.32.166
			AAAA	2a0d:1e00:2040:4e20::4002
lhr06-sw01-ma01		A	10.204.32.171
			AAAA	2a0d:1e00:2040:4e20::1001
lhr06-sw01-ma21		A	10.204.32.172
			AAAA	2a0d:1e00:2040:4e20::1002
lhr06-sw01-pa01		A	10.204.32.175
			AAAA	2a0d:1e00:2040:4e20::6001
lhr06-sw01-ua01		A	10.204.32.155
			AAAA	2a0d:1e00:2040:4e20::5001
lhr06-sw01-ua02		A	10.204.32.156
			AAAA	2a0d:1e00:2040:4e20::5002
lhr06-sw01-ua21		A	10.204.32.157
			AAAA	2a0d:1e00:2040:4e20::5003
lhr06-sw01-wa01		A	10.204.32.161
			AAAA	2a0d:1e00:2040:4e20::3001
lhr06-sw01-wa21		A	10.204.32.162
			AAAA	2a0d:1e00:2040:4e20::3002
lhr06-sw02-av01		A	10.204.32.167
			AAAA	2a0d:1e00:2040:4e20::4003
lhr06-sw02-ua01		A	10.204.32.158
			AAAA	2a0d:1e00:2040:4e20::5004
lhr06-sw02-wa01		A	10.204.32.163
			AAAA	2a0d:1e00:2040:4e20::3003
lhr06-wc-lc01		A	10.204.33.81
lhr06-wc-lc02		A	10.204.33.82
lhr07-fw-egp01		A	10.204.32.187
lhr07-fw-egp02		A	10.204.32.188
lhr07-sd-vce02		A	10.204.32.189
lin02-cs-ca01		A	10.98.130.21
			AAAA	2a0d:1e00:4040:4e20::2001
lin02-fw-eg01		A	10.98.130.30
lin02-fw-eg02		A	10.98.130.31
lin02-fw-egp01		AAAA	2a0d:1e00:4040:4e20::4
lin02-fw-egp02		AAAA	2a0d:1e00:4040:4e20::5
lin02-sd-vce01		A	10.27.224.1
lin02-sw-core01		A	10.98.130.1
			AAAA	2a0d:1e00:4040:4e20:ffff:ffff:ffff:ff7f
lin02-sw-dmz01		A	10.98.130.32
			AAAA	2a0d:1e00:4040:4e20::1
lin02-sw-fp01		A	10.98.130.22
			AAAA	2a0d:1e00:4040:4e20::2
lin02-sw-fp02		A	10.27.225.12
			AAAA	2a0d:1e00:4040:4e20::3
lin02-sw07-av01		A	10.98.130.27
			AAAA	2a0d:1e00:4040:4e20::4001
lin02-sw07-ma01		A	10.98.130.25
			AAAA	2a0d:1e00:4040:4e20::1001
lin02-sw07-ua01		A	10.98.130.24
			AAAA	2a0d:1e00:4040:4e20::5001
lin02-sw07-wa01		A	10.98.130.26
			AAAA	2a0d:1e00:4040:4e20::3001
lin02-wc-lc01		A	10.27.225.131
			AAAA	2a0d:1e00:4040:22e0::1
lin02-wc-lc02		A	10.27.225.132
			AAAA	2a0d:1e00:4040:22e0::2
lsw1-sof7		CNAME	n9k-ms1-sof07
lsw2-sof7		CNAME	n9k-ms2-sof07
lv01-sw00-pa01		AAAA	2a0d:1e00:8040:4e20::6001
maa04-cs-ca01		A	10.120.135.30
maa04-fw-eg01		A	10.120.135.49
maa04-fw-eg02		A	10.120.135.50
maa04-sw-core01		A	10.120.141.96
maa04-sw-dmz01		A	10.109.120.2
maa04-sw-fp01		A	10.120.135.23
maa04-sw-fp02		A	10.120.135.24
maa04-sw04-av01		A	10.120.135.28
maa04-sw04-ma01		A	10.120.135.25
maa04-sw04-pa01		A	10.120.135.27
maa04-sw04-ua01		A	10.120.135.26
maa04-sw04-wa01		A	10.120.135.29
maa04-wc-lc01		A	10.120.137.2
maa04-wc-lc02		A	10.120.137.3
mad01-cs-ca01		A	10.26.19.251
mad01-cs02-ca01		A	10.26.19.252
mad01-sw-core01		A	10.26.19.254
mad01-sw-dmz01		A	10.26.19.227
mad01-sw-fp01		A	10.26.19.235
mad01-sw-fp02		A	10.26.19.236
mad01-sw02-ua01		A	10.26.19.231
mad01-sw02-wa01		A	10.26.19.228
mad01-sw99-ma01		A	10.26.19.232
mad01-wc-lc01		A	10.26.16.177
mad01-wc-lc02		A	10.26.16.178
mel03-sd-vce01		A	10.117.192.203
mel03-sw-fp01		A	10.117.192.14
mel03-sw-fp02		A	10.117.192.15
mel03-sw14-wa01		A	10.117.192.7
mgmt1-8f-bcn1		AAAA	2a0d:1e00:4043:4e20::1001
mgmt1-8f-pek2		A	10.110.138.110
ms1-atl01		A	10.88.40.42
			AAAA	2606:9680:2040:4e20::6
muc02-cs-ca01		A	10.71.128.157
			AAAA	2a0d:1e00:6042:4e20::3001
			AAAA	2a0d:1e00:6042:4e20::2001
muc02-fw-egp02		AAAA	2a0d:1e00:6042:4e20::5
muc02-sw-core01		A	10.71.128.190
			AAAA	2a0d:1e00:6042:22e0::2
			AAAA	2a0d:1e00:6042:22e0::1
			AAAA	2a0d:1e00:6042:4e20:ffff:ffff:ffff:ff7f
muc02-sw-dmz01		A	10.71.128.151
			AAAA	2a0d:1e00:6042:4e20::1
muc02-sw-fp01		A	10.71.128.141
			AAAA	2a0d:1e00:6042:4e20::2
			AAAA	2a0d:1e00:6042:4e20::4
muc02-sw-fp02		A	10.71.128.142
			AAAA	2a0d:1e00:6042:4e20::3
muc02-sw01-ma01		AAAA	2a0d:1e00:6042:4e20::1001
muc02-sw01-ua01		AAAA	2a0d:1e00:6042:4e20::5001
muc02-sw01-ua02		AAAA	2a0d:1e00:6042:4e20::5002
muc02-sw03-ma01		A	10.71.128.150
muc02-sw03-ua01		A	10.71.128.137
muc02-sw03-ua02		A	10.71.128.138
muc02-sw03-wa01		A	10.71.128.147
n5k01-ams02		A	10.26.211.218
n5k02-ams02		A	10.26.211.219
n9k-lsw1-daas-ams02	A	10.125.64.20
n9k-lsw1-daas-sof02	A	10.30.196.1
n9k-lsw2-daas-ams02	A	10.125.64.19
n9k-lsw2-daas-sof02	A	10.30.196.2
n9k-lsw3-daas-ams02	A	10.27.188.71
n9k-lsw4-daas-ams02	A	10.27.188.72
n9k-ms1-sof07		A	10.93.130.101
n9k-ms2-sof07		A	10.93.130.102
n9k01-borderleaf-ams02	A	10.27.188.101
n9k01-borderleaf-atl01	A	10.88.8.61
n9k01-eng-fp-sjc31	A	10.166.80.27
n9k01-leaf-ams02	A	10.27.188.103
n9k01-leaf-atl01	A	10.88.8.65
n9k01-spine-ams02	A	10.27.188.73
n9k01-spine-atl01	A	10.88.8.63
n9k02-borderleaf-ams02	A	10.27.188.102
n9k02-borderleaf-atl01	A	10.88.8.62
n9k02-eng-fp-sjc31	A	10.166.80.28
n9k02-leaf-ams02	A	10.27.188.104
n9k02-leaf-atl01	A	10.88.8.66
n9k02-spine-ams02	A	10.27.188.74
n9k02-spine-atl01	A	10.88.8.64
n9k03-leaf-atl01	A	10.88.8.67
n9k04-leaf-atl01	A	10.88.8.68
n9k15-leaf-sjc31	A	10.166.80.51
n9k16-leaf-sjc31	A	10.166.80.52
n9k17-leaf-sjc31	A	10.166.80.55
n9k18-leaf-sjc31	A	10.166.80.56
n9k33-leaf-eat1		A	10.128.166.6
n9k34-leaf-eat1		A	10.128.166.7
n9k35-leaf-sjc05	A	10.188.7.129
n9k36-leaf-sjc05	A	10.188.7.130
n9k43-leaf-sjc05	A	10.188.7.43
n9k44-leaf-sjc05	A	10.188.7.44
n9k45-leaf-sjc05	A	10.188.7.45
n9k46-leaf-sjc05	A	10.188.7.46
nrt02-cs16-ca01		A	10.65.192.115
			AAAA	2402:740:4044:4e20::2001
nrt02-cs17-ca01		A	10.65.192.100
			AAAA	2402:740:4044:4e20::2002
nrt02-cs18-ca01		A	10.65.192.122
			AAAA	2402:740:4044:4e20::2003
nrt02-eng-core01	AAAA	2402:740:4044:4e20::6
nrt02-eng-core02	AAAA	2402:740:4044:4e20::7
nrt02-fw-egp01		A	10.65.192.102
			AAAA	2402:740:4044:4e20::4
nrt02-fw-egp02		A	10.65.192.103
			AAAA	2402:740:4044:4e20::5
nrt02-rt-ig01		A	10.217.192.5
nrt02-rt-ig02		A	10.217.192.6
nrt02-rt-mpls01		A	10.217.192.31
nrt02-rt-mpls02		A	10.217.192.32
nrt02-rt-rr01		A	10.217.192.33
nrt02-rt-rr02		A	10.217.192.34
nrt02-rt-rrig01		A	10.217.192.7
nrt02-rt-rrig02		A	10.217.192.8
nrt02-sd-vce01		A	10.22.20.68
nrt02-sw-core01		A	10.65.192.1
			AAAA	2402:740:4044:4e20:ffff:ffff:ffff:ff7f
nrt02-sw-dmz01		A	10.65.192.101
			AAAA	2402:740:4044:4e20::1
nrt02-sw-fp01		A	10.65.192.104
			AAAA	2402:740:4044:4e20::2
nrt02-sw-fp02		A	10.65.192.105
			AAAA	2402:740:4044:4e20::3
nrt02-sw16-av01		A	10.65.192.118
			AAAA	2402:740:4044:4e20::4001
nrt02-sw16-ma01		A	10.65.192.117
			AAAA	2402:740:4044:4e20::1001
nrt02-sw16-ma02		A	10.65.192.129
			AAAA	2402:740:4044:4e20::1002
nrt02-sw16-pa01		A	10.65.192.116
			AAAA	2402:740:4044:4e20::6001
nrt02-sw16-ua01		A	10.65.192.112
			AAAA	2402:740:4044:4e20::5001
nrt02-sw16-wa01		A	10.65.192.114
			AAAA	2402:740:4044:4e20::3001
nrt02-sw17-av01		A	10.65.192.107
			AAAA	2402:740:4044:4e20::4002
nrt02-sw17-ma01		A	10.65.192.106
			AAAA	2402:740:4044:4e20::1003
nrt02-sw17-pa01		A	10.65.192.108
			AAAA	2402:740:4044:4e20::6002
nrt02-sw17-ua01		A	10.65.192.109
			AAAA	2402:740:4044:4e20::5002
nrt02-sw17-ua02		A	10.65.192.110
			AAAA	2402:740:4044:4e20::5003
nrt02-sw17-wa01		A	10.65.192.111
			AAAA	2402:740:4044:4e20::3002
nrt02-sw18-av01		A	10.65.192.121
			AAAA	2402:740:4044:4e20::4003
nrt02-sw18-av02		A	10.65.192.113
			AAAA	2402:740:4044:4e20::4004
nrt02-sw18-ma01		A	10.65.192.124
			AAAA	2402:740:4044:4e20::1004
nrt02-sw18-pa01		A	10.65.192.123
			AAAA	2402:740:4044:4e20::6003
nrt02-sw18-ua01		A	10.65.192.119
			AAAA	2402:740:4044:4e20::5004
nrt02-sw18-ua02		A	10.65.192.120
			AAAA	2402:740:4044:4e20::5005
nrt02-sw18-wa01		A	10.65.192.125
			AAAA	2402:740:4044:4e20::3003
nrt02-wc-lc01		A	10.65.193.2
			AAAA	2402:740:4044:400::1
nrt02-wc-lc02		A	10.65.193.3
			AAAA	2402:740:4044:400::2
ns1-bzti-eat01		A	10.200.9.196
ns1-bzti-eat3		A	10.200.9.196
ns1-dmz-sjc05		A	10.188.245.175
ns1-eqx-sea03		A	10.98.90.60
ns1-eqx-sjc31		A	10.232.11.252
			A	10.232.11.251
ns1-ob1-iad03		A	10.95.49.1
ns1-vdr-sea03		A	10.81.17.1
ns1-yyz01		A	10.201.133.1
ns2-bzti-eat01		A	10.200.9.197
ns2-bzti-eat3		A	10.200.9.197
ns2-dmz-sjc05		A	10.188.245.176
ns2-eqx-sea03		A	10.98.90.58
ns2-eqx-sjc31		A	10.232.11.252
ns2-ob1-iad03		A	10.95.49.2
ns2-vdr-sea03		A	10.81.17.2
nsslab-vc		A	10.90.20.70
ntp1-eat01		A	10.128.243.105
ntp1-sin02		A	10.111.0.93
ntp1-sof02		A	10.23.108.66
ntp2-eat01		A	10.128.243.106
ntp2-sin02		A	10.111.0.94
ntp2-sof02		A	10.23.108.67
ntp3-bzti-eat1		A	10.200.9.198
ntp3-bzti-eat3		A	10.200.9.198
ntp3-sof02		A	10.23.108.160
nxs1-ork1		A	10.66.48.4
nxs1-ork3		A	10.66.44.6
nxs2-ork1		A	10.66.48.5
nxs2-ork3		A	10.66.44.7
nzt-ansible		A	10.253.21.45
oasis-locker-csg	A	10.33.130.4
oasis-locker-htc	A	10.33.166.130
oasis-locker-proma	A	10.20.144.5
office1-1f-pao16	CNAME	pao16-sw01-ua01
office1-1f-pao27-oob	A	10.18.250.211
office1-1f-pao33-oob	A	10.18.251.26
office1-2f-f32-sjo1	AAAA	2801:1d4:40:4e22::5001
office1-2nd-ork3	A	10.26.163.253
office1-5f-f33-sjo1	AAAA	2801:1d4:40:4e22::5004
office1-6f-del2		A	10.119.193.224
			AAAA	2402:740:47:4e20::5001
office1-8f-bcn1		AAAA	2a0d:1e00:4043:4e20::5001
office1-gnd-ork3	A	10.16.140.32
office1-icn1		AAAA	2402:740:4046:4e20::5001
office11-8f-atl01	A	10.88.8.141
office12-8f-atl01	A	10.88.8.173
office16-tfb-atl01	A	10.88.8.163
office2-2nd-ork3	A	10.26.165.253
office2-3f-f32-sjo1	AAAA	2801:1d4:40:4e20::5002
office2-5f-f33-sjo1	AAAA	2801:1d4:40:4e22::5005
office2-8f-bcn1		AAAA	2a0d:1e00:4043:4e20::5002
office2-gnd-ork3	A	10.16.140.33
office3-4f-den1		AAAA	2606:9680:2045:4e20::5001
office3-5f-f32-sjo1	AAAA	2801:1d4:40:4e22::5003
office3-5f-f33-sjo1	AAAA	2801:1d4:40:4e22::5006
office4-22f-sea2	A	10.62.1.14
office4-3f-atl01	A	10.88.8.136
office4-4f-den1		AAAA	2606:9680:2045:4e20::5002
office4-5f-f33-sjo1	A	10.25.224.153
			AAAA	2801:1d4:40:4e22::5007
office5th1-den1		AAAA	2606:9680:2045:4e20::5003
office5th2-den1		AAAA	2606:9680:2045:4e20::5004
office6-4f-atl01	A	10.88.8.137
office8-5f-atl01	A	10.88.8.138
ord01-cs01-ca01		A	10.204.176.184
ord01-fw-eg01		A	10.204.176.182
ord01-fw-eg02		A	10.204.176.183
ord01-sd-vce01		A	10.204.176.188
ord01-sw01-ua01		A	10.204.176.185
ord01-sw01-ua02		A	10.204.176.186
ord01-sw01-ua03		A	10.204.176.187
ore1-den1		AAAA	2606:9680:2045:4e20:ffff:ffff:ffff:ff7f
ork01-cs-ca01		A	10.66.48.2
			AAAA	2a0d:1e00:2042:3e20::2001
ork01-cs01-ca01		A	10.66.48.3
			AAAA	2a0d:1e00:2042:3e20::2002
ork01-sw-core01		A	10.66.48.1
			AAAA	2a0d:1e00:2042:3e20:ffff:ffff:ffff:ff7f
ork01-sw00-av01		A	10.66.48.23
			AAAA	2a0d:1e00:2042:3e20::4001
ork01-sw00-ta01		A	10.66.48.11
ork01-sw00-ua01		A	10.66.48.6
			AAAA	2a0d:1e00:2042:3e20::5003
ork01-sw00-ua02		A	10.66.48.7
			AAAA	2a0d:1e00:2042:3e20::5004
ork01-sw00-ua03		A	10.66.48.8
			AAAA	2a0d:1e00:2042:3e20::5005
ork01-sw00-va01		A	10.23.135.250
ork01-sw00-va02		A	10.26.65.252
ork01-sw01-av01		A	10.66.48.15
			AAAA	2a0d:1e00:2042:3e20::4002
ork01-sw01-ua01		A	10.66.48.12
			AAAA	2a0d:1e00:2042:3e20::5006
ork01-sw01-ua02		A	10.66.48.13
			AAAA	2a0d:1e00:2042:3e20::5007
ork01-sw01-va01		A	10.23.135.251
ork01-sw01-va02		A	10.26.65.253
ork01-sw01-wa01		A	10.66.48.14
			AAAA	2a0d:1e00:2042:3e20::3002
ork01-swlg-ma01		A	10.66.48.21
			AAAA	2a0d:1e00:2042:3e20::1001
ork01-swlg-ua01		A	10.66.48.18
			AAAA	2a0d:1e00:2042:3e20::5001
ork01-swlg-ua02		A	10.66.48.19
			AAAA	2a0d:1e00:2042:3e20::5002
ork01-swlg-va01		A	10.66.41.69
ork01-swlg-va02		A	10.66.41.74
ork01-swlg-wa01		A	10.66.48.20
			AAAA	2a0d:1e00:2042:3e20::3001
ork02-cs-ca01		A	10.66.34.19
ork02-cs-ca02		A	10.66.34.20
ork02-cs-ca03		A	10.66.34.21
ork02-fw-egp01		A	10.66.34.5
ork02-fw-egp02		A	10.66.34.6
ork02-sw-core01		A	10.66.34.1
ork02-sw-dmz01		A	10.23.190.3
ork02-sw-fp01		A	10.66.34.3
ork02-sw-fp02		A	10.66.34.4
ork02-sw01-av01		A	10.66.34.9
ork02-sw01-ta01		A	10.66.34.11
ork02-sw01-ua01		A	10.66.34.7
ork02-sw01-va01		A	10.23.133.253
ork02-sw01-wa01		A	10.66.34.8
ork02-swlg-av01		A	10.66.34.16
ork02-swlg-ma01		A	10.66.34.12
ork02-swlg-ma02		A	10.66.34.13
ork02-swlg-ua01		A	10.66.34.14
ork02-swlg-va01		A	10.66.41.70
ork02-swlg-va02		A	10.66.41.71
ork02-swlg-wa01		A	10.66.34.15
ork02-wc-lc01		A	10.26.160.121
ork02-wc-lc02		A	10.26.160.122
ork03-cs-ca01		A	10.66.44.5
			AAAA	2a0d:1e00:2042:5e20::2001
ork03-cs-ca01-gss	A	10.66.44.21
ork03-cs-ca02-gss	A	10.66.44.22
ork03-sw-core01		A	10.66.44.1
			AAAA	2a0d:1e00:2042:5e20:ffff:ffff:ffff:ff7f
ork03-sw-gss01		A	10.66.44.2
ork03-sw00-av01		A	10.66.44.13
			AAAA	2a0d:1e00:2042:5e20::4001
ork03-sw00-ma01		A	10.66.44.9
			AAAA	2a0d:1e00:2042:5e20::1001
ork03-sw00-ua01		A	10.66.44.10
			AAAA	2a0d:1e00:2042:5e20::5001
ork03-sw00-ua02		A	10.66.44.11
			AAAA	2a0d:1e00:2042:5e20::5002
ork03-sw00-va01		A	10.16.140.210
			A	10.66.41.73
ork03-sw00-va02		A	10.16.140.211
			A	10.66.41.72
ork03-sw00-wa01		A	10.66.44.12
			AAAA	2a0d:1e00:2042:5e20::3001
ork03-sw02-ua01		A	10.66.44.16
			AAAA	2a0d:1e00:2042:5e20::5003
ork03-sw02-ua02		A	10.66.44.17
			AAAA	2a0d:1e00:2042:5e20::5004
ork03-sw02-va01		A	10.23.137.253
ork03-sw02-va02		A	10.23.139.253
ork03-sw02-wa01		A	10.66.44.18
			AAAA	2a0d:1e00:2042:5e20::3002
ork04-cs-ca01		A	10.30.16.210
ork04-sw-core01		A	10.30.16.206
ork04-swlg-av01		A	10.30.16.193
ork04-swlg-ua01		A	10.30.16.194
ork04-swlg-va01		A	10.16.140.214
ork04-swlg-wa01		A	10.30.16.195
ork05-cs-ca01		A	10.30.17.10
ork05-sw-core01		A	10.16.140.45
ork05-sw00-av01		A	10.30.17.3
ork05-sw00-ma01		A	10.30.17.61
ork05-sw00-ua01		A	10.30.17.1
ork05-sw00-ua02		A	10.30.17.2
ork05-sw00-va01		A	10.16.140.230
ork05-sw00-va02		A	10.16.140.231
ork05-sw00-wa01		A	10.30.17.12
ork06-cs-ca01		A	10.30.17.70
			AAAA	2a0d:1e00:2042:7e20::2001
ork06-kiosk		A	10.27.132.161
ork06-sw-core01		A	10.30.17.126
			AAAA	2a0d:1e00:2042:7e20:ffff:ffff:ffff:ff7f
ork06-sw00-av01		A	10.30.17.67
			AAAA	2a0d:1e00:2042:7e20::4001
ork06-sw00-ma01		A	10.30.17.125
			AAAA	2a0d:1e00:2042:7e20::1001
ork06-sw00-ua01		A	10.30.17.65
			AAAA	2a0d:1e00:2042:7e20::5001
ork06-sw00-ua02		A	10.30.17.66
			AAAA	2a0d:1e00:2042:7e20::5002
ork06-sw00-va01		A	10.16.140.19
ork06-sw00-va02		A	10.16.140.20
ork06-sw00-wa01		A	10.30.17.69
			AAAA	2a0d:1e00:2042:7e20::3001
ork09-cs01-ca01		A	10.207.1.56
ork09-fw-egp01		A	10.207.1.54
ork09-fw-egp02		A	10.207.1.55
ork09-sd-vce01		A	10.207.1.60
ork09-sd-vce02		A	10.207.1.61
ork09-sw-core01		A	10.207.1.62
ork09-sw01-ua01		A	10.207.1.57
ork09-sw01-ua02		A	10.207.1.58
ork09-sw01-ua03		A	10.207.1.59
panorama-prd-sjc07	A	10.212.1.1
pao11-cs-ca01		A	10.211.110.6
pao11-cs01-ca01		A	10.211.110.4
pao11-ns01-nm01		A	10.20.68.27
pao11-ns02-nm01		A	10.20.72.80
pao11-sw-core01		A	10.211.36.1
pao11-sw01-av01		A	10.211.36.21
pao11-sw01-av21		A	10.211.36.25
pao11-sw01-oob02	A	10.211.110.3
pao11-sw01-oob21	A	10.211.110.5
pao11-sw01-ua01		A	10.211.36.22
pao11-sw01-ua02		A	10.211.36.23
pao11-sw01-ua21		A	10.211.36.26
pao11-sw01-ua22		A	10.211.36.27
pao11-sw01-wa01		A	10.211.36.24
pao11-sw01-wa01-oob	A	10.18.251.4
pao11-sw01-wa21		A	10.211.36.28
pao11-sw01-wa21-oob	A	10.18.251.5
pao11-sw02-av01		A	10.211.36.29
pao12-cs-ca01		A	10.211.110.10
pao12-cs01-ca21		A	10.211.110.12
pao12-cs01-ca31		A	10.211.110.8
pao12-fw-wl-eg01	A	10.18.250.58
pao12-fw-wl-eg02	A	10.18.250.59
pao12-ns01-nm01		A	10.20.80.236
pao12-ns02-nm01		A	10.20.92.245
pao12-sw-core01		A	10.211.44.1
pao12-sw-core02		A	10.211.110.1
pao12-sw-fp01		A	10.211.57.33
pao12-sw-fp02		A	10.211.57.34
pao12-sw01-av01		A	10.211.44.21
pao12-sw01-av01-oob	A	10.18.250.158
pao12-sw01-av21		A	10.211.44.25
pao12-sw01-av21-oob	A	10.18.250.159
pao12-sw01-oob01	A	10.211.110.9
pao12-sw01-oob21	A	10.211.110.11
pao12-sw01-oob31	A	10.211.110.7
pao12-sw01-pa01		A	10.211.44.22
pao12-sw01-pa01-oob	A	10.18.251.24
pao12-sw01-pa21		A	10.211.44.26
pao12-sw01-pa21-oob	A	10.18.251.25
pao12-sw01-show31	A	10.211.110.2
pao12-sw01-temp		A	10.211.57.32
pao12-sw01-temp-oob	A	10.18.251.6
pao12-sw01-ua01		A	10.211.44.23
pao12-sw01-ua01-oob	A	10.18.250.156
pao12-sw01-ua21		A	10.211.44.27
pao12-sw01-ua21-oob	A	10.18.250.157
pao12-sw01-wa01		A	10.211.44.24
pao12-sw01-wa01-oob	A	10.18.251.20
pao12-sw01-wa21		A	10.211.44.28
pao12-sw01-wa21-oob	A	10.18.251.21
pao12-wc-lc-poc		A	10.18.250.186
pao12-wc-lc01		A	10.211.20.2
pao12-wc-lc02		A	10.211.20.3
pao12-wc-lc03		A	10.211.20.4
pao12-wc-lc04		A	10.211.20.5
pao13-cs-ca01		A	10.211.110.14
pao13-cs01-ca21		A	10.211.110.16
pao13-cs02-ca01		A	10.211.110.18
pao13-cs02-ca21		A	10.211.110.20
pao13-ns01-nm01		A	10.20.105.54
pao13-ns02-nm01		A	10.20.104.42
pao13-sw-core01		A	10.211.52.1
pao13-sw01-oob01	A	10.211.110.13
pao13-sw01-oob21	A	10.211.110.15
pao13-sw01-show01	A	10.211.110.100
pao13-sw01-ua01		A	10.211.52.21
pao13-sw01-ua02		A	10.211.52.22
pao13-sw01-ua21		A	10.211.52.23
pao13-sw01-ua22		A	10.211.52.24
pao13-sw01-wa01-oob	A	10.18.251.7
pao13-sw01-wa21-oob	A	10.18.251.8
pao13-sw02-oob01	A	10.211.110.17
pao13-sw02-oob21	A	10.211.110.19
pao13-sw02-ua01		A	10.211.52.25
pao13-sw02-ua02		A	10.211.52.26
pao13-sw02-ua03		A	10.211.52.27
pao13-sw02-ua21		A	10.211.52.29
pao13-sw02-ua22		A	10.211.52.30
pao13-sw02-ua23		A	10.211.52.31
pao13-sw02-wa01		A	10.211.52.28
pao13-sw02-wa01-oob	A	10.18.251.9
pao13-sw02-wa21		A	10.211.52.32
pao13-sw02-wa21-oob	A	10.18.251.10
pao14-cs-ca01		A	10.211.110.24
pao14-cs01-ca01		A	10.211.110.22
pao14-ns01-nm01		A	10.20.117.174
pao14-ns02-nm01		A	10.20.121.0
pao14-sw-core01		A	10.211.57.1
pao14-sw01-av01		A	10.211.57.21
pao14-sw01-av21		A	10.211.57.26
pao14-sw01-oob01	A	10.211.110.21
pao14-sw01-oob21	A	10.211.110.23
pao14-sw01-ua01		A	10.211.57.22
pao14-sw01-ua02		A	10.211.57.23
pao14-sw01-ua03		A	10.211.57.24
pao14-sw01-ua21		A	10.211.57.27
pao14-sw01-ua22		A	10.211.57.28
pao14-sw01-ua23		A	10.211.57.29
pao14-sw01-ua24		A	10.211.57.30
pao14-sw01-wa01		A	10.211.57.25
pao14-sw01-wa01-oob	A	10.18.251.11
pao14-sw01-wa21		A	10.211.57.31
pao14-sw01-wa21-oob	A	10.18.251.12
pao15-cs-ca01		A	10.211.110.26
pao15-cs00-ca01		A	10.211.110.30
pao15-cs01-ca21		A	10.211.110.28
pao15-ns01-nm01		A	10.20.129.242
pao15-ns02-nm01		A	10.20.140.54
pao15-sw-core01		A	10.211.68.1
pao15-sw00-oob01	A	10.211.110.29
pao15-sw00-wa01		A	10.211.68.31
pao15-sw00-wa01-oob	A	10.18.251.15
pao15-sw01-av01		A	10.211.68.21
pao15-sw01-av21		A	10.211.68.26
pao15-sw01-oob01	A	10.211.110.25
pao15-sw01-oob21	A	10.211.110.27
pao15-sw01-ua01		A	10.211.68.22
pao15-sw01-ua02		A	10.211.68.23
pao15-sw01-ua03		A	10.211.68.24
pao15-sw01-ua21		A	10.211.68.27
pao15-sw01-ua22		A	10.211.68.28
pao15-sw01-ua23		A	10.211.68.29
pao15-sw01-wa01		A	10.211.68.25
pao15-sw01-wa01-oob	A	10.18.251.13
pao15-sw01-wa21		A	10.211.68.30
pao15-sw01-wa21-oob	A	10.18.251.14
pao16-cs-ca01		A	10.211.110.32
pao16-ns01-nm01		A	10.20.150.232
pao16-sw01-oob01	A	10.211.110.31
pao16-sw01-show01	A	10.211.110.101
pao16-sw01-ua01		A	10.211.57.35
pao16-sw01-wa01		A	10.211.57.36
pao16-sw01-wa01-oob	A	10.18.251.16
pao23-cs-ca01		A	10.211.110.34
pao23-ns03-nm01		A	10.24.103.55
pao23-sw-core01		A	10.211.106.1
pao23-sw01-oob01	A	10.211.110.33
pao23-sw01-ua01		A	10.211.106.21
pao23-sw01-ua02		A	10.211.106.22
pao23-sw01-wa01		A	10.211.106.23
pao23-sw01-wa01-oob	A	10.18.251.17
pao23-sw03-av01		A	10.211.106.24
pao23-sw03-wa01		A	10.211.106.25
pao23-sw03-wa01-oob	A	10.18.251.18
pao24-cs-ca01		A	10.211.110.79
pao24-cs01-ca22		A	10.211.110.83
pao24-cs01-test		A	10.18.251.250
pao24-cs02-ca01		A	10.211.110.81
pao24-ns01-nm01		A	10.33.10.136
pao24-ns02-nm01		A	10.33.14.203
pao24-sw-core01		A	10.211.88.129
pao24-sw-fp01		A	10.211.88.155
pao24-sw-fp02		A	10.211.88.156
pao24-sw01-oob01	A	10.211.110.78
pao24-sw01-oob21	A	10.211.110.82
pao24-sw01-pg01		A	10.211.88.161
pao24-sw01-pg02		A	10.211.88.162
pao24-sw01-ua01		A	10.211.88.157
pao24-sw01-ua02		A	10.211.88.158
pao24-sw01-ua03		A	10.211.88.159
pao24-sw01-ua21		A	10.211.88.167
pao24-sw01-ua22		A	10.211.88.168
pao24-sw01-wa01		A	10.211.88.160
pao24-sw01-wa01-oob	A	10.18.250.215
pao24-sw02-oob01	A	10.211.110.80
pao24-sw02-ua01		A	10.211.88.163
pao24-sw02-ua02		A	10.211.88.164
pao24-sw02-ua03		A	10.211.88.165
pao24-sw02-wa01		A	10.211.88.166
pao24-sw02-wa01-oob	A	10.18.250.216
pao24-test-c3850	A	10.18.251.252
pao24-test-c9300	A	10.18.251.251
pao25-sw01-ua01		A	10.211.88.151
pao25-sw01-wa01		A	10.211.88.152
pao25-sw01-wa01-oob	A	10.18.250.214
pao26-sw00-ua01		A	10.211.88.153
pao26-sw01-ua01		A	10.211.88.154
pao27-cs-ca01		A	10.211.110.85
pao27-ns01-nm01		A	10.32.7.160
pao27-sw01-oob01	A	10.211.110.84
pao27-sw01-ua01		A	10.211.88.169
pao27-sw01-ua02		A	10.211.88.170
pao27-sw01-wa01		A	10.211.88.171
pao27-sw01-wa01-oob	A	10.18.250.217
pao28-cs-ca01		A	10.211.110.87
pao28-cs01-ca02		A	10.211.110.88
pao28-cs01-ca21		A	10.211.110.90
pao28-ns01-nm01		A	10.33.106.154
pao28-ns02-nm01		A	10.33.94.134
pao28-sw-core01		A	10.211.94.129
pao28-sw01-av01		A	10.211.94.151
pao28-sw01-av21		A	10.211.94.156
pao28-sw01-oob01	A	10.211.110.86
pao28-sw01-oob21	A	10.211.110.89
pao28-sw01-ua01		A	10.211.94.152
pao28-sw01-ua02		A	10.211.94.153
pao28-sw01-ua03		A	10.211.94.154
pao28-sw01-ua21		A	10.211.94.157
pao28-sw01-ua22		A	10.211.94.158
pao28-sw01-ua23		A	10.211.94.159
pao28-sw01-wa01		A	10.211.94.155
pao28-sw01-wa01-oob	A	10.18.250.218
pao28-sw01-wa21		A	10.211.94.160
pao28-sw01-wa21-oob	A	10.18.250.219
pao29-cs-ca01		A	10.211.110.92
pao29-cs01-ca02		A	10.211.110.93
pao29-cs01-ca21		A	10.211.110.95
pao29-ns01-nm01		A	10.33.114.248
pao29-ns02-nm01		A	10.33.118.178
pao29-sw-core01		A	10.211.97.1
pao29-sw01-av01		A	10.211.97.21
pao29-sw01-oob01	A	10.211.110.91
pao29-sw01-oob21	A	10.211.110.94
pao29-sw01-ua01		A	10.211.97.22
pao29-sw01-ua02		A	10.211.97.23
pao29-sw01-ua03		A	10.211.97.24
pao29-sw01-ua21		A	10.211.97.26
pao29-sw01-ua22		A	10.211.97.27
pao29-sw01-ua23		A	10.211.97.28
pao29-sw01-wa01		A	10.211.97.25
pao29-sw01-wa01-oob	A	10.18.250.220
pao29-sw01-wa21		A	10.211.97.29
pao29-sw01-wa21-oob	A	10.18.250.222
pao30-cs-ca01		A	10.211.110.66
pao30-cs01-ca02		A	10.211.110.67
pao30-cs02-ca01		A	10.211.110.69
pao30-cs03-ca01		A	10.211.110.71
pao30-ns01-nm01		A	10.33.32.250
pao30-ns02-nm01		A	10.32.25.14
pao30-sw-core01		A	10.211.80.65
pao30-sw-fp01		A	10.211.80.102
pao30-sw-fp02		A	10.211.80.103
pao30-sw01-oob01	A	10.211.110.64
pao30-sw01-oob02	A	10.211.110.65
pao30-sw01-pg01		A	10.211.80.126
pao30-sw01-show01	A	10.211.110.103
pao30-sw01-ua01		A	10.211.80.104
pao30-sw01-ua02		A	10.211.80.105
pao30-sw01-ua03		A	10.211.80.106
pao30-sw01-wa01		A	10.211.80.107
pao30-sw01-wa01-oob	A	10.18.250.255
pao30-sw02-oob01	A	10.211.110.68
pao30-sw02-ua01		A	10.211.80.108
pao30-sw02-ua02		A	10.211.80.109
pao30-sw02-ua03		A	10.211.80.110
pao30-sw02-wa01		A	10.211.80.111
pao30-sw02-wa01-oob	A	10.18.251.0
pao30-sw03-oob01	A	10.211.110.70
pao30-sw03-ua01		A	10.211.80.112
pao30-sw03-ua02		A	10.211.80.113
pao30-sw03-ua03		A	10.211.80.114
pao30-sw03-wa01		A	10.211.80.125
pao30-sw03-wa01-oob	A	10.18.251.1
pao31-cs-ca01		A	10.211.110.39
pao31-cs01-ca02		A	10.211.110.40
pao31-cs01-ca21		A	10.211.110.42
pao31-cs03-ca01		A	10.211.110.36
pao31-ns01-nm01		A	10.33.43.21
pao31-ns02-nm01		A	10.32.30.23
pao31-ns03-nm01		A	10.32.91.198
pao31-sw-core01		A	10.211.73.129
pao31-sw01-oob01	A	10.211.110.37
pao31-sw01-oob02	A	10.211.110.38
pao31-sw01-oob21	A	10.211.110.41
pao31-sw01-show01	A	10.211.110.102
pao31-sw01-ua01		A	10.211.73.185
pao31-sw01-ua02		A	10.211.73.186
pao31-sw01-ua03		A	10.211.73.187
pao31-sw01-ua21		A	10.211.73.189
pao31-sw01-ua22		A	10.211.73.190
pao31-sw01-ua23		A	10.211.73.191
pao31-sw01-wa01		A	10.211.73.188
pao31-sw01-wa01-oob	A	10.18.250.225
pao31-sw01-wa21		A	10.211.73.192
pao31-sw01-wa21-oob	A	10.18.250.226
pao31-sw03-oob01	A	10.211.110.35
pao31-sw03-ua01		A	10.211.73.181
pao31-sw03-ua02		A	10.211.73.182
pao31-sw03-ua03		A	10.211.73.183
pao31-sw03-wa01		A	10.211.73.184
pao31-sw03-wa01-oob	A	10.18.250.227
pao32-cs-ca01		A	10.211.110.44
pao32-cs01-ca02		A	10.211.110.45
pao32-cs01-ca21		A	10.211.110.47
pao32-ns01-nm01		A	10.33.75.50
pao32-ns02-nm01		A	10.33.86.38
pao32-sw-core01		A	10.211.76.129
pao32-sw01-oob01	A	10.211.110.43
pao32-sw01-oob21	A	10.211.110.46
pao32-sw01-ua01		A	10.211.76.161
pao32-sw01-ua02		A	10.211.76.162
pao32-sw01-ua03		A	10.211.76.163
pao32-sw01-ua21		A	10.211.76.165
pao32-sw01-ua22		A	10.211.76.166
pao32-sw01-ua23		A	10.211.76.167
pao32-sw01-wa01		A	10.211.76.164
pao32-sw01-wa01-oob	A	10.18.250.228
pao32-sw01-wa21		A	10.211.76.168
pao32-sw01-wa21-oob	A	10.18.250.229
pao33-cs-ca01		A	10.211.110.49
pao33-ns02-nm01		A	10.33.40.181
pao33-sw01-oob01	A	10.211.110.48
pao33-sw01-ua01		A	10.211.80.66
pao33-sw01-ua02		A	10.211.80.67
pao33-sw01-ua03		A	10.211.80.68
pao33-sw01-wa01		A	10.211.80.69
pao33-sw01-wa01-oob	A	10.18.250.230
pao35-cs-ca01		A	10.211.110.52
pao35-cs01-ca02		A	10.211.110.53
pao35-cs01-ca21		A	10.211.110.55
pao35-cs01-test		A	10.18.251.254
pao35-cs02-ca01		A	10.211.110.57
pao35-cs02-ca21		A	10.211.110.59
pao35-cs03-ca01		A	10.211.110.61
pao35-cs03-ca21		A	10.211.110.63
pao35-ns01-nm01		A	10.33.50.27
pao35-ns02-nm01		A	10.33.59.129
pao35-ns02-nm02		A	10.32.37.203
pao35-ns03-nm01		A	10.32.39.172
pao35-ns03-nm02		A	10.33.63.237
pao35-sw-core01		A	10.211.84.129
pao35-sw01-oob01	A	10.211.110.50
pao35-sw01-oob02	A	10.211.110.51
pao35-sw01-oob21	A	10.211.110.54
pao35-sw01-show01	A	10.211.110.105
pao35-sw01-ua01		A	10.211.84.191
pao35-sw01-ua02		A	10.211.84.192
pao35-sw01-ua03		A	10.211.84.193
pao35-sw01-ua21		A	10.211.84.195
pao35-sw01-ua22		A	10.211.84.196
pao35-sw01-ua23		A	10.211.84.197
pao35-sw01-wa01		A	10.211.84.194
pao35-sw01-wa01-oob	A	10.18.250.231
pao35-sw01-wa21		A	10.211.84.198
pao35-sw01-wa21-oob	A	10.18.250.232
pao35-sw02-oob01	A	10.211.110.56
pao35-sw02-oob21	A	10.211.110.58
pao35-sw02-ua01		A	10.211.84.199
pao35-sw02-ua02		A	10.211.84.200
pao35-sw02-ua03		A	10.211.84.201
pao35-sw02-ua21		A	10.211.84.203
pao35-sw02-ua22		A	10.211.84.204
pao35-sw02-ua23		A	10.211.84.205
pao35-sw02-wa01		A	10.211.84.202
pao35-sw02-wa01-oob	A	10.18.250.233
pao35-sw02-wa21		A	10.211.84.206
pao35-sw02-wa21-oob	A	10.18.250.234
pao35-sw03-oob01	A	10.211.110.60
pao35-sw03-oob21	A	10.211.110.62
pao35-sw03-ua01		A	10.211.84.207
pao35-sw03-ua02		A	10.211.84.208
pao35-sw03-ua03		A	10.211.84.209
pao35-sw03-ua21		A	10.211.84.211
pao35-sw03-ua22		A	10.211.84.212
pao35-sw03-ua23		A	10.211.84.213
pao35-sw03-wa01		A	10.211.84.210
pao35-sw03-wa01-oob	A	10.18.250.253
pao35-sw03-wa21		A	10.211.84.214
pao35-sw03-wa21-oob	A	10.18.250.254
pao36-cs-ca01		A	10.211.110.73
pao36-cs01-ca21		A	10.211.110.77
pao36-cs02-ca01		A	10.211.110.75
pao36-ns01-nm01		A	10.33.151.146
pao36-ns02-nm01		A	10.33.162.187
pao36-sw-core01		A	10.211.115.129
pao36-sw01-av01		A	10.211.115.144
pao36-sw01-av21		A	10.211.115.151
pao36-sw01-oob01	A	10.211.110.72
pao36-sw01-oob21	A	10.211.110.76
pao36-sw01-ua01		A	10.32.63.11
pao36-sw01-ua02		A	10.211.115.141
pao36-sw01-ua03		A	10.211.115.142
pao36-sw01-ua04		A	10.211.115.143
pao36-sw01-ua21		A	10.211.115.149
pao36-sw01-ua22		A	10.32.63.33
pao36-sw01-ua23		A	10.211.115.150
pao36-sw01-wa01		A	10.211.115.153
pao36-sw01-wa01-oob	A	10.18.251.2
pao36-sw02-av01		A	10.211.115.148
pao36-sw02-oob01	A	10.211.110.74
pao36-sw02-ua01		A	10.32.63.21
pao36-sw02-ua02		A	10.211.115.145
pao36-sw02-ua03		A	10.211.115.146
pao36-sw02-ua04		A	10.211.115.147
pao36-sw02-wa01		A	10.211.115.152
pao36-sw02-wa01-oob	A	10.18.251.3
pao40-cs-ca01		A	10.211.110.97
pao40-cs01-ca21		A	10.211.110.99
pao40-ns01-nm01		A	10.33.138.117
pao40-ns02-nm01		A	10.33.143.66
pao40-sw-core01		A	10.211.100.129
pao40-sw01-av01		A	10.211.100.151
pao40-sw01-av21		A	10.211.100.157
pao40-sw01-oob01	A	10.211.110.96
pao40-sw01-oob21	A	10.211.110.98
pao40-sw01-ua01		A	10.211.100.152
pao40-sw01-ua02		A	10.211.100.153
pao40-sw01-ua03		A	10.211.100.154
pao40-sw01-ua04		A	10.211.100.155
pao40-sw01-ua21		A	10.211.100.158
pao40-sw01-ua22		A	10.211.100.159
pao40-sw01-ua23		A	10.211.100.160
pao40-sw01-ua24		A	10.211.100.161
pao40-sw01-wa01		A	10.211.100.156
pao40-sw01-wa01-oob	A	10.18.250.223
pao40-sw01-wa21		A	10.211.100.162
pao40-sw01-wa21-oob	A	10.18.250.224
pdx03-cs-ca01		A	10.204.64.181
pdx03-fw-eg01		A	10.204.64.131
pdx03-fw-eg02		A	10.204.64.132
pdx03-sd-vce01		A	10.204.64.81
pdx03-sd-vce02		A	10.204.64.189
pdx03-sw-core01		A	10.204.64.190
pdx03-sw-dmz01		A	10.204.64.135
pdx03-sw-fp01		A	10.204.64.171
pdx03-sw-fp02		A	10.204.64.172
pdx03-sw01-av01		A	10.204.64.145
pdx03-sw01-la01		A	10.204.64.165
pdx03-sw01-ma01		A	10.204.64.155
pdx03-sw01-pa01		A	10.204.64.150
pdx03-sw01-ua01		A	10.204.64.141
pdx03-sw01-ua02		A	10.204.64.186
pdx03-sw01-ua03		A	10.204.64.187
pdx03-sw01-wa01		A	10.204.64.160
pdx03-wc-lc01		A	10.204.65.81
pdx03-wc-lc02		A	10.204.65.82
pek02-cs-ca01		A	10.164.128.121
pek02-cs-ca02		A	10.164.128.122
pek02-cs09-ca01		A	10.164.128.123
pek02-cs10-ca01		A	10.164.128.124
pek02-cs17-ca01		A	10.164.128.125
pek02-cs18-ca01		A	10.164.128.126
pek02-sw-dmz01		A	10.164.128.119
pek02-sw-fp01		A	10.110.138.115
pek02-sw-fp02		A	10.164.128.120
pek02-sw01-wa01		A	10.164.128.139
pek02-sw08-wa01		A	10.164.128.138
pek02-sw09-ua01		A	10.117.0.235
pek02-sw09-wa01		A	10.164.128.136
pek02-sw17-wa01		A	10.164.128.134
pek02-sw18-wa01		A	10.164.128.135
pek02-wc-mm		A	10.117.177.23
pek02-wc-mm01		A	10.117.177.21
pek02-wc-mm02		A	10.117.177.22
pek03-cs-ca01		A	10.117.227.18
pek03-cs11-ca01		A	10.117.227.34
pek04-cs01-ca01		A	10.204.128.184
pek04-fw-egp01		A	10.204.128.182
pek04-fw-egp02		A	10.204.128.183
pek04-sd-vce01		A	10.204.128.188
pek04-sd-vce02		A	10.204.128.189
pek04-sw-core01		A	10.204.128.190
pek04-sw01-ua01		A	10.204.128.185
pek04-sw01-ua02		A	10.204.128.186
pek04-sw01-ua03		A	10.204.128.187
pnq04-6f-traning	A	10.205.130.48
pnq04-cs05-ca01		A	10.205.130.55
			AAAA	2402:740:5a:4e20::2001
pnq04-cs05-ca02		A	10.205.130.61
			AAAA	2402:740:5a:4e20::2002
pnq04-cs06-ca01		A	10.205.130.56
			AAAA	2402:740:5a:4e20::2003
pnq04-cs07-ca01		A	10.205.130.57
			AAAA	2402:740:5a:4e20::2004
pnq04-cs07-ca02		A	10.205.130.60
			AAAA	2402:740:5a:4e20::2005
pnq04-cs08-ca01		A	10.205.130.58
			AAAA	2402:740:5a:4e20::2006
pnq04-fw-egp01		A	10.226.1.45
			AAAA	2402:740:5a:4e20::4
pnq04-fw-egp02		A	10.226.1.46
			AAAA	2402:740:5a:4e20::5
pnq04-fw-sc01		A	10.226.1.47
pnq04-fw-sc02		A	10.226.1.48
pnq04-sd-vce01		A	10.22.17.5
pnq04-sw-core01		A	10.226.0.192
			AAAA	2402:740:5a:4e20:ffff:ffff:ffff:ff7f
pnq04-sw-dmz01		A	10.226.1.21
			AAAA	2402:740:5a:4e20::1
pnq04-sw-fp01		A	10.226.1.23
			AAAA	2402:740:5a:4e20::2
pnq04-sw-fp02		A	10.226.1.22
			AAAA	2402:740:5a:4e20::3
pnq04-sw05-av01		A	10.205.130.28
			AAAA	2402:740:5a:4e20::4001
pnq04-sw05-av02		A	10.205.130.78
			AAAA	2402:740:5a:4e20::4002
pnq04-sw05-ma01		A	10.205.130.35
			AAAA	2402:740:5a:4e20::1001
pnq04-sw05-ma02		A	10.205.130.84
			AAAA	2402:740:5a:4e20::1002
pnq04-sw05-pa01		A	10.205.130.41
			AAAA	2402:740:5a:4e20::6001
pnq04-sw05-pa02		A	10.205.130.82
			AAAA	2402:740:5a:4e20::6002
pnq04-sw05-ua01		A	10.205.130.7
			AAAA	2402:740:5a:4e20::5001
pnq04-sw05-ua02		A	10.205.130.8
			AAAA	2402:740:5a:4e20::5002
pnq04-sw05-ua03		A	10.205.130.9
			AAAA	2402:740:5a:4e20::5003
pnq04-sw05-ua04		A	10.205.130.10
			AAAA	2402:740:5a:4e20::5004
pnq04-sw05-ua05		A	10.205.130.74
			AAAA	2402:740:5a:4e20::5005
pnq04-sw05-ua06		A	10.205.130.75
			AAAA	2402:740:5a:4e20::5006
pnq04-sw05-wa01		A	10.205.130.21
			AAAA	2402:740:5a:4e20::3001
pnq04-sw05-wa02		A	10.205.130.80
			AAAA	2402:740:5a:4e20::3002
pnq04-sw06-av01		A	10.226.1.39
			AAAA	2402:740:5a:4e20::4003
pnq04-sw06-ma01		A	10.226.1.43
			AAAA	2402:740:5a:4e20::1003
pnq04-sw06-pa01		A	10.226.1.42
			AAAA	2402:740:5a:4e20::6003
pnq04-sw06-ua01		A	10.226.1.41
			AAAA	2402:740:5a:4e20::5007
pnq04-sw06-ua02		A	10.226.1.51
			AAAA	2402:740:5a:4e20::5008
pnq04-sw06-wa01		A	10.226.1.40
			AAAA	2402:740:5a:4e20::3003
pnq04-sw07-av01		A	10.226.1.44
			AAAA	2402:740:5a:4e20::4004
pnq04-sw07-av02		A	10.226.1.38
			AAAA	2402:740:5a:4e20::4005
pnq04-sw07-ma01		A	10.226.1.37
			AAAA	2402:740:5a:4e20::1004
pnq04-sw07-pa01		A	10.226.1.36
			AAAA	2402:740:5a:4e20::6004
pnq04-sw07-pa02		A	10.226.1.35
			AAAA	2402:740:5a:4e20::6005
pnq04-sw07-ua01		A	10.226.1.34
			AAAA	2402:740:5a:4e20::5009
pnq04-sw07-ua02		A	10.205.130.14
pnq04-sw07-ua03		A	10.226.1.33
			AAAA	2402:740:5a:4e20::5010
pnq04-sw07-ua04		A	10.226.1.32
			AAAA	2402:740:5a:4e20::5011
pnq04-sw07-wa01		A	10.226.1.31
			AAAA	2402:740:5a:4e20::3004
pnq04-sw07-wa02		A	10.226.1.30
			AAAA	2402:740:5a:4e20::3005
pnq04-sw08-av01		A	10.226.1.29
			AAAA	2402:740:5a:4e20::4006
pnq04-sw08-ma01		A	10.226.1.28
			AAAA	2402:740:5a:4e20::1005
pnq04-sw08-pa01		A	10.226.1.27
			AAAA	2402:740:5a:4e20::6006
pnq04-sw08-ua01		A	10.226.1.26
			AAAA	2402:740:5a:4e20::5012
pnq04-sw08-ua02		A	10.226.1.25
			AAAA	2402:740:5a:4e20::5013
pnq04-sw08-wa01		A	10.226.1.24
			AAAA	2402:740:5a:4e20::3006
pnq04-wc-lc01		A	10.205.130.129
pnq04-wc-lc02		A	10.205.130.130
proxy-sin02		A	10.111.0.200
proxy-snat-avi-1	A	10.166.17.99
proxy1-sin02		A	10.111.0.201
proxy1-sjc31		A	10.166.17.40
proxy2-sin02		A	10.111.0.202
proxy2-sjc31		A	10.166.17.41
proxy3-sin02		A	10.111.0.203
proxy3-sjc31		A	10.166.17.42
proxy4-sjc31		A	10.166.17.43
proxy5-sjc31		A	10.166.17.44
proxy6-sjc31		A	10.166.17.45
proxy7-sjc31-new	A	10.166.1.127
proxy8-sjc31-new	A	10.166.1.128
ptp-spc-blr03		A	10.112.16.175
pune-locker-testing	A	10.226.1.178
rcairtel-blr13		A	10.177.216.236
rcairtel-blr7		A	10.54.192.5
rcairtel-bom1		A	10.109.251.2
rcairtel-pnq4		A	10.22.17.1
rcat-gnsys-ams03	A	10.255.251.8
rcat-gnsys-ams2		A	10.27.188.12
rcat-gnsys-atl01	A	10.88.9.30
rcat-gnsys-blr3		A	10.112.152.155
rcat-gnsys-iad04	A	10.255.251.2
rcat-gnsys-lhr05	A	10.255.251.6
rcat-gnsys-ork2		A	10.30.11.20
rcat-gnsys-sjc05	A	10.188.0.42
rcat-gnsys-sjc06	A	10.255.251.4
rcatt-aws-blr7		A	10.54.140.181
			AAAA	2402:740:44:4e20::a
rcatt-aws-sea03		A	10.75.3.172
rcbt-gnsys-ams03	A	10.255.251.7
rcbt-gnsys-ams2		A	10.27.188.13
rcbt-gnsys-atl01	A	10.88.9.31
rcbt-gnsys-blr3		A	10.112.152.156
rcbt-gnsys-iad04	A	10.255.251.1
rcbt-gnsys-lhr05	A	10.255.251.5
rcbt-gnsys-ork2		A	10.30.11.21
rcbt-gnsys-sjc05	A	10.188.0.80
rcbt-gnsys-sjc06	A	10.255.251.3
rce01-atl01		A	10.88.8.57
rce02-atl01		A	10.88.8.58
rce03-atl01		A	10.88.8.55
rce04-atl01		A	10.88.8.56
rcedge-blr13		A	10.177.216.100
rcedge-blr3		A	10.22.28.8
rcedge-nrt02		A	10.65.192.137
rcmsgy-ams02		A	10.27.188.114
rcmsgy-sof6		A	10.121.85.1
			AAAA	2a0d:1e00:46:4e20::c
rcmsgy1-hkg1		A	10.109.177.4
rctata-blr14		A	10.54.192.3
rctcl-aws-blr14		A	10.235.252.25
rctcl-aws-iad03		A	10.75.33.106
rctcl-bom1		A	10.109.251.1
rctelstra-sip-nrt2	A	10.65.192.130
rctelstra-sip-sin3	A	10.120.4.19
rctelstra-sip-syd1	A	10.109.166.9
rcttsl-sip-blr14	A	10.235.252.26
rcttsl-sip-blr7		A	10.54.140.182
			AAAA	2402:740:44:4e20::b
rcttsl-sip-bom1		A	10.120.193.240
rcttsl-sip-del2		A	10.119.193.227
rcttsl-sip-maa04	A	10.109.120.12
rcvzb-ams02		A	10.27.188.113
rcvzb-blr13		A	10.177.216.235
rcvzb-blr7		A	10.54.192.4
rcvzb-evn1		A	10.30.111.2
rcvzb-ork3		A	10.66.44.8
rcvzb-pnq4		A	10.22.17.2
rcvzb-rom1		A	10.26.24.135
rdu01-cs-ca01		A	10.204.224.151
rdu01-cs01-ca01		A	10.204.224.184
rdu01-fw-eg01		A	10.204.224.133
rdu01-fw-eg02		A	10.204.224.134
rdu01-sd-vce01		A	10.204.224.1
rdu01-sd-vce02		A	10.204.224.189
rdu01-sw-core01		A	10.204.224.190
rdu01-sw-dmz01		A	10.204.224.131
rdu01-sw-fp01		A	10.204.224.141
rdu01-sw-fp02		A	10.204.224.142
rdu01-sw01-ua01		A	10.204.224.185
rdu01-sw01-ua02		A	10.204.224.186
rdu01-sw01-ua03		A	10.204.224.187
rdu01-sw08-av01		A	10.204.224.165
rdu01-sw08-ma01		A	10.204.224.171
rdu01-sw08-ua01		A	10.204.224.155
rdu01-sw08-wa01		A	10.204.224.161
rdu01-wc-lc01		A	10.204.227.17
rdu01-wc-lc02		A	10.204.227.18
rdu02-cs01-ca01		A	10.207.160.56
rdu02-fw-egp01		A	10.207.160.54
rdu02-fw-egp02		A	10.207.160.55
rdu02-sd-vce01		A	10.207.160.60
rdu02-sd-vce02		A	10.207.160.61
rdu02-sw-core01		A	10.207.160.62
rdu02-sw01-ua01		A	10.207.160.57
rdu02-sw01-ua02		A	10.207.160.58
rdu02-sw01-ua03		A	10.207.160.59
rg1-ams02		A	10.27.188.111
rg1-blr13		A	10.177.216.239
rg1-blr14		A	10.235.252.24
rg1-blr3		A	10.112.153.214
rg1-blr7		A	10.54.140.191
			AAAA	2402:740:44:4e20::c
rg1-hkg1		A	10.109.176.130
rg1-pnq4		A	10.205.130.62
rg1-sof6		AAAA	2a0d:1e00:46:4e20::a
rg1-waw1		A	10.26.89.8
rg1cc-pao04		A	10.17.252.46
rg1s-sjc05		A	10.188.7.235
rg2-ams02		A	10.27.188.112
rg2-hkg1		A	10.109.176.141
rg2-pnq4		A	10.205.130.63
rg2-waw1		A	10.26.89.9
rg2cc-pao04		A	10.17.252.47
rom01-cs-ca01		A	10.42.192.130
			AAAA	2a0d:1e00:4044:4e20::2001
rom01-fw-eg01		A	10.42.192.131
			AAAA	2a0d:1e00:4044:4e20::4
rom01-fw-eg02		A	10.42.192.132
			AAAA	2a0d:1e00:4044:4e20::5
rom01-sw-core01		A	10.42.199.216
			AAAA	2a0d:1e00:4044:4e20:ffff:ffff:ffff:ff7f
rom01-sw-dmz01		A	10.42.192.123
			AAAA	2a0d:1e00:4044:4e20::1
rom01-sw-fp01		A	10.42.192.126
			AAAA	2a0d:1e00:4044:4e20::2
rom01-sw-fp02		A	10.42.192.127
			AAAA	2a0d:1e00:4044:4e20::3
rom01-sw04-av01		A	10.42.192.125
			AAAA	2a0d:1e00:4044:4e20::4001
rom01-sw04-ma01		A	10.42.192.124
			AAAA	2a0d:1e00:4044:4e20::1001
rom01-sw04-ua01		A	10.42.192.121
			AAAA	2a0d:1e00:4044:4e20::5001
rom01-sw04-wa01		A	10.42.192.122
			AAAA	2a0d:1e00:4044:4e20::3001
rom01-wc-lc01		A	10.42.199.130
			AAAA	2a0d:1e00:4044:22e0::1
rom01-wc-lc02		A	10.42.199.131
			AAAA	2a0d:1e00:4044:22e0::2
rpz-soc			A	10.25.207.164
rr1-ams02		A	10.27.188.107
rr1-blr13		A	10.177.216.237
rr1-blr14		A	10.54.192.1
rr1-blr7		A	10.54.192.2
rr1-pnq4		A	10.22.17.3
rr1-sof6		AAAA	2a0d:1e00:46:4e20::d
rr2-ams02		A	10.27.188.108
rr2-pnq4		A	10.22.17.4
rrig1-ams02		A	10.27.188.109
rrig1-blr13		A	10.177.216.238
rrig1-blr14		A	10.235.252.23
rrig1-blr3		A	10.112.153.213
rrig1-blr7		A	10.54.140.192
			AAAA	2402:740:44:4e20::e
rrig1-sof6		AAAA	2a0d:1e00:46:4e20::b
rrig1cc-pao04		A	10.17.252.44
rrig1s-eat1		A	10.128.163.70
rrig2-ams02		A	10.27.188.110
rrig2cc-pao04		A	10.17.252.45
rrig2s-eat1		A	10.128.163.71
s1-den2			A	10.201.193.2
s1-infra-tor		A	10.201.128.177
s1-lax			A	10.204.96.181
s1-lon			A	10.204.32.181
s1-mgmt-ams02		A	10.27.189.241
s1-nyc			A	10.204.0.181
s1-sin			A	10.204.192.181
s1-sof02		A	10.23.60.31
s1-sof02-mgmt		A	10.23.98.39
s2-den2			A	10.201.193.5
s2-infra-tor		A	10.201.128.178
s2-lax			A	10.204.96.182
s2-mgmt-ams02		A	10.27.189.242
s2-nyc			A	10.204.0.182
s2-sof02		A	10.23.60.32
s2-sof02-mgmt		A	10.23.98.40
s3-lab-nyc		A	10.204.0.184
s3-lax			A	10.204.96.183
s3-lon			A	10.204.32.182
s3-nyc			A	10.204.0.183
s4-lax			A	10.204.96.184
s4-lon			A	10.204.32.183
s5-lax			A	10.204.96.185
saperp-sbx-vip		A	10.127.8.168
sc2-prod-wpad-1		A	10.113.12.176
sc2-prod-wpad-2		A	10.113.12.177
se1-sc2-tkgm-gslb-mgmt	A	10.189.20.70
se1-wdc-tkgm-gslb-mgmt	A	10.200.62.64
se2-sc2-tkgm-gslb-mgmt	A	10.189.20.71
se2-wdc-tkgm-gslb-mgmt	A	10.200.62.65
sea02-cs-ca01		A	10.62.1.61
			AAAA	2606:9680:2044:4e20::2001
sea02-cs13-ca01		A	10.62.1.64
sea02-cs14-ca01		A	10.62.1.65
			AAAA	2606:9680:2044:4e20::2002
sea02-cs14-ca02		A	10.62.1.62
sea02-cs15-ca01		A	10.62.1.66
			AAAA	2606:9680:2044:4e20::2003
sea02-cs16-ca01		AAAA	2606:9680:2044:4e20::2004
sea02-fw-eg01		A	10.62.1.51
			AAAA	2606:9680:2044:4e20::4
sea02-fw-eg02		A	10.62.1.52
			AAAA	2606:9680:2044:4e20::5
sea02-fw-sc01		A	10.62.1.57
			AAAA	2606:9680:2044:4e20::6
sea02-fw-sc02		A	10.62.1.58
			AAAA	2606:9680:2044:4e20::7
sea02-sd-vce01		A	10.62.58.189
sea02-sw-core01		A	10.62.0.254
			AAAA	2606:9680:2044:4e20:ffff:ffff:ffff:ff7f
sea02-sw-dmz01		A	10.62.1.71
			AAAA	2606:9680:2044:4e20::1
sea02-sw-fp01		A	10.62.1.103
			AAAA	2606:9680:2044:4e20::2
sea02-sw-fp02		A	10.62.1.104
			AAAA	2606:9680:2044:4e20::3
sea02-sw-fp03		A	10.62.1.101
sea02-sw14-av01		A	10.62.1.45
			AAAA	2606:9680:2044:4e20::4001
sea02-sw14-ma01		A	10.62.1.92
			AAAA	2606:9680:2044:4e20::1002
sea02-sw14-pa01		A	10.62.1.102
			AAAA	2606:9680:4044:4e20::6001
sea02-sw14-ua01		A	10.62.1.15
			AAAA	2606:9680:2044:4e20::5002
sea02-sw14-wa01		A	10.62.1.35
			AAAA	2606:9680:2044:4e20::3002
sea02-sw15-av01		A	10.62.1.46
			AAAA	2606:9680:2044:4e20::4002
sea02-sw15-ua01		A	10.62.1.16
			AAAA	2606:9680:2044:4e20::5003
sea02-sw15-wa01		A	10.62.1.36
			AAAA	2606:9680:2044:4e20::3003
sea02-sw16-ma01		A	10.62.1.91
			AAAA	2606:9680:2044:4e20::1001
sea02-sw16-ua01		A	10.62.1.12
			AAAA	2606:9680:2044:4e20::5004
sea02-sw16-wa01		A	10.62.1.32
			AAAA	2606:9680:2044:4e20::3004
sea02-sw26-ua01		CNAME	office5-14F-sea2.vmware.com.
sea02-wc-lc01		A	10.62.0.12
			AAAA	2606:9680:4044:22e0::1
sea02-wc-lc02		A	10.62.0.13
			AAAA	2606:9680:4044:22e0::2
sea04-cs01-ca01		A	10.204.208.184
sea04-fw-eg01		A	10.204.208.182
sea04-fw-eg02		A	10.204.208.183
sea04-sd-vce01		A	10.204.208.188
sea04-sd-vce02		A	10.204.208.189
sea04-sw-core01		A	10.204.208.190
sea04-sw01-ua01		A	10.204.208.185
sea04-sw01-ua02		A	10.204.208.186
sea04-sw01-ua03		A	10.204.208.187
sea2-nsx-eg01		A	10.62.1.120
sea2-nsx-eg02		A	10.62.1.121
secureproxy-scdc-prd-ext-vip-snat1 A 10.188.245.166
secureproxy-scdc-prd-ext-vip-snat2 A 10.188.245.167
secureproxy-scdc-prd-int-vip-snat1 A 10.188.245.105
secureproxy-scdc-prd-int-vip-snat2 A 10.188.245.106
secureproxy-scdc-stg-ext-vip-snat1 A 10.188.246.99
secureproxy-scdc-stg-ext-vip-snat2 A 10.188.246.100
secureproxy-scdc-stg-int-vip-snat1 A 10.188.246.43
secureproxy-scdc-stg-int-vip-snat2 A 10.188.246.44
secureproxy-vmc-prd-vip-snat1 A	10.81.20.6
secureproxy-vmc-prd-vip-snat2 A	10.81.20.7
secureproxy-vmc-stg-vip-snat1 A	10.81.24.6
secureproxy-vmc-stg-vip-snat2 A	10.81.24.7
secureproxy-wdc-prd-ext-vip-snat1 A 10.128.42.46
secureproxy-wdc-prd-ext-vip-snat2 A 10.128.42.47
secureproxy-wdc-prd-int-vip-snat1 A 10.128.42.121
secureproxy-wdc-prd-int-vip-snat2 A 10.128.42.122
secureproxy-wdc-stg-ext-vip-snat1 A 10.128.40.66
secureproxy-wdc-stg-ext-vip-snat2 A 10.128.40.67
secureproxy-wdc-stg-int-vip-snat1 A 10.128.40.58
secureproxy-wdc-stg-int-vip-snat2 A 10.128.40.59
security1-1f-atl01	A	10.84.4.124
security1-8f-bcn1	AAAA	2a0d:1e00:4043:4e20::6001
security2-tfb-atl01	A	10.84.4.123
security3-bas-atl01	A	10.84.4.122
sfo03-cs-ca01		A	10.201.1.52
sfo03-cs01-ca01		A	10.201.1.248
sfo03-cs05-ca01		A	10.201.1.51
sfo03-fw-eg01		A	10.201.1.35
sfo03-fw-eg02		A	10.201.1.36
sfo03-fw-egp01		A	10.201.1.246
sfo03-fw-egp02		A	10.201.1.247
sfo03-sd-vce01		A	10.201.0.1
sfo03-sd-vce02		A	10.201.1.253
sfo03-sw-core01		A	10.201.1.254
sfo03-sw-dmz01		A	10.201.1.41
sfo03-sw-fp01		A	10.201.1.21
sfo03-sw-fp02		A	10.201.1.22
sfo03-sw01-ua01		A	10.201.1.249
sfo03-sw01-ua02		A	10.201.1.250
sfo03-sw01-ua03		A	10.201.1.251
sfo03-sw04-av01		A	10.201.1.25
sfo03-sw04-la01		A	10.201.1.48
sfo03-sw04-ma01		A	10.201.1.44
sfo03-sw04-pa01		A	10.201.1.30
sfo03-sw04-ua01		A	10.201.1.10
sfo03-sw04-ua02		A	10.201.1.11
sfo03-sw04-ua03		A	10.201.1.12
sfo03-sw04-wa01		A	10.201.1.5
sfo03-sw05-av01		A	10.201.1.26
sfo03-sw05-ma01		A	10.201.1.45
sfo03-sw05-pa01		A	10.201.1.31
sfo03-sw05-ua01		A	10.201.1.13
sfo03-sw05-ua02		A	10.201.1.14
sfo03-sw05-wa01		A	10.201.1.6
sfo03-wc-lc01		A	10.201.3.17
sfo03-wc-lc02		A	10.201.3.18
sg1-ams02		A	10.26.211.228
sg1-bcn1		AAAA	2a0d:1e00:4043:4e20::1
sg1-del2		A	10.119.193.222
			AAAA	2402:740:47:4e20::1
sg1-den1		AAAA	2606:9680:2045:4e20::1
sg1-evolab-sjc05	A	10.188.0.213
sg1-icn1		AAAA	2402:740:4046:4e20::1
sg1-sea03		A	10.75.3.17
sg1-sjo1		AAAA	2801:1d4:40:4e20::1
sg1-sof02		A	10.23.98.18
sg2-evolab-sjc05	A	10.188.0.214
sg2-sea03		A	10.75.3.18
sg2-sof02		A	10.23.98.19
sha01-cs-ca01		AAAA	2402:740:4047:4e20::2001
sha01-cs10-ca01		AAAA	2402:740:4047:4e20::2002
sha01-fw-egp01		AAAA	2402:740:4047:4e20::4
sha01-fw-egp02		AAAA	2402:740:4047:4e20::5
sha01-fw-sc01		AAAA	2402:740:4047:4e20::6
sha01-fw-sc02		AAAA	2402:740:4047:4e20::7
sha01-rt-ig01		AAAA	2402:740:4047:4e20::d
sha01-rt-ig02		AAAA	2402:740:4047:4e20::e
sha01-rt-mpls01		AAAA	2402:740:4047:4e20::8
sha01-rt-mpls02		AAAA	2402:740:4047:4e20::9
sha01-rt-rr01		AAAA	2402:740:4047:4e20::a
sha01-rt-rr02		AAAA	2402:740:4047:4e20::c
sha01-sw-core01		AAAA	2402:740:4047:4e20:ffff:ffff:ffff:ff7f
sha01-sw-dmz01		AAAA	2402:740:4047:4e20::1
sha01-sw-fp01		A	10.110.189.36
			AAAA	2402:740:4047:4e20::2
sha01-sw-fp02		A	10.110.189.37
			AAAA	2402:740:4047:4e20::3
sha01-sw10-av01		AAAA	2402:740:4047:4e20::4001
sha01-sw10-pa01		A	10.110.189.52
			AAAA	2402:740:4047:4e20::6001
sha01-sw10-ua01		AAAA	2402:740:4047:4e20::5001
sha01-sw10-ua02		AAAA	2402:740:4047:4e20::5002
sha01-sw10-wa01		AAAA	2402:740:4047:4e20::3001
sha01-sw11-av02		AAAA	2402:740:4047:4e20::4002
sha01-sw11-pa01		A	10.110.189.51
			AAAA	2402:740:4047:4e20::6002
sha01-sw11-ua01		AAAA	2402:740:4047:4e20::5003
sha01-sw11-ua02		AAAA	2402:740:4047:4e20::5004
sha01-sw11-wa01		AAAA	2402:740:4047:4e20::3002
sha01-wc-lc01		AAAA	2402:740:4047:22e0::1
sha01-wc-lc02		AAAA	2402:740:4047:22e0::2
sha02-cs08-ca01		A	10.109.183.136
			AAAA	2402:740:4048:4e20::2001
sha02-fw-egp01		AAAA	2402:740:4048:4e20::4
sha02-fw-egp02		AAAA	2402:740:4048:4e20::5
sha02-n9k-fp01		A	10.109.183.152
			AAAA	2402:740:4048:4e20::2
sha02-n9k-fp02		A	10.109.183.153
			AAAA	2402:740:4048:4e20::3
sha02-sw-core01		A	10.109.183.176
			AAAA	2402:740:4048:4e20:ffff:ffff:ffff:ff7f
sha02-sw-dmz01		A	10.109.183.140
			AAAA	2402:740:4048:4e20::1
sha02-sw08-av01		AAAA	2402:740:4048:4e20::4001
sha02-sw08-ua01		A	10.109.183.130
			AAAA	2402:740:4048:4e20::5001
sha02-sw08-ua02		A	10.109.183.132
			AAAA	2402:740:4048:4e20::5002
sha02-sw08-wa01		A	10.109.183.134
			AAAA	2402:740:4048:4e20::3001
sha02-wc-lc01		A	10.109.183.170
			AAAA	2402:740:4048:22e0::1
sha02-wc-lc02		A	10.109.183.171
			AAAA	2402:740:4048:22e0::2
sha03-cs01-ca01		A	10.204.240.184
sha03-fw-egp01		A	10.204.240.182
sha03-fw-egp02		A	10.204.240.183
sha03-sd-vce01		A	10.204.240.188
sha03-sd-vce02		A	10.204.240.189
sha03-sw-core01		A	10.204.240.190
sha03-sw01-ua01		A	10.204.240.185
sha03-sw01-ua02		A	10.204.240.186
sha03-sw01-ua03		A	10.204.240.187
sin01-ns-eni01		A	10.16.209.22
sin01-sd-vce01		A	10.16.209.224
sin03-wc-mm		A	10.111.0.7
sin03-wc-mm01		A	10.111.0.5
sin03-wc-mm02		A	10.111.0.6
sin04-fw-egp01		A	10.204.192.183
sin04-fw-egp02		A	10.204.192.184
sin04-sd-vce01		A	10.204.192.188
sin04-sd-vce02		A	10.204.192.189
sin04-sw01-ua01		A	10.204.192.185
sin04-sw01-ua02		A	10.204.192.186
sin04-sw01-ua03		A	10.204.192.187
sin3-esxi01-perimeter-mgmt A	10.107.18.65
sin3-esxi02-perimeter-mgmt A	10.107.18.66
sin3-esxi03-perimeter-mgmt A	10.107.18.67
sin3-esxi04-perimeter-mgmt A	10.107.18.68
sin3-int-self-avi-se-1	A	10.111.0.150
sin3-int-self-avi-se-2	A	10.111.0.151
sin3-nsxedg-prod-mgr	A	10.107.18.69
sin3-nsxedg-prod-mgr01	A	10.107.18.70
sin3-nsxedg-prod-mgr02	A	10.107.18.71
sin3-nsxedg-prod-mgr03	A	10.107.18.72
sjc05-esxi01-perimeter-mgmt A	10.188.39.129
sjc05-esxi02-perimeter-mgmt A	10.188.39.130
sjc05-esxi03-perimeter-mgmt A	10.188.39.131
sjc05-esxi04-perimeter-mgmt A	10.188.39.132
sjc05-fw-egp01		A	10.188.2.195
sjc05-fw-egp02		A	10.188.2.196
sjc05-nsxedg-np-mgr	A	10.188.39.137
sjc05-nsxedg-np-mgr01	A	10.188.39.138
sjc05-nsxedg-np-mgr02	A	10.188.39.139
sjc05-nsxedg-np-mgr03	A	10.188.39.140
sjc05-nsxedg-prod-mgr	A	10.188.39.133
sjc05-nsxedg-prod-mgr01	A	10.188.39.134
sjc05-nsxedg-prod-mgr02	A	10.188.39.135
sjc05-nsxedg-prod-mgr03	A	10.188.39.136
sjc05-sd-vch01		A	10.250.28.53
sjc05-sd-vch02		A	10.250.28.54
sjc05-wc-mm		A	10.188.84.133
sjc05-wc-mm01		A	10.188.84.131
sjc05-wc-mm02		A	10.188.84.132
sjc07-cs01-ca01		A	10.212.0.24
sjc07-fw-egp01		A	10.212.0.22
sjc07-fw-egp02		A	10.212.0.23
sjc07-sd-vce01		A	10.212.0.28
sjc07-sd-vce02		A	10.212.0.29
sjc07-sw-core01		A	10.212.0.30
sjc07-sw01-ua01		A	10.212.0.25
sjc07-sw01-ua02		A	10.212.0.26
sjc07-sw01-ua03		A	10.212.0.27
sjc31-fw-eg01		A	10.166.83.250
sjc31-fw-eg02		A	10.166.83.251
sjc31-fw-egp01		A	10.166.80.35
sjc31-fw-egp02		A	10.166.80.36
sjc31-sd-vch01		A	10.169.254.6
sjc31-sd-vch02		A	10.169.254.7
sjc5-dmz-mgmt-avi-se-1	A	10.188.220.49
sjc5-dmz-mgmt-avi-se-2	A	10.188.220.58
sjc5-dmz-self-avi-se-1	A	10.188.220.50
sjc5-dmz-self-avi-se-2	A	10.188.220.59
sjc5-int-mgmt-avi-se-1	A	10.188.194.140
sjc5-int-mgmt-avi-se-2	A	10.188.194.142
sjc5-int-self-avi-se-1	A	10.188.194.141
sjc5-int-self-avi-se-2	A	10.188.194.143
sjc5-uat-dmz-mgmt-avi-se-1 A	10.188.247.137
sjc5-uat-dmz-mgmt-avi-se-2 A	10.188.247.139
sjc5-uat-dmz-self-avi-se-1 A	10.188.247.138
sjc5-uat-dmz-self-avi-se-2 A	10.188.247.140
sjc5-uat-int-mgmt-avi-se-1 A	10.188.198.244
sjc5-uat-int-mgmt-avi-se-2 A	10.188.198.246
sjc5-uat-int-self-avi-se-1 A	10.188.198.245
sjc5-uat-int-self-avi-se-2 A	10.188.198.247
sjo01-f32-cs-ca01	A	10.25.244.143
sjo01-f32-cs02-ca01	A	10.25.244.142
sjo01-f32-cs04-ca01	A	10.25.244.144
sjo01-f32-cs05-ca01	A	10.25.244.145
sjo01-f32-sw02-av01	A	10.25.244.132
			AAAA	2801:1d4:40:4e23::4001
sjo01-f32-sw03-av01	A	10.25.244.133
			AAAA	2801:1d4:40:4e23::4002
sjo01-f32-sw03-ma01	A	10.25.244.136
			AAAA	2801:1d4:40:4e23::1001
sjo01-f32-sw04-av01	A	10.25.244.134
			AAAA	2801:1d4:40:4e23::4003
sjo01-f32-sw05-av01	A	10.25.244.135
			AAAA	2801:1d4:40:4e23::4004
sjo01-ns-eni01		A	10.25.224.121
sjo01-sw-fp01		A	10.25.244.137
			AAAA	2801:1d4:40:4e23::2
sjo01-sw-fp02		A	10.25.244.138
			AAAA	2801:1d4:40:4e23::3
sjo02-cs04-ca01		A	10.25.112.134
			AAAA	2801:1d4:40:5e20::2001
sjo02-cs05-ca01		A	10.25.112.138
			AAAA	2801:1d4:40:5e20::2002
sjo02-sw-core01		A	10.25.112.250
			AAAA	2801:1d4:40:5e20:ffff:ffff:ffff:ff7f
sjo02-sw04-av01		A	10.25.112.131
			AAAA	2801:1d4:40:5e20::4001
sjo02-sw04-ma01		A	10.25.112.129
			AAAA	2801:1d4:40:5e20::1001
sjo02-sw04-pa01		A	10.25.112.133
			AAAA	2801:1d4:40:5e20::6001
sjo02-sw04-ua01		A	10.25.112.130
			AAAA	2801:1d4:40:5e20::5001
sjo02-sw04-wa01		A	10.25.112.132
			AAAA	2801:1d4:40:5e20::3001
sjo02-sw05-av01		A	10.25.112.136
			AAAA	2801:1d4:40:5e20::4002
sjo02-sw05-ua01		A	10.25.112.135
			AAAA	2801:1d4:40:5e20::5002
sjo02-sw05-wa01		A	10.25.112.137
			AAAA	2801:1d4:40:5e20::3002
sof02-fw-sc01		A	10.23.98.13
sof02-fw-sc02		A	10.23.98.14
sof02-wc-mm		A	10.27.193.3
sof02-wc-mm01		A	10.27.193.1
sof02-wc-mm02		A	10.27.193.2
sof06-cs-ca01		A	10.93.2.1
			AAAA	2a0d:1e00:46:4e20::2001
sof06-cs-ca02		A	10.93.2.2
			AAAA	2a0d:1e00:46:4e20::2002
sof06-cs-ca03		A	10.93.2.3
			AAAA	2a0d:1e00:46:4e20::2003
sof06-cs-ca04		A	10.93.2.4
			AAAA	2a0d:1e00:46:4e20::2004
sof06-sw-core01		A	10.121.85.249
			AAAA	2a0d:1e00:46:4e20:ffff:ffff:ffff:ff7f
sof06-sw-dmz01		A	10.93.2.73
			AAAA	2a0d:1e00:46:4e20::1
sof06-sw-fp01		A	10.93.2.71
			AAAA	2a0d:1e00:46:4e20::2
sof06-sw-fp02		A	10.93.2.72
			AAAA	2a0d:1e00:46:4e20::3
sof06-sw00-av01		A	10.93.2.31
			AAAA	2a0d:1e00:46:4e20::4001
sof06-sw00-av02		A	10.93.2.32
			AAAA	2a0d:1e00:46:4e20::4002
sof06-sw00-ua01		A	10.93.2.11
			AAAA	2a0d:1e00:46:4e20::5001
sof06-sw00-ua02		A	10.93.2.12
			AAAA	2a0d:1e00:46:4e20::5002
sof06-sw00-wa01		A	10.93.2.51
			AAAA	2a0d:1e00:46:4e20::3001
sof06-sw01-av01		A	10.93.2.33
			AAAA	2a0d:1e00:46:4e20::4003
sof06-sw01-av02		A	10.93.2.34
			AAAA	2a0d:1e00:46:4e20::4004
sof06-sw01-ua01		A	10.93.2.13
			AAAA	2a0d:1e00:46:4e20::5003
sof06-sw01-ua02		A	10.93.2.14
			AAAA	2a0d:1e00:46:4e20::5004
sof06-sw01-wa01		A	10.93.2.52
			AAAA	2a0d:1e00:46:4e20::3002
sof06-sw02-av01		A	10.93.2.35
			AAAA	2a0d:1e00:46:4e20::4005
sof06-sw02-av02		A	10.93.2.36
			AAAA	2a0d:1e00:46:4e20::4006
sof06-sw02-ua01		A	10.93.2.15
			AAAA	2a0d:1e00:46:4e20::5005
sof06-sw02-ua02		A	10.93.2.16
			AAAA	2a0d:1e00:46:4e20::5006
sof06-sw02-wa01		A	10.93.2.53
			AAAA	2a0d:1e00:46:4e20::3003
sof06-sw03-av01		A	10.93.2.37
			AAAA	2a0d:1e00:46:4e20::4007
sof06-sw03-av02		A	10.93.2.38
			AAAA	2a0d:1e00:46:4e20::4008
sof06-sw03-ma01		A	10.93.2.251
			AAAA	2a0d:1e00:46:4e20::1001
sof06-sw03-ma02		A	10.93.2.252
			AAAA	2a0d:1e00:46:4e20::1002
sof06-sw03-pa01		A	10.93.2.95
			AAAA	2a0d:1e00:46:4e20::6001
sof06-sw03-pa02		A	10.93.2.91
			AAAA	2a0d:1e00:46:4e20::6002
sof06-sw03-ua01		A	10.93.2.17
			AAAA	2a0d:1e00:46:4e20::5007
sof06-sw03-ua02		A	10.93.2.18
			AAAA	2a0d:1e00:46:4e20::5008
sof06-sw03-wa01		A	10.93.2.54
			AAAA	2a0d:1e00:46:4e20::3004
sof06-sw04-av01		A	10.93.2.39
			AAAA	2a0d:1e00:46:4e20::4009
sof06-sw04-av02		A	10.93.2.40
			AAAA	2a0d:1e00:46:4e20::400a
sof06-sw04-ua01		A	10.93.2.19
			AAAA	2a0d:1e00:46:4e20::5009
sof06-sw04-ua02		A	10.93.2.20
			AAAA	2a0d:1e00:46:4e20::500a
sof06-sw04-wa01		A	10.93.2.55
			AAAA	2a0d:1e00:46:4e20::3005
sof06-sw05-av01		A	10.93.2.41
			AAAA	2a0d:1e00:46:4e20::400b
sof06-sw05-wa01		A	10.93.2.56
			AAAA	2a0d:1e00:46:4e20::3006
sof06-wc-lc01		A	10.65.110.2
			AAAA	2a0d:1e00:46:22e0::1
sof06-wc-lc02		A	10.65.110.3
			AAAA	2a0d:1e00:46:22e0::2
sof07-cs02-ca01		A	10.93.130.1
			AAAA	2a0d:1e00:46:5e20::2001
sof07-cs02a-ca01	A	10.93.130.2
			AAAA	2a0d:1e00:46:5e20::2002
sof07-sw-core01		A	10.93.130.254
			AAAA	2a0d:1e00:46:5e20:ffff:ffff:ffff:ff7f
sof07-sw02-av01		A	10.93.130.32
			AAAA	2a0d:1e00:46:5e20::4001
sof07-sw02-ua01		A	10.93.130.11
			AAAA	2a0d:1e00:46:5e20::5001
sof07-sw02-ua02		A	10.93.130.12
sof07-sw02-wa01		A	10.93.130.51
			AAAA	2a0d:1e00:46:5e20::3001
sof07-sw02a-av02	A	10.93.2.106
sof07-sw02a-ma01	A	10.93.2.105
sof07-sw02a-pa01	A	10.93.2.108
sof07-sw02a-ua01	A	10.93.2.107
sof07-sw02a-wa01	A	10.93.2.109
sof07-sw02b-av01	A	10.93.2.122
sof07-sw02b-ma01	A	10.93.2.123
sof07-sw02b-pa01	A	10.93.2.124
sof07-sw02b-ua01	A	10.93.2.121
sof07-sw02b-wa01	A	10.93.2.120
sof07-sw04-av01		A	10.93.130.33
			AAAA	2a0d:1e00:46:5e20::4002
sof07-sw04-av02		A	10.93.130.34
			AAAA	2a0d:1e00:46:5e20::4003
sof07-sw04-ua01		A	10.93.130.15
			AAAA	2a0d:1e00:46:5e20::5002
sof07-sw04-ua02		A	10.93.130.16
			AAAA	2a0d:1e00:46:5e20::5003
sof07-sw04-wa01		A	10.93.130.52
			AAAA	2a0d:1e00:46:5e20::3002
sof07-sw05-av01		A	10.93.130.35
			AAAA	2a0d:1e00:46:5e20::4004
sof07-sw05-av02		A	10.93.130.36
			AAAA	2a0d:1e00:46:5e20::4005
sof07-sw05-ma01		A	10.93.130.251
			AAAA	2a0d:1e00:46:5e20::1001
sof07-sw05-ma02		A	10.93.130.252
			AAAA	2a0d:1e00:46:5e20::1002
sof07-sw05-pa01		A	10.93.130.95
			AAAA	2a0d:1e00:46:5e20::6001
sof07-sw05-pa02		A	10.93.130.91
			AAAA	2a0d:1e00:46:5e20::6002
sof07-sw05-ua01		A	10.93.130.19
			AAAA	2a0d:1e00:46:5e20::5004
sof07-sw05-ua02		A	10.93.130.20
			AAAA	2a0d:1e00:46:5e20::5005
sof07-sw05-ua03		A	10.93.130.21
			AAAA	2a0d:1e00:46:5e20::5006
sof07-sw05-ua04		A	10.93.130.22
			AAAA	2a0d:1e00:46:5e20::5007
sof07-sw05-wa01		A	10.93.130.53
			AAAA	2a0d:1e00:46:5e20::3003
sof07-sw06-av01		A	10.93.130.37
			AAAA	2a0d:1e00:46:5e20::4006
sof07-sw06-av02		A	10.93.130.38
			AAAA	2a0d:1e00:46:5e20::4007
sof07-sw06-ua01		A	10.93.130.23
			AAAA	2a0d:1e00:46:5e20::5008
sof07-sw06-ua02		A	10.93.130.24
			AAAA	2a0d:1e00:46:5e20::5009
sof07-sw06-wa01		A	10.93.130.54
			AAAA	2a0d:1e00:46:5e20::3004
sv1-3f-f32-sjo1		AAAA	2801:1d4:40:4e20::7001
sv1-5f-f33-sjo1		AAAA	2801:1d4:40:4e22::7002
sv1-den1		A	10.114.37.88
sv2-5f-f33-sjo1		AAAA	2801:1d4:40:4e22::7003
svq01-cs01-ca01		A	10.71.17.1
svq01-fw-eg01		A	10.71.17.41
svq01-fw-eg02		A	10.71.17.42
svq01-sd-vce01		A	10.71.16.9
svq01-sw-core01		A	10.71.17.62
svq01-sw-dmz01		A	10.71.17.61
svq01-sw-fp01		A	10.71.17.11
svq01-sw-fp02		A	10.71.17.12
svq01-sw01-av01		A	10.71.17.26
svq01-sw01-ma01		A	10.71.17.24
svq01-sw01-pa01		A	10.71.17.22
svq01-sw01-pa02		A	10.71.17.23
svq01-sw01-ua01		A	10.71.17.21
svq01-sw01-wa01		A	10.71.17.25
svq01-wc-lc01		A	10.71.17.131
svq01-wc-lc02		A	10.71.17.132
swd-core01-atl01	A	10.88.40.44
swd-core02-atl01	A	10.88.40.45
swd-genesis01-atl01	A	10.88.40.46
swd-genesis02-atl01	A	10.88.40.47
swd-labs01-atl01	A	10.88.40.50
swd-labs02-atl01	A	10.88.40.51
swd-perfadhoc01-atl01	A	10.88.8.47
swd-perfadhoc02-atl01	A	10.88.8.48
swd-performance01-atl01	A	10.88.8.45
swd-performance02-atl01	A	10.88.8.46
swd-shared01-atl01	A	10.88.40.48
swd-shared02-atl01	A	10.88.40.49
swd-transit01-atl01	A	10.88.40.43
swd-workspaceone01-atl01 A	10.88.8.21
swd-workspaceone02-atl01 A	10.88.8.22
syd01-cs-ca01		A	10.109.166.7
syd01-cs-ca02		A	10.109.166.8
syd01-ns-eni01		A	10.109.166.10
syd01-sd-vce01		A	10.110.194.36
test-ap			A	10.107.99.205
test-sni		A	10.188.246.98
testcppmbkuppub		A	10.84.54.142
testcppmpub		A	10.84.54.141
testcppmsub		A	10.84.54.143
tlv01-cs-ca01		A	10.77.52.61
			AAAA	2a0d:1e00:8040:4e20::2001
tlv01-cs04-ca01		A	10.77.52.62
			AAAA	2a0d:1e00:8040:4e20::2002
tlv01-fw-egp01		A	10.77.52.22
tlv01-fw-egp02		A	10.77.52.23
tlv01-sw-core01		A	10.77.63.135
			AAAA	2a0d:1e00:8040:4e20:ffff:ffff:ffff:ff7f
tlv01-sw-dmz01		A	10.77.52.4
			AAAA	2a0d:1e00:8040:4e20::1
tlv01-sw-fp01		A	10.77.52.31
			AAAA	2a0d:1e00:8040:4e20::2
tlv01-sw-fp02		A	10.77.52.32
			AAAA	2a0d:1e00:8040:4e20::3
tlv01-sw-lab01		A	10.23.195.8
			AAAA	2a0d:1e00:8040:e212::b
tlv01-sw00-av01		A	10.77.52.30
			AAAA	2a0d:1e00:8040:4e20::4001
tlv01-sw00-ma01		A	10.77.52.60
			AAAA	2a0d:1e00:8040:4e20::1001
tlv01-sw00-pa01		A	10.77.52.16
tlv01-sw00-wa01		A	10.77.52.1
			AAAA	2a0d:1e00:8040:4e20::3001
tlv01-sw04-av01		A	10.77.52.28
			AAAA	2a0d:1e00:8040:4e20::4002
tlv01-sw04-ta01		A	10.29.67.251
			AAAA	2a0d:1e00:8040:4220::9001
tlv01-sw04-ta02		A	10.29.67.252
			AAAA	2a0d:1e00:8040:4220::9002
tlv01-sw04-ua01		A	10.77.52.14
			AAAA	2a0d:1e00:8040:4e20::5001
tlv01-sw04-ua02		A	10.77.52.15
			AAAA	2a0d:1e00:8040:4e20::5002
tlv01-sw04-va01		A	10.77.52.24
			AAAA	2a0d:1e00:8040:4e20::7001
tlv01-sw04-va02		A	10.77.52.25
			AAAA	2a0d:1e00:8040:4e20::7002
tlv01-sw04-wa01		A	10.77.52.3
			AAAA	2a0d:1e00:8040:4e20::3002
tlv01-wc-lc01		A	10.77.63.97
tlv01-wc-lc02		A	10.77.63.98
tr3-lon			A	10.204.32.184
tr4-lon			A	10.204.32.185
training-13f-nrt1	A	10.117.67.71
txl01-cs01-ca01		A	10.207.144.184
txl01-fw-eg01		A	10.207.144.182
txl01-fw-eg02		A	10.207.144.183
txl01-sd-vce01		A	10.207.144.188
txl01-sd-vce02		A	10.207.144.189
txl01-sw01-ua01		A	10.207.144.185
txl01-sw01-ua02		A	10.207.144.186
txl01-sw01-ua03		A	10.207.144.187
vc-nsxedg-ams2		CNAME	vcenter-nsxedg-prod-ams2
vce01-den03		A	10.17.32.1
vce01-den2		A	10.201.198.1
vce01-iad1		A	10.42.77.153
vce01-ipmi-bkk1		A	10.109.219.19
vce01-ipmi-kul1		A	10.109.213.99
vce01-jnb1		A	10.30.6.101
vce01-kul1		A	10.22.27.6
vce02-ipmi-bkk1		A	10.109.219.20
vce02-ipmi-kul1		A	10.109.213.100
vcenter-nsxedg-prod	A	10.172.13.88
vcenter-nsxedg-prod-ams2 A	10.27.194.80
vcenter-nsxedg-prod-sin3 A	10.107.18.80
vcg-test		A	10.113.63.224
voasis-dev		A	10.177.207.12
vpndns1-blr13		A	10.177.230.50
vpndns1-bos04		A	10.62.131.13
vpndns1-bos07		A	10.16.3.12
vpndns1-nrt02		A	10.65.194.100
vpndns2-blr13		A	10.177.230.51
vpndns2-bos04		A	10.62.131.14
vpndns2-bos07		A	10.16.3.13
vpndns2-nrt02		A	10.65.194.101
vpndns3-sjc05		A	10.190.28.1
vpndns4-sjc05		A	10.190.28.2
vpndns5-sjc05		A	10.63.4.1
vpndns6-sjc05		A	10.63.4.2
w3-nsxt-bitw-dr-1	A	10.128.243.198
w3-nsxt-bitw-dr-1-ilo	A	10.128.164.13
w3-nsxt-bitw-dr-2	A	10.128.243.199
w3-nsxt-bitw-dr-2-ilo	A	10.128.164.14
w3-nsxt-bitw-esxi1-ilo	A	10.128.164.17
w3-nsxt-bitw-esxi2-ilo	A	10.128.164.18
w3-nsxt-bitw-esxi3-ilo	A	10.128.164.19
w3-nsxt-bitw-euc-1	A	10.128.243.200
w3-nsxt-bitw-euc-1-ilo	A	10.128.164.15
w3-nsxt-bitw-euc-2	A	10.128.243.201
w3-nsxt-bitw-euc-2-ilo	A	10.128.164.16
w3-nsxt-bitw-fp-1	A	10.128.243.190
w3-nsxt-bitw-fp-1-ilo	A	10.128.164.5
w3-nsxt-bitw-fp-2	A	10.128.243.191
w3-nsxt-bitw-fp-2-ilo	A	10.128.164.6
w3-nsxt-bitw-fp-3	A	10.128.243.192
w3-nsxt-bitw-fp-3-ilo	A	10.128.164.7
w3-nsxt-bitw-fp-4	A	10.128.243.193
w3-nsxt-bitw-fp-4-ilo	A	10.128.164.8
w3-nsxt-bitw-fp-5	A	10.128.243.194
w3-nsxt-bitw-fp-5-ilo	A	10.128.164.9
w3-nsxt-bitw-fp-6	A	10.128.243.195
w3-nsxt-bitw-fp-6-ilo	A	10.128.164.10
w3-nsxt-bitw-haas-1	A	10.128.243.196
w3-nsxt-bitw-haas-1-ilo	A	10.128.164.11
w3-nsxt-bitw-haas-2	A	10.128.243.197
w3-nsxt-bitw-haas-2-ilo	A	10.128.164.12
w3-nsxt-bitw-legacy-high1 A	10.128.243.188
w3-nsxt-bitw-legacy-high1-ilo A	10.128.164.3
w3-nsxt-bitw-legacy-high2 A	10.128.243.189
w3-nsxt-bitw-legacy-high2-ilo A	10.128.164.4
w3-nsxt-bitw-legacy-low1 A	10.128.243.186
w3-nsxt-bitw-legacy-low1-ilo A	10.128.164.1
w3-nsxt-bitw-legacy-low2 A	10.128.243.187
w3-nsxt-bitw-legacy-low2-ilo A	10.128.164.2
w3-nsxt-cisco-9k-1	A	10.128.164.20
w3-nsxt-cisco-9k-2	A	10.128.164.21
w3-nsxt-cisco-9k-3	A	10.128.164.22
w3-nsxt-cisco-9k-4	A	10.128.164.23
w3-nsxt-cisco-9k-5	A	10.128.164.24
w3-nsxt-cisco-9k-6	A	10.128.164.25
w3-vcenter-bitw		A	10.75.20.196
waw01-cs-ca01		A	10.26.89.2
waw01-sw-core01		A	10.26.90.97
waw01-sw-dmz01		A	10.26.89.4
waw01-sw-fp01		A	10.26.89.7
waw01-sw-fp02		A	10.26.89.6
waw01-sw01-av01		A	10.26.89.10
waw01-sw01-ma01		A	10.26.89.1
waw01-sw01-ua01		A	10.26.89.3
waw01-sw01-wa01		A	10.26.89.5
waw01-wc-lc01		A	10.26.89.113
waw01-wc-lc02		A	10.26.89.114
wcli001-bcn1		AAAA	2a0d:1e00:4043:4e20::1
wcli001-del2		AAAA	2402:740:47:22e0::1
wcli001-gru1		A	10.25.164.33
			AAAA	2801:1d4:640:22e0::1
wcli001-icn1		AAAA	2402:740:4046:22e0::1
wcli001-sjo1		AAAA	2801:1d4:40:22e0::1
wcli002-bcn1		AAAA	2a0d:1e00:4043:4e20::2
wcli002-del2		AAAA	2402:740:47:22e0::2
wcli002-gru1		A	10.25.164.34
			AAAA	2801:1d4:640:22e0::2
wcli002-icn1		AAAA	2402:740:4046:22e0::2
wcli002-sjo1		AAAA	2801:1d4:40:22e0::2
wcli005-pao12-offline	A	10.18.250.185
wdc-bz11nsx-esxi-01-ilo	A	10.128.160.105
wdc-bz11nsx-esxi-02-ilo	A	10.128.160.106
wdc-bz11nsx-esxi-03-ilo	A	10.128.160.107
wdc-bz11nsx-esxi-04-ilo	A	10.128.160.108
wdc-bz11nsx-esxi-05-ilo	A	10.128.160.109
wdc-bz11nsx-esxi-06-ilo	A	10.128.160.110
wdc-bz11nsx-esxi-07-ilo	A	10.128.160.111
wdc-bz11nsx-esxi-08-ilo	A	10.128.160.112
wdc-bz11nsx-esxi-09-ilo	A	10.128.160.113
wdc-bz11nsx-esxi-10-ilo	A	10.128.160.114
wdc-prod-wpad-1		A	10.128.153.68
wdc-prod-wpad-2		A	10.128.153.69
wdc-proxy-vip		CNAME	wdc-proxy-vip.vmware.com.
wifidhcp1-ams04		A	10.96.136.26
wifidhcp1-atl-lab-new	A	10.87.254.56
wifidhcp1-blr07		A	10.54.147.162
wifidhcp1-blr12		A	10.205.192.145
wifidhcp1-blr13		A	10.177.231.26
wifidhcp1-bos04		A	10.62.129.65
wifidhcp1-bos07		A	10.16.2.17
wifidhcp1-bos09		A	10.62.194.1
wifidhcp1-dca01		A	10.204.163.1
wifidhcp1-den03		A	10.17.34.17
wifidhcp1-eze01		A	10.204.101.97
wifidhcp1-hkg1		A	10.177.5.2
wifidhcp1-lhr6		A	10.204.33.65
wifidhcp1-lin02		A	10.98.135.34
wifidhcp1-maa04		A	10.120.141.26
wifidhcp1-nrt02		A	10.65.226.18
wifidhcp1-pdx03		A	10.204.65.65
wifidhcp1-pnq4		A	10.226.0.226
wifidhcp1-poc-pao12	A	10.0.3.1
wifidhcp1-rdu01		A	10.204.227.1
wifidhcp1-sfo03		A	10.201.3.1
wifidhcp1-svq1		A	10.71.18.17
wifidhcp1-waw01		A	10.26.89.105
wifidhcp1-yyz01		A	10.201.130.1
wifidhcp2-ams04		A	10.96.136.27
wifidhcp2-atl-lab-new	A	10.87.254.57
wifidhcp2-blr07		A	10.54.147.163
wifidhcp2-blr12		A	10.205.192.146
wifidhcp2-blr13		A	10.177.231.27
wifidhcp2-bos04		A	10.62.129.66
wifidhcp2-bos07		A	10.16.2.18
wifidhcp2-bos09		A	10.62.194.2
wifidhcp2-dca01		A	10.204.163.2
wifidhcp2-den03		A	10.17.34.18
wifidhcp2-eze01		A	10.204.101.98
wifidhcp2-hkg1		A	10.177.5.3
wifidhcp2-lhr6		A	10.204.33.66
wifidhcp2-lin02		A	10.98.135.35
wifidhcp2-maa04		A	10.120.141.27
wifidhcp2-nrt02		A	10.65.226.19
wifidhcp2-pdx03		A	10.204.65.66
wifidhcp2-pnq4		A	10.226.0.227
wifidhcp2-poc-pao12	A	10.0.3.2
wifidhcp2-rdu01		A	10.204.227.2
wifidhcp2-sfo03		A	10.201.3.2
wifidhcp2-svq1		A	10.71.18.18
wifidhcp2-waw01		A	10.26.89.106
wifidhcp2-yyz01		A	10.201.130.2
wlc-test1		A	10.54.138.9
wlc-test1-1		A	10.54.138.11
wlc-test1-3		A	10.54.138.13
wlc-test2		A	10.54.138.10
wlc-test2-2		A	10.54.138.12
ws00001-2f-f32-sjo1	AAAA	2801:1d4:40:22e1::3001
ws00001-5f-f33-sjo1	A	10.25.224.155
			AAAA	2801:1d4:40:4e22::3006
ws00001-8f-bcn1		AAAA	2a0d:1e00:4043:4e20::3001
ws00001-del2		A	10.119.193.225
			AAAA	2402:740:47:4e20::3001
ws00001-icn1		AAAA	2402:740:4046:4e20::3001
ws00001-sha1		A	10.164.196.24
ws00002-2f-f32-sjo1	AAAA	2801:1d4:40:22e1::3002
ws00002-5f-f33-sjo1	A	10.25.224.156
			AAAA	2801:1d4:40:4e22::3007
ws00003-3f-f32-sjo1	AAAA	2801:1d4:40:22e1::3003
ws00004-22f-sea2	A	10.62.1.34
ws00004-4f-f32-sjo1	AAAA	2801:1d4:40:22e1::3004
ws00005-5f-atl01	A	10.88.8.235
ws00005-5f-f32-sjo1	AAAA	2801:1d4:40:22e1::3005
ws00008-8f-atl01	A	10.88.8.238
xbox-l8-pek2		A	10.109.227.68
yyz01-cs-ca01		A	10.201.128.151
			AAAA	2606:9680:40:4e20::2001
yyz01-fw-eg01		A	10.201.128.133
yyz01-fw-eg02		A	10.201.128.134
yyz01-sd-vce01		A	10.201.128.1
yyz01-sw-core01		A	10.201.128.190
			AAAA	2606:9680:40:4e20:ffff:ffff:ffff:ff7f
yyz01-sw-dmz01		A	10.201.128.131
			AAAA	2606:9680:40:4e20::1
yyz01-sw-fp01		A	10.201.128.141
			AAAA	2606:9680:40:4e20::2
yyz01-sw-fp02		A	10.201.128.142
			AAAA	2606:9680:40:4e20::3
yyz01-sw11-av01		A	10.201.128.165
			AAAA	2606:9680:40:4e20::4001
yyz01-sw11-ma01		A	10.201.128.171
			AAAA	2606:9680:40:4e20::1001
yyz01-sw11-pa01		A	10.201.128.175
			AAAA	2606:9680:40:4e20::6001
yyz01-sw11-ua01		A	10.201.128.155
			AAAA	2606:9680:40:4e20::5001
yyz01-sw11-wa01		A	10.201.128.161
			AAAA	2606:9680:40:4e20::3001
yyz01-wc-lc01		A	10.201.130.17
			AAAA	2606:9680:40:22e0::2
			AAAA	2606:9680:40:22e0::1
yyz01-wc-lc02		A	10.201.130.18
yyz02-cs01-ca01		A	10.201.128.184
yyz02-fw-egp01		A	10.201.128.182
yyz02-fw-egp02		A	10.201.128.183
yyz02-sd-vce01		A	10.201.128.129
yyz02-sd-vce02		A	10.201.128.189
yyz02-sw01-ua01		A	10.201.128.185
yyz02-sw01-ua02		A	10.201.128.186
yyz02-sw01-ua03		A	10.201.128.187
