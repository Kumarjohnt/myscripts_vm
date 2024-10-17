#!/bin/bash


mailid_list="kbl@vmware.com maniyarm@vmware.com urvashir@vmware.com mithilas@vmware.com muditj@vmware.com pkarthi@vmware.com"
#mailid_list="kbl@vmware.com"
exitfn () {
    echo
        stopped_msg='script is interuppted in middle'
        rm -rf /opt/repo-sync/lock_file/*;
        echo $stopped_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' $mailid_list
    exit
}
trap 'exitfn' 1 2 9 15 19

##declaring the variables like date,time, directory to store the logs, summary file name
mdate=`date +%Y-%m-%d`
mtime=`date +%H-%M-%S`
metadata_dir=/var/log/repo-sync-logs/dailysync/repo_sync_$mdate
ubuntu_data=$metadata_dir/ubuntu
#summary_file=$metadata_dir/summary.txt
summary_html=$metadata_dir/summary.html
new_month=`date --date="$(date +%Y-%m-15) +1 month" +'%b'`
#new_month="Apr"
new_month_repo=/REPOS/monthly/$new_month/
ls_log=$metadata_dir/ls_$new_month'_log.txt'
ls_log_bkp=$metadata_dir/ls_$new_month'_log.bkp.txt'
if [ -f "$ls_log" ]
then
	mv $ls_log $ls_log_bkp
fi

##Check if mutt is installed on the sync server

which mutt &> /dev/null
status=$?
if [ $status -ne 0 ]
then
    failed_msg="Please install mutt on sync server"
        echo $failed_msg
        echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' $mailid_list
        exit
fi

##Check if repolist file exist or not
RL=/opt/repo-sync/script/repo-sync/repolist
ARL=/opt/repo-sync/script/repo-sync/altr_list
if [ ! -f "$RL" ]; then
        failed_msg="Rsync repolist file not found, please create it"
        echo $failed_msg
        echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' $mailid_list
        exit
fi

##Check if summary template file exist or not.
tmp=/opt/repo-sync/script/repo-sync/template.html
if [ ! -f "$tmp" ]; then
        failed_msg="Summary template file not found, please create it"
        echo $failed_msg
        echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' $mailid_list
        exit
fi


##Get the list of repos from repolist file and store it in array - distro_list
d_l=`awk '/----Repo-list----/{f=1; next} /----List-ends----/{f=0} f' $RL | grep -v "^#" | awk -F "|" '{print $1}'`
distro_list=( $d_l )

##create log directory to store the logs
mkdir -p $metadata_dir

##create summary html page, which will be reported at the end of the script
cp $tmp $summary_html
if [ $? -ne 0 ]
then
        failed_msg"summary report page not created,exiting the script"
        echo $failed_msg
        echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' $mailid_list
        exit
fi
#echo -e "----SUCCESS----\n----FAILURE----" > $summary_file
#$sed -i '/<tbody>/,/<\/tbody>/d' $summary_html

##removes the content between tbody tags
sed -i '/<tbody>/,/<\/tbody>/{//!d}' $summary_html
failed_repo=( )



#summary_reporting(){
#        mail_id=kbl@vmware.com
#       failure_check=`sed -e '1,/----FAILURE----/ d' $summary_file |  awk '{print $1}'`
#       failure_count_check=`echo $failure_check | wc -l`
#       if [ $failure_count_check -ne 0 ]
#       then
#               local attachment
#               fc=( `sed -e '1,/----FAILURE----/ d' $summary_file | awk '{print $1}'`  )
#                for i in "${fc[@]}"; do attachment+=" -a "$metadata_dir/$i"_log ";done;
#               mail_cmd=`echo mail -s \"Repo Sync Summary of $mdate\" ${attachment[@]} $mail_id "<" $summary_file `
#               echo $mail_cmd | bash
#       fi
#}
get_ubuntu_status(){
	echo 
        echo -e "------------------------------Fetching Ubuntu Status------------------------------" 
        if [ ! -d $ubuntu_data ]
        then
                mkdir -p $ubuntu_data
        fi
        ubuntu_log=$ubuntu_data/ubuntu_log.txt
        ubuntu_status=$ubuntu_data/status
        sudo scp  ubuntu-repo.vmware.com:$metadata_dir/* $ubuntu_data/ &> /dev/null 
	if [ $? -ne 0 ]
        then
                fetch_status="Fetching Ubuntu status failed, Please Check Manually"
		failed_repo+=" ubuntu "
		echo $fetch_status
                summary_msg="<tr class=\"failed\"><td>Ubuntu</td><td>$fetch_status</td>"
                sed -i '/<tbody>/a '"$summary_msg"'' $summary_html

        else
		echo -e "Ubuntu Status Fetched Successfully"
		chattr -i $ubuntu_status
                ubuntu_status=`cat $ubuntu_status`
                if [ "$ubuntu_status" -eq 0 ]
                then
                        duration=`cat $ubuntu_log | grep 'Duration took' | awk '{print $NF}'`
                        summary_msg="<tr class=\"success\"><td>Ubuntu</td><td> Repo sync completed and the duration took is $duration </td>"
                        sed -i '/<tbody>/a '"$summary_msg"'' $summary_html
                else
                        failed_repo+=" ubuntu "
                        summary_msg="<tr class=\"failed\"><td>Ubuntu</td><td> Repo sync failed, please refer attached log for more information</td>"
                        sed -i '/<tbody>/a '"$summary_msg"'' $summary_html
                fi
        fi
	echo "-------------------------------------------------------------------------------------------"

}


##This function will send a summary mail at the end to team, if any repo sync is failed.
summary_reporting(){
        mail_id="kbl@vmware.com, maniyarm@vmware.com, urvashir@vmware.com, mithilas@vmware.com, muditj@vmware.com, pkarthi@vmware.com"
	#mail_id="kbl@vmware.com"
	get_ubuntu_status
 #       if [  ! -z "${failed_repo[@]}" ]
  #      then
        #       subject="Subject: Repo Sync Summary $mdate"
        #       sed -i '/Content-Type/a '"$subject"'' $summary_html
        #        sendmail $mail_id < $summary_html
                local attachment
                for i in ${failed_repo[@]}
                do
			if [ "$i" == "ubuntu" ]
			then
				attachment+=" -a $ubuntu_log "
			else
                        attachment+="-a $metadata_dir/$i""_log.txt "
			fi
                done
                if [  ! -z "${failed_repo[@]}" ]
                then
                        cmd=`echo mutt $mail_id ${attachment[@]} -s \"CRITICAL - Repo Sync Failed $mdate\" -e \"set content_type=text/html\" -e \"my_hdr From:Repo-sync \<lps-repo-sync@vmware.com\>\" "<" $summary_html`
                        echo $cmd | bash
                else
                        cmd=`echo mutt $mail_id ${attachment[@]} -s \"Repo sync Summary $mdate\" -e \"set content_type=text/html\" -e \"my_hdr From:Repo-sync \<lps-repo-sync@vmware.com\>\" "<" $summary_html`
                        echo $cmd | bash
                fi
   #     fi
	local_rsync_new_month
}



##Iterate through the distro_list array, which will store the list of repos that needs to be synced from the upstream
for i in ${distro_list[@]}
do

distro=$i
sync_dir=`grep $distro $RL | awk -F "|" 'NR==1{print $3}'`
bkplogfile=$metadata_dir/$distro"_log.txt_bkp_"$mtime
logfile=$metadata_dir/$distro"_log.txt"
if [ -f "$logfile" ]; then
        mv $logfile $bkplogfile
fi
lock_file_dir=/opt/repo-sync/lock_file
lock_file=$lock_file_dir/$distro-lockfile
main_url=`grep $distro $RL | awk -F "|" 'NR==1{print $2}'`
sub_dirs=( `grep $distro $RL | awk -F "|" 'NR==1{print $4}'` )
readme_file=/var/www/current/readme.txt

##This function writes the status of each repo to summary.html
script_status(){
        if [ $1 -eq 1 ]
        then
                failed_repo+=" $distro "
                summary_msg="<tr class=\"failed\"><td>$distro</td><td> Repo sync failed, please refer attached log for more information</td>"
                sed -i '/<tbody>/a '"$summary_msg"'' $summary_html
        elif [ $1 -eq 0 ]
        then
                s_t=`echo $repo_start_time | awk -F "-" '{print $2}'`
                e_t=`echo $repo_stop_time | awk -F "-" '{print $2}'`
                StartDate=$(date -u -d "$s_t" +"%s")
                FinalDate=$(date -u -d "$e_t" +"%s")
                duration=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S"`
                summary_msg="<tr class=\"success\"><td>$distro</td><td> $2 and the duration took is $duration </td>"
                sed -i '/<tbody>/a '"$summary_msg"'' $summary_html
        fi
        sleep 10
}


main_rsync(){
         r_u=("${@:3}")
         op=$1
         sd=$2
         rsync_cmd=`echo rsync $op --delete-delay --delay-updates --log-format='"rsync-stat: %t %i %f"' ${r_u[@]} $sd '>>' $logfile '2>&1'`
         echo $rsync_cmd | bash > /dev/null 2>&1
         rsync_status=$?
         if [ $rsync_status -eq 0 ]; then
                  echo 0
         else
                  echo $rsync_status
         fi
}

alternate_link_rsync(){
	ch_list=("${@:3}")
	ops="$2"
	dist="$1"
	al_list=`cat $ARL | awk '/----additional-repo-links----/{f=1; next} /----addtional-list-ends-----/{f=0} f' | grep $dist | awk -F '|' '{print $2}'`
	local remote_url
	local status
	local link
	if [ ! -z "${al_list[@]}" ]
	then
		for i in ${al_list[@]}
		do
			for j in ${ch_list[@]}
			do
				remote_url+=$i"./"$j" "
        		done
			echo -e "Trying rsync with URL: $i\n" > $logfile 2>&1
        		status=$(main_rsync $ops $sync_dir $remote_url)
        		if [ $status -eq 0 ]; then
               		 	link="$i"
                		break;
        		else
                		echo -e "Sync Failed for URL: $i \n" > $logfile 2>&1
                		remote_url=''
				link='failed'
        		fi
		done
		if [ '$link' == 'failed' ]
		then
			echo "$failed=$status"
		else
			echo "$link=yes"
		fi
	else
		echo "no-links"
	fi
}

##This function will be called before repo sync executed, to validate and meet the conditions
precheck(){

        echo -e "------------------------------Performing Pre-Checks for $distro------------------------------" | tee -a $logfile

        echo -e "Checking sub repo directory exist" | tee -a $logfile
        if [ ! -d $sync_dir ]
        then
                error_msg="$sync_dir doesn't exist, please create directory"
                echo -e $error_msg | tee -a $logfile
                script_status 1
                continue
        else
                echo -e $error_msg >> $logfile

        fi
        echo -e "Checking Disk space" | tee -a $logfile
        ds=$(df $sync_dir | awk 'NR==2{print $5}' | tr '%' '\t')
        if (( ! $(echo "$ds <= 95" | bc -l) ));
        then
                error_msg="File system usage is $ds %, please clear the space"
                echo -e $error_msg
                echo -e $error_msg  | mail -s "CRITICAL - Repo sync summary $mdate" -r 'Repo-Sync <lps-repo-sync@vmware.com>' $mailid_list 
                exit;
        fi
        echo -e "$ds % is available on source file system" | tee -a $logfile

#        echo -e "Calculating Checksum before rsync" >> $logfile
#        cs_old=$(find $sync_dir ! -name '*readme.txt*' -xtype f -print0 | xargs -0 sha1sum | cut -b-40 | sort | sha1sum | awk '{print $1}')
#        echo -e "Checksum Value: $cs_old" >> $logfile
        echo -e "Performing dry run to test the remote url " | tee -a $logfile
        echo -e "Main Url:\n$main_url" | tee -a $logfile
        echo -e "Sub repos path:\n${sub_dirs[@]}" | tee -a $logfile
        local remote_url
	local dr_rsync
        if [ -z $sub_dirs ]
        then
                remote_url+=$main_url" "
		options=-avhriSHn
        else
                for i in "${sub_dirs[@]}"; do remote_url+=$main_url"./"$i" ";done;
		options=-avhirRSHn
        fi
 	echo "Dry run start time: $(date +"%T")" | tee -a $logfile
#        dr_cmd=`echo rsync $options --delete-delay --delay-updates --log-format='"rsync-stat: %t %i %f"' ${remote_url[@]} $sync_dir`
#        echo $dr_cmd | bash > /dev/null &>> $logfile
        dr_cmd=$(main_rsync $options $sync_dir $remote_url)
        echo $dr_cmd
        if [ $dr_cmd -eq 0 ]
        then
                echo -e "Dryrun test performed Succesfully " | tee -a $logfile
		echo "Dry run stop time: $(date +"%T")" | tee -a $logfile
		main_link=$main_url
        else
		echo -e "Executing with alternative links " | tee -a $logfile
		dr_rsync=$(alternate_link_rsync $distro $options $sub_dirs)
		if [ $dr_rsync == "no-links" ]
		then
			error_msg="No Alternative links are found, Dryrun failed, Quitting the sync for $distro...."
			echo -e $error_msg | tee -a $logfile
			script_status 1
			continue
		else
			link_to_send=$(echo $dr_rsync | awk -F '=' '{print $1}')
			link_status=$(echo $dr_rsync | awk -F '=' '{print $2}')
			if [ $link_to_send == "failed" ]
			then 
                		error_msg="Tried with multiple links, Dryrun failed, Quitting the sync for $distro...."
                		echo -e $error_msg | tee -a $logfile
                		script_status 1
                		continue
			elif [ $link_status == "yes" ]
			then
				main_link=$link_to_send
				echo "Dry run stop time: $(date +"%T")" | tee -a $logfile
				echo -e "Main URL Changed to:\n$main_link"
				link_status=''
			else
				error_msg="Dryrun failed, Quitting the sync for $distro...."
				echo -e $error_msg | tee -a $logfile
				script_status 1
				continue
        		fi
		fi
	fi
        echo
        echo -e "Creating lock file" | tee -a $logfile
        if [ ! -d ${lock_file_dir} ]; then
                mkdir -p $lock_file_dir
                touch $lock_file
        else
                touch $lock_file
        fi

}

##used to delete the lock file created for each repo which is sync, usually the lock file is created to avoid the parellel rsync of same repo
delete_lock_file(){
        rm -f $lock_file
}


##This function will be executed, after the completion of rsync
postcheck(){

        echo -e "------------------------------Performing Post-Checks------------------------------" | tee -a $logfile
        echo -e "Calculating Check sum after rsync" >> $logfile
        cs_new=$(find $sync_dir ! -name '*readme.txt*' -xtype f -print0 | xargs -0 sha1sum | cut -b-40 | sort | sha1sum | awk '{print $1}')
        echo -e "Checksum Value: $cs_new" >> $logfile
}

##Overall status check of the repo sync after it is executed successfully.
status_check(){
	s_t=`echo $repo_start_time | awk -F "-" '{print $2}'`
	e_t=`echo $repo_stop_time | awk -F "-" '{print $2}'`
	StartDate=$(date -u -d "$s_t" +"%s")
	FinalDate=$(date -u -d "$e_t" +"%s")
	duration=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S"`
        echo -e "------------------------------Status-Check------------------------------" >> $logfile
       
	deleted_files=$(cat $logfile | grep deleting | awk '{print $5}' | wc -l)                
	deleted_file_list=$(cat $logfile | grep deleting | awk '{print $5}' )
        new_files=$(cat $logfile | grep '>f++' | awk '{print $5}' | wc -l )
        new_file_list=$(cat $logfile | grep '>f++' | awk '{print $5}')
        updated_files=$(cat $logfile | grep '>f.st...' | awk '{print $5}' | wc -l)
        updated_list=$(cat $logfile | grep '>f.st...' | awk '{print $5}')
        new_dirs=$(cat $logfile | grep 'cd++++' | awk '{print $5}' | wc -l)
        new_dirs_list=$(cat $logfile | grep 'cd++++' | awk '{print $5}')
        transfer_size=$(cat $logfile | grep 'received:' | awk '{print $5}' | tr ',' '\0')
	echo -e "This is daily repo sync and last synced on ${repo_stop_time}" > $readme_file
#	echo $deleted_files $new_files $updated_files $new_dirs
	echo -e "Changing the ownership of the repo"
        chown -R root:root $sync_dir &>> $logfile
        if [ $? -ne 0 ]
        then
                error_msg="Change in ownership for the directory $sync_dir failed, please change it manually"
		echo $error_msg | tee -a $logfile
                delete_lock_file
                script_status 1
                continue
        else
	if [[ $deleted_files -eq 0 ]] && [[ $new_files -eq 0 ]] && [[ $updated_files -eq 0 ]] && [[ $new_dirs -eq 0 ]]; then
                success_msg="No change is performed "
                echo -e $success_msg | tee -a $logfile
                script_status 0 "$success_msg"
                echo
                rm -f $lock_file
        else
                echo -e "Deleted file: $deleted_files \nNewly Added File: $new_files\nNewly Added Directories: $new_dirs \nUpdated Files: $updated_files \n" >> $logfile
                success_status="Repo sync completed"
                echo -e $success_status
                echo
                delete_lock_file
                script_status 0 "$success_status"
        fi
	fi
	echo "-------------------------------------------------------------------------------------------" | tee -a $logfile

}

##Main Repo sync function
copy_rsync () {
        echo
	precheck
	echo -e "------------------------------Initiating Rsync for $distro------------------------------" | tee -a $logfile
#        echo -e "Initiating Rsync for $distro"
#       echo -e "Initiating Rsync..."
        repo_start_time=$(date +"%d/%m/%Y-%T")
        echo -e "Repo Sync start time for $distro: $repo_start_time" | tee -a $logfile
        local remote_url
        if [ -z $sub_dirs ]
        then
                remote_url+=$main_link" "
		options=-avhirSH
        else
                for i in "${sub_dirs[@]}"; do remote_url+=$main_link"./"$i" ";done;
		options=-avhirRSH
        fi
       #rsync_cmd=`echo rsync $options --delete-delay --delay-updates --log-format='"rsync-stat: %t %i %f"' ${remote_url[@]} $sync_dir '>>' $logfile '2>&1' `
        #echo $rsync_cmd | bash > /dev/null 2>&1
        rsync_status=$(main_rsync $options $sync_dir $remote_url)
        if [ $rsync_status -eq 0 ]; then
        #        postcheck
	        repo_stop_time=$(date +"%d/%m/%Y-%T")
        	echo -e "Repo Sync stop time $distro: $repo_stop_time" | tee -a $logfile
                status_check
        else
		echo -e "Executing with alternative links " | tee -a $logfile
		ac_rsync=$(alternate_link_rsync $distro $options $sub_dirs)
		if [ $ac_rsync == 'no-links' ]
		then
			error_msg="Tried with multiple links, Repo Sync failed, Quitting the sync for $distro...."
			echo -e $error_msg | tee -a $logfile
			delete_lock_file
			script_status 1
		else
			link_to_send=$(echo $dr_rsync | awk -F '=' '{print $1}')
			link_status=$(echo $dr_rsync | awk -F '=' '{print $2}')
       	       		if [ $link_to_send == 'failed' ]
              		then
               			error_msg="Tried with multiple links, Repo Sync failed, Quitting the sync for $distro...."
                      		echo -e $error_msg | tee -a $logfile
                      		delete_lock_file
                      		script_status 1
             		elif [ $link_status == 'yes' ]
              		then
                	      	echo "Repo Sync stop time: $(date +"%T")" | tee -a $logfile
                      		status_check
              		else
                      		error_msg="Dryrun failed, Quitting the sync for $distro...."
                      		echo -e $error_msg | tee -a $logfile
                      		delete_lock_file
                      		script_status 1
              		fi
		fi
        fi
}

local_rsync_new_month () {
	today_date=$(date +%d)
	if (( $today_date >= 1 )) && (( $today_date <= 4 ))
	then
		echo -e "No sync will be performed on 1st to 4th day of the month" | tee -a $ls_log
		exit 0
	else
	echo -e "------------------------------Initiating Local Rsync for $new_month------------------------------" | tee -a $ls_log
	excld=/opt/repo-sync/script/repo-sync/monthly_exclude
	if [ -f "$excld" ]
	then	
	lrs_nm=`echo rsync -avhiSH --delay-updates --delete-delay --exclude-from=\'$excld\' --log-format='"rsync-stat: %t %i %f"' '/REPOS/dailysync/' $new_month_repo '>>' $ls_log '2>&1' `
	echo $lrs_nm
	echo $lrs_nm | bash > /dev/null 2>&1
	if [ $? -eq 0 ]; then
        	echo -e "Local rsync from /REPOS/dailysync to $new_month_repo is performed successfully" | tee -a $logfile
        	echo -e "Scanning and deleting the readme.txt files" | tee -a $ls_log
		find $new_month_repo -name 'readme.txt' -exec rm -rvf {} \; >> $ls_log 2>&1
                if [ $? -eq 0 ]
		then
			echo -e "readme files are deleted succesfully" | tee -a $ls_log
		else
			echo -e "readme files are not deleted" | tee -a $ls_log
		fi
        else
	echo -e "Local rsync from /REPOS/dailysync to $new_month_repo is Failed, please try manually" | tee -a $logfile
	fi
	else
		echo -e "Local rsync from /REPOS/dailysync to $new_month_repo is Failed, as exclude list not found" | tee -a $logfile
	fi
	fi
}

##Before starting any repo-sync, it will validate if repo lock file exist. if so, the sync will not continue
if [ -f ${lock_file} ]; then
        echo "$distro repo sync in progress,please try after sometime."
else
        copy_rsync
fi

done

##summary will be reported, if there is any failed repo sync
summary_reporting
