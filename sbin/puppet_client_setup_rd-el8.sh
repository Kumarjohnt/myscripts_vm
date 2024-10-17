#!/bin/bash

# Puppet Integration v1.0
# sharmasachin@vmware.com
# May 1 2020

unset GEM_PATH GEM_HOME
#### 1. Options

uid=$(id -u)

if [[ $uid -eq 0 ]]
then
 echo -e "\nRoot is not allowed. \n"
 exit 1
fi



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

#pass=$(/opt/keys/password_pp.rb 'pCGEYB3xUmPRuHa7jiludZ9wUxScetwmJCPTu0mVV7TAT4Qwf+QGYoP0jqGh
#HiooUSRCusze1CGlqCy3hREWEeIpEmVwSNi/ohYYDSnlrRQqfTxMd37FCkFV
#mc6aNvp/onR4AC3Wo91kkvTq/VcFfQ2LYySFnGjN3taOQKqQDoq+lcBW+PYa
#p/1ZCDBp6HtT9djuYS21VeADa87hh8Lig2QdS4bQoJQes5CviE2IQq5qs4zM
#j64RXjALu9ryzY6M78M7d+b8Uo+cukDFa8BjggkcPnOm/5ewwJwIvF6SlwoK
#Y4YiBv+FLtbhmDnNNbMvYhikLGFId3D3ytiumlGdhA==')
pass='vmware123'
ca='cilt-prd-scripts1.vmware.com'
#export SSHPASS='vmware123'
export SSHPASS=$pass


### 3. Functions
timestamp=$(date "+%Y.%m.%d-%H.%M.%S")

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

# scmd "pwd; /bin/mkdir /etc/yum.repos.d/backup; mv -v /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup" 
# sshpass -v -e scp -o "StrictHostKeyChecking no"  $WORKSPACE/JenkinsBuilds/puppet/Puppet4_Agent.repo root@${vm}:/etc/yum.repos.d/
# scmd "/usr/bin/yum --enablerepo=Puppet4-Agent install puppet-agent -y"
 if [ $EL == '7' ]; then
 scmd "sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm"
 fi
 if [ $EL == '8' ]; then
 scmd "sudo rpm -ivh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm"
 fi
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
        sudo apt update
        wget http://linux-repo.vmware.com/ubuntu/agents/puppet-agent_7.14.0-1focal_amd64.deb
        sudo dpkg -i ./puppet-agent_7.14.0-1focal_amd64.deb
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

EL8(){
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

if [[ $ostype == *"linux CentOS Linux 7"* ]] ; then
    CentOS7 
elif [[ $ostype == *"CentOS 6"* ]] ; then
	echo "Hello World!"
elif [[ $ostype == *"linux Oracle Linux Server 7"* ]] ; then
        EL=7
	CentOS7
elif [[ $ostype == *"linux Oracle Linux Server 8"* ]] ; then
        EL=8
	EL8
elif [[ $ostype == *"linux AlmaLinux 8"* ]] ; then
        EL=8
	EL8
elif [[ $ostype == *"linux Rocky Linux 8"* ]] ; then
        EL=8
	EL8
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
