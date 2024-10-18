#!/bin/bash
DATE=$(date +%F_%H%M%S)
filename=$1
if [ "$#" -ne 1 ]; then
  echo "Usage: /opt/sbin/deployscripts/apache_deploy.sh <filename>"
  exit 270
fi

DEPLOY_DIR=/opt/deploy_conf_files/
#DEST_DIR - depends on the apache configuration. Please verify and update accordingly.

if [ $filename == httpd.conf ]
then
        DEST_DIR=/etc/httpd/conf/
        echo "!! HTTPD.CONF is not pushed by this script. Aborting execution..!!"
        exit 230
elif [ $filename == virtual.conf ]
then
        DEST_DIR=/etc/httpd/conf.d/
        echo "!! VIRTUAL.CONF is not pushed by this script. Contact Core-Infra-Linux Team. Aborting execution..!!"
        exit 240
else
        DEST_DIR=/etc/httpd/conf.d/
fi

if [ -f "$DEPLOY_DIR/$filename" ]; then
    echo "!! File found in $DEPLOY_DIR...Checking if the file exists in configuration directory. !!"

    if [ -f "$DEST_DIR/$filename" ]; then
        echo "$DEST_DIR/$filename exist"
        echo "!! Backing up the existing file - $filename with the timestamp appended to it !!"
        sudo cp -pf $DEST_DIR/$filename $DEST_DIR/backup/$filename.$DATE

        if [ -f "$DEST_DIR/backup/$filename.$DATE" ]; then
            echo "!! Backing up of the file locally is successfull. !!"
        else
            echo "!! Backup of file is failed....Aborting the execution... Please reach out to Linux Team. !!"
            exit 210
        fi

        sudo cp -pf $DEST_DIR/$filename $DEST_DIR/backup/$filename.last
        echo "!! Copying the file $filename to Apache Configuration Directory !!"
        sudo cp -f $DEPLOY_DIR/$filename $DEST_DIR/$filename

        if [ $? == 0 ]
        then
            echo "!! $filename successfully copied to Apache Configuration Directory. !!"
            echo "!! Deleting the file from deploy location. !!"
            sudo /usr/bin/rm -f $DEPLOY_DIR/$filename
            echo "!! Deleted file from Deploy Directory. !!"
            sudo -u salinux  /bin/bash /opt/sbin/rsync_pushconf.sh
        else
            echo "!! Copying of file $filename failed....Aborting the execution... Please reach out to Linux Team. !!"
            exit 215
        fi
    else
        echo "$filename does not exist in configuration directory. Please re-check and push the correct file, else reach out to Linux Team"
        echo "Deleting $filename from $DEPLOY_DIR"
        sudo /usr/bin/rm -f $DEPLOY_DIR/$filename
        exit 220
    fi

else
    echo "!! File not found in $DEPLOY_DIR. Please check if file is successfully copied from build server. !!"
    exit 225
fi

