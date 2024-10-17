#!/bin/bash

# Puppet Integration v1.0
# sharmasachin@vmware.com
# May 1 2020


#### 1. Options
set -x
uid=$(id -u)

if [[ $uid -eq 0 ]]
then
 echo -e "\nRoot is not allowed. \n"
 exit 1
fi

unset GEM_PATH GEM_HOME

TEMP=`getopt -o v:e: --long vm:,env: -- "$@"`

eval set --  "$TEMP"
while true ; do
    case "$1" in
        -v|--vm)
            vm=$2 ; shift 2 ;;
	    -e|--env)
            env=$2 ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Error!" ; exit 1 ;;
    esac
done

if [[ -z $vm ]] || [[ -z $env ]]
then 
	echo "VM or ENV is null"
	exit 1
fi 

#### 2. Variable 

user="salinux" 
timestamp=$(date +%s)
logs="/var/log/puppet/${vm}.${timestamp}"
lcmd="sudo /usr/bin/tee -a ${logs}"
env=`echo $env|awk '{print tolower($0)}'`

pass=$(/opt/keys/password_pp.rb 'WZi8ZR33x48Zb3qPxzFLWGNktnuOJCKtgVJXSXJpUuES7szYWpZ/tCAgSj34
WObl545B23VdJoAecPbhEX5ndWXBj0nhFmrJcXZGapaSzx7MIK40mbyeEBHF
/DHcx50EPJYoHtaye6zvCbCBgyg6gidFRIZqtXrtfhAvnNdILLvrNZvLyW3t
Blg0L6fJKAj3WXlAJox+p+Kxhn6RvSaPlX03W2YHGWIB/mvyaSncFcQ10xJq
vQk7b6hkNteMghDRFMmoYkaNxDhITK88g9mmblQqKyE8iH6IsvUyI2dHTmc3
EugCxai626l6v+vPGC4mIvjU2xWsm+kW1aidAJ/slQ==')

arpass=$(/opt/keys/password_pp.rb 'L2Szu9vxbtd+wjBd39D13z9k7i3l6Hf/OBUIxCQEdWoOwg2U9cbNySZa8nE3
yzGhgpAEFs+POWHfmwFch0xJahr4NZYFLPnuvzg2nrW4heiXWoVUGqN+PICj
/r0Il8KsOhVTnWxGO9lK/6ubERkrD63NXDFzPWXBLcLovavr8/qDH7kSwGJ9
QlSOdqOL2mfyfbTZYBlqDbfVHN1/TFhRQqRel05OMQs5DEHMK7JMojThPQ8f
JfYnAM8eXcVV0wJMsvgJlbnB61KmhSszt5aeONBgDjUb50oyp9ADAPtsLPEF
HogruBDxEKLZbD52dP97hVeo5x0oek2umC8DlZ6whA==')

ca='cilt-prd-scripts1.vmware.com'

export SSHPASS=$pass


### 3. Functions
timestamp=$(date "+%Y.%m.%d-%H.%M.%S")

ars_check(){
    vmn=`echo $vm|awk -F '.' '{print $1}'`
    ldapsearch -x -b "dc=vmware,dc=com" -H ldap://10.188.192.10 -D "CN=svc.sssdcomp,OU=Generic,OU=ServiceAccounts,OU=Corp,OU=Common,DC=vmware,DC=com" \
    -w "$arpass" "(cn=$vmn)" dn | grep numEntries
    if [ $? -eq 0 ]; then
       echo "ARS Object Found, proceeding ...."
    else 
       echo "ARS Object not found, please create and re-run"
       exit 1
    fi
}

ars_join(){
echo "Joining AD Domain"
sshpass -v -e ssh -o "StrictHostKeyChecking no" -t ${user}@${vm}  "echo -e ${arpass} | sudo realm -v --membership-software=adcli join scrootdc11.vmware.com -U svc.sssdcomp"
sshpass -v -e ssh -o "StrictHostKeyChecking no" -t ${user}@${vm}  sudo realm list | grep vmware.com 
if [ $? -ne 0 ]
then
    echo "Did not join to Domain successfully, please check manually"
    exit 1
fi
}

scmd(){
    echo -e "\n\n########################### $1 ##################################\n\n"
    sshpass -v -e ssh  -o "StrictHostKeyChecking no" -t ${user}@${vm} $1 | $lcmd
}

cacmd(){
	echo -e "\n\n########################### $1 ##################################\n\n"
	#ssh -o "StrictHostKeyChecking no" -t root@${ca} $1 | $lcmd 
	sudo  $1 | $lcmd 
}

agent_install(){
  sshpass -v -e ssh -o "StrictHostKeyChecking no" -t ${user}@${vm}  <<'EOF'
    if [ ! -d /etc/yum.repos.d/backup ];
        then 
            sudo mkdir /etc/yum.repos.d/backup
            sudo mv -f /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
    fi
EOF


sshpass -v -e ssh  -o "StrictHostKeyChecking no" -t ${user}@${vm} "ls /etc/puppetlabs/puppet/ssl"
if [ $? -eq 0 ]
then
	sshpass -v -e ssh  -o "StrictHostKeyChecking no" -t ${user}@${vm} "sudo mv /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl.${timestamp}"
	cacmd "/opt/puppetlabs/bin/puppet cert sign $vm"
	cacmd "/opt/puppetlabs/bin/puppet cert clean $vm"
fi

 scmd "sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm"
 scmd "sudo yum install puppet-agent -y"
 scmd "sudo /opt/puppetlabs/bin/puppet agent --test --server $ca --environment=$env"
 sleep 10
}

agent_install_ub(){
        
        sshpass -v -e ssh  -o "StrictHostKeyChecking no" -t ${user}@${vm} "sudo ls /etc/puppetlabs/puppet/ssl"
        if [ $? -eq 0 ]
        then
         sshpass -v -e ssh  -o "StrictHostKeyChecking no" -t ${user}@${vm} "sudo mv /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl.${timestamp}"
         sudo /opt/puppetlabs/bin/puppetserver ca sign --certname $vm
         sudo /opt/puppetlabs/bin/puppetserver ca clean --certname $vm
        fi
        sshpass -v -e ssh -o "StrictHostKeyChecking no" -t ${user}@${vm}  <<'EOF'
        wget https://apt.puppet.com/puppet7-release-focal.deb
        sudo dpkg -i ./puppet7-release-focal.deb
        sudo apt update
        sudo apt-get install puppet-agent
        echo "$arspass"
        sudo echo "$arspass" | realm -v --membership-software=adcli join vmware.com -U svc.sssdcomp
EOF
        scmd "sudo /opt/puppetlabs/bin/puppet agent --test --server $ca --environment=$env"
        sleep 5
	sudo /opt/puppetlabs/bin/puppetserver ca sign --certname $vm
}


ca_sign() {
         #   cacmd "/opt/puppetlabs/bin/puppet cert clean $vm"
	    cacmd "/opt/puppetlabs/bin/puppetserver ca sign --certname $vm"
    }

run() {
	scmd "sudo /opt/puppetlabs/bin/puppet agent -d --test --server $ca --environment $env"
}

CentOS7(){
	agent_install
	ca_sign
	run
}

### 4. OS Idetifications and Configration functions for CentOS,Ubunti and SELS ###############

sshpass -v -e ssh -o "StrictHostKeyChecking no" -t ${user}@${vm}  <<'EOF'
os() {

lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS=`lowercase \`uname\``
KERNEL=`uname -r`
MACH=`uname -m`

OS=`uname`
        if  [ "${OS}" = "Linux" ] ; then
	       if [ -f /etc/oracle-release ] ; then
		   DistroBasedOn='Oracle'
		   DIST=`cat /etc/oracle-release |sed s/\ release.*//`
		   PSUEDONAME=`cat /etc/oracle-release | sed s/.*\(// | sed s/\)//`
		   REV=`cat /etc/oracle-release | sed s/.*release\ // | sed s/\ .*//`
               elif [ -f /etc/redhat-release ] ; then
                   DistroBasedOn='RedHat'
                   DIST=`cat /etc/redhat-release |sed s/\ release.*//`
                   PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
                   REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
               elif [ -f /etc/SuSE-release ] ; then
                   DistroBasedOn='SuSe'
                   PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
                   REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
               elif [ -f /etc/mandrake-release ] ; then
                   DistroBasedOn='Mandrake'
                   PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
                   REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
               elif [ -f /etc/debian_version ] ; then
                   DistroBasedOn='Debian'
                   DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
                   PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
                   REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
	       else 
		   echo "NO Repo available"
		   exit 1
        fi
        OS=`lowercase $OS`
        DistroBasedOn=`lowercase $DistroBasedOn`
         echo  "$OS $DIST $REV $PSUEDONAME" > /tmp/os
         echo  "$PSUEDONAME"

    fi
}

ostype=$(os)
echo "$ostype"
EOF

ostype=$(scmd "cat /tmp/os")
echo $ostype
ars_check
ars_join

if [[ $ostype == *"linux CentOS Linux 7"* ]] ; then
    CentOS7 
elif [[ $ostype == *"CentOS 6"* ]] ; then
	echo "Hello World!"
elif [[ $ostype == *"linux Oracle Linux Server 7"* ]] ; then
	CentOS7
elif [[ $ostype == *"Oracle Linux Server 6"* ]] ; then
	echo "Hello World!"
elif [[ $ostype == *"Oracle Linux Server 5"* ]] ; then
	echo "Hello World!"
elif [[ $ostype == *"SUSE Linux Enterprise Server 12"* ]] ; then
	echo "Hello World!"
elif [[ $ostype  == *"bionic"* ]] ; then
	echo "Hello World!"
elif [[ $ostype  == *"focal"* ]] ; then
        agent_install_ub
	run
else 
	echo "OS not recognized"
	exit 1
fi
