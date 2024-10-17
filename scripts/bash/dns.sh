#!/bin/bash

echo "=========================================================="
echo "NOTE: This script will configure DRAAS on the specified VM"
echo "=========================================================="
echo "Enter VM FQDN (Host Record) for which this script is being configured"
read vm

echo "Is $vm correct FQDN name?"
echo "Enter yes or no"
read response
if [ $response == yes ]; then
  echo $vm
elif [ $response == no ]; then
  echo "Re-Run the script and enter correct name"
else 
  echo "Please enter "yes" or "no" "
fi
