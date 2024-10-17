#!/bin/bash
quarterly_folders=("Jan" "Apr" "Jul" "Oct")
month=$(date +%b)
metadata_dir=/var/log/repo-sync-logs/deletion/repo_del_$month
mkdir -p $metadata_dir
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



function get_present_quarter()
{
	mon=$pm
	if [[ "$pm" -eq 12 ]] || [[ "$pm" -eq 3 ]] || [[ "$pm" -eq 9 ]] || [[ "$pm" -eq 6 ]]
	then
		mon=$(($pm-1))
	fi
        quarter=$(($mon/3))
	echo $quarter
}
function get_last_quarter()
{
	mon=$lqm
        if [[ "$lqm" -eq 12 ]] || [[ "$lqm" -eq 3 ]] || [[ "$lqm" -eq 9 ]] || [[ "$lqm" -eq 6 ]]
	then
		mon=$(($lqm-1))
	fi
	quarter=$(($mon/3))
	echo $quarter

}
pm=$(date +%m)
lm=$(date -d "$(date +%Y-%m-1) -1 month" +%-m)
lqm=$(date -d "$(date +%Y-%m-1) -3 month" +%-m)
#pm=$1
#lm=$2
#lqm=$3
get_pq=$(get_present_quarter $pm)
get_lq=$(get_last_quarter $lqm)
present_quarter=${quarterly_folders[$get_pq]}
last_quarter=${quarterly_folders[$get_lq]}
present_month=$(date +%b -d "$pm/01/1980")
last_month=$(date +%b -d "$lm/01/1980")
#month=$(date +%b)

logfile=$metadata_dir/$month'_log.txt'
logfile_bkp=$metadata_dir/$month'_log_bkp.txt'
if [ -f "$logfile" ]
then
        mv $logfile $logfile_bkp
fi



echo "------------------------------------Checking Month for data deletion--------------------------------" >> $logfile
for month in `echo Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec`
do
if [[ "$month" == "$present_quarter" ]] || [[ "$month" == "$last_quarter" ]] || [[ "$month" == "$present_month" ]] || [[ "$month" == "$last_month" ]]
then
	echo skipping /REPOS/monthly/$month from deletion | tee -a $logfile
else
	echo delete /REPOS/monthly/$month data | tee -a $logfile
	rm -rf /REPOS/monthly/$month/*
fi
done
echo -e "------------------------------------------------------------------------------------------------" >> $logfile
mail_id="kbl@vmware.com, maniyarm@vmware.com, urvashir@vmware.com, mithilas@vmware.com, muditj@vmware.com, pkarthi@vmware.com"
#mail_id="kbl@vmware.com"
cmd=`echo mutt $mail_id -a $logfile -s \"Repo Deletion Summary $mdate\" -e \"set content_type=text/html\" -e \"my_hdr From:Repo-sync \<lps-repo-sync@vmware.com\>\" "<" /dev/null`
echo $cmd | bash

