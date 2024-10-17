#!/bin/bash


exitfn () {
    echo
	stopped_msg='script is interuppted in middle'
	rm -rf /opt/repo-sync/lock_file/*;
	echo $stopped_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' kbl@vmware.com
    exit
}
trap 'exitfn' 1 2 9 15 19

##declaring the variables like date,time, directory to store the logs, summary file name
date=`date +%Y-%m-%d`
time=`date +%H-%M-%S`
metadata_dir=/var/log/repo-sync-logs/repo_sync_$date
#summary_file=$metadata_dir/summary.txt
summary_html=$metadata_dir/summary.html

##Check if mutt is installed on the sync server

which mutt &> /dev/null
status=$?
if [ $status -ne 0 ]
then
    failed_msg="Please install mutt on sync server" 
	echo $failed_msg
	echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' kbl@vmware.com 
	exit
fi

##Check if repolist file exist or not
RL=repolist
if [ ! -f "$RL" ]; then
	failed_msg="Rsync repolist file not found, please create it"
	echo $failed_msg
	echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' kbl@vmware.com 
	exit
fi

##Check if summary template file exist or not.
tmp=template.html
if [ ! -f "$tmp" ]; then
	failed_msg="Summary template file not found, please create it"
	echo $failed_msg
	echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' kbl@vmware.com 
	exit
fi


##Get the list of repos from repolist file and store it in array - distro_list
d_l=`awk '/----Repo-list----/{f=1; next} /----List-ends----/{f=0} f' repolist | awk -F "|" '{print $1}'`
distro_list=( $d_l )

##create log directory to store the logs
mkdir -p $metadata_dir

##create summary html page, which will be reported at the end of the script
cp $tmp $summary_html 
if [ $? -ne 0 ]
then
	failed_msg"summary report page not created,exiting the script"
        echo $failed_msg
        echo $failed_msg | mail -s "Repo sync script stopped" -r 'Repo-Sync <lps-repo-sync@vmware.com>' kbl@vmware.com
	exit
fi	
#echo -e "----SUCCESS----\n----FAILURE----" > $summary_file
#$sed -i '/<tbody>/,/<\/tbody>/d' $summary_html

##removes the content between tbody tags
sed -i '/<tbody>/,/<\/tbody>/{//!d}' $summary_html
failed_repo=( )



#summary_reporting(){
#        mail_id=kbl@vmware.com
#	failure_check=`sed -e '1,/----FAILURE----/ d' $summary_file |  awk '{print $1}'`
#	failure_count_check=`echo $failure_check | wc -l`
#	if [ $failure_count_check -ne 0 ]
#	then
#		local attachment
#		fc=( `sed -e '1,/----FAILURE----/ d' $summary_file | awk '{print $1}'`  )
#                for i in "${fc[@]}"; do attachment+=" -a "$metadata_dir/$i"_log ";done;
#        	mail_cmd=`echo mail -s \"Repo Sync Summary of $date\" ${attachment[@]} $mail_id "<" $summary_file `
#		echo $mail_cmd | bash
#	fi
#}

##This function will send a summary mail at the end to team, if any repo sync is failed.
summary_reporting(){
        mail_id=kbl@vmware.com
        if [  ! -z "${failed_repo[@]}" ]
        then
	#	subject="Subject: Repo Sync Summary $date"
	#	sed -i '/Content-Type/a '"$subject"'' $summary_html
        #        sendmail $mail_id < $summary_html
		local attachment
		for i in ${failed_repo[@]}
		do
			attachment+="-a $metadata_dir/$i""_log.txt "
		done
		cmd=`echo mutt $mail_id ${attachment[@]} -s \"Repo sync Summary $date\" -e \"set content_type=text/html\" -e \"my_hdr From:Repo-sync \<lps-repo-sync@vmware.com\>\" "<" $summary_html`
		echo $cmd | bash
        fi
}


##Iterate through the distro_list array, which will store the list of repos that needs to be synced from the upstream
for i in ${distro_list[@]}
do

distro=$i
sync_dir=`grep $distro repolist | awk -F "|" 'NR==1{print $3}'`
bkplogfile=$metadata_dir/$distro"_log.txt_bkp_"$time
logfile=$metadata_dir/$distro"_log.txt"
if [ -f "$logfile" ]; then
	mv $logfile $bkplogfile
fi
lock_file_dir=lock_file
lock_file=$lock_file_dir/$distro-lockfile
main_url=`grep $distro repolist | awk -F "|" 'NR==1{print $2}'`
sub_dirs=( `grep $distro repolist | awk -F "|" 'NR==1{print $4}'` )
status_file=$sync_dir/status.txt

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
}



##This function will be called before repo sync executed, to validate and meet the conditions
precheck(){

	echo -e "------------------------------Performing Pre-Checks------------------------------" >> $logfile

	echo -e "Checking sub repo directory exist" >> $logfile
	if [ ! -d $sync_dir ]
	then
		error_msg="$sync_dir doesn't exist, please create directory"
		echo -e $error_msg | tee -a $logfile
		script_status 1 "$error_msg" "$logfile"
		continue
	else
		echo -e $error_msg >> $logfile
		
	fi
	echo -e "Checking Disk space" >> $logfile
	ds=$(df $sync_dir | awk 'NR==2{print $5}' | tr '%' '\t')
	if (( ! $(echo "$ds <= 95" | bc -l) ));
	then
		error_msg="No Space left on $sync_dir, please clear the space"
		echo -e $error_msg | tee -a $logfile
		script_status 1 "$error_msg" "$logfile"
		exit;
	fi
	echo -e "$ds Gb is available on source file system" >> $logfile

	echo -e "Calculating Checksum before rsync" >> $logfile
	cs_old=$(find $sync_dir ! -name '*status.txt*' -xtype f -print0 | xargs -0 sha1sum | cut -b-40 | sort | sha1sum | awk '{print $1}')
	echo -e "Checksum Value: $cs_old" >> $logfile
	echo -e "Performing dry run to test the remote url " >> $logfile
	echo -e "Main Url:\n$main_url" >> $logfile
	echo -e "Sub repos path:\n${sub_dirs[@]}" >> $logfile
	local remote_url
	if [ -z $sub_dirs ]
	then
		remote_url+=$main_url" "
	else
		for i in "${sub_dirs[@]}"; do remote_url+=$main_url$i" ";done;
	fi
	dr_cmd=`echo rsync -avhRn --delete-delay --delay-updates --log-format='"rsync-stat: %t %i %f"' ${remote_url[@]} $sync_dir`
	echo $dr_cmd | bash > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		echo -e "Dryrun test performed Succesfully " >> $logfile	
	else
		error_msg="Dryrun failed please verify the URL remote once,\n $dr_cmd"
		echo -e $error_msg | tee -a $logfile
		script_status 1 
		continue
	fi
	echo
	> $status_file
	echo -e "Creating lock file" >> $logfile
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

	echo -e "------------------------------Performing Post-Checks------------------------------" >> $logfile
	echo -e "Calculating Check sum after rsync" >> $logfile
	cs_new=$(find $sync_dir ! -name '*status.txt*' -xtype f -print0 | xargs -0 sha1sum | cut -b-40 | sort | sha1sum | awk '{print $1}')
	echo -e "Checksum Value: $cs_new" >> $logfile
}

##Overall status check of the repo sync after it is executed successfully.
status_check(){

	echo -e "------------------------------Status-Check------------------------------" >> $logfile
	if [ "$cs_old" = "$cs_new" ]; then
		success_msg="No change is performed "
		echo -e $success_msg | tee -a $logfile $status_file
		script_status 0 "$success_msg"
		echo
		rm -f $lock_file
	else
		deleted_files=$(cat $logfile | grep deleting | awk '{print $5}' | wc -l)
		deleted_file_list=$(cat $logfile | grep deleting | awk '{print $5}' )
        new_files=$(cat $logfile | grep '>f++' | awk '{print $5}' | wc -l ) 
		new_file_list=$(cat $logfile | grep '>f++' | awk '{print $5}')
		updated_files=$(cat $logfile | grep '>f.st...' | awk '{print $5}' | wc -l)
		updated_list=$(cat $logfile | grep '>f.st...' | awk '{print $5}')
		new_dirs=$(cat $logfile | grep 'cd++++' | awk '{print $5}' | wc -l)
		new_dirs_list=$(cat $logfile | grep 'cd++++' | awk '{print $5}')
		transfer_size=$(cat $logfile | grep 'received:' | awk '{print $5}' | tr ',' '\0')
		echo -e "Deleted file: $deleted_files \nNewly Added File: $new_files\nNewly Added Directories: $new_dirs \nUpdated Files: $updated_files \n" >> $logfile
		echo -e "Deleted file: $deleted_files\n $deleted_file_list \nNewly Added File:$new_files  \n$new_file_list\nNewly Added Directories: $new_dirs\n$new_dirs_list \nUpdated Files: $updated_files  \n$updated_list \n" >> $status_file
		success_status="Repo sync completed"
		echo -e $success_status
		echo
		delete_lock_file
		script_status 0 "$success_status"
	fi
}

##Main Repo sync function 
copy_rsync () {
	echo
	echo -e "Initiating Rsync for $distro"
	precheck
#	echo -e "Initiating Rsync..."
	repo_start_time=$(date +"%d/%m/%Y-%T")
	echo -e "Repo Sync start time for $distro: $repo_start_time" | tee -a $logfile $status_file
	local remote_url
	if [ -z $sub_dirs ]
        then
                remote_url+=$main_url" "
        else
                for i in "${sub_dirs[@]}"; do remote_url+=$main_url$i" ";done;
        fi
	rsync_cmd=`echo rsync -avhiR --delete-delay --delay-updates --log-format='"rsync-stat: %t %i %f"' ${remote_url[@]} $sync_dir '>>' $logfile `
	echo $rsync_cmd | bash > /dev/null 2>&1
 	rsync_status=$?
	repo_stop_time=$(date +"%d/%m/%Y-%T")
	echo -e "Repo Sync stop time $distro: $repo_stop_time" | tee -a $logfile $status_file
	if [ $rsync_status -eq 0 ]; then
		postcheck
		status_check
	else
		error_msg="Repo Failed with unexpected error"
		delete_lock_file
		script_status 1 "$error_msg"
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
