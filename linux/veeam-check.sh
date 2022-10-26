#!/bin/sh

# checkmk localcheck for 'Veeam Agent for Linux 5.0'
#
# This script supports only the veeam states 'Success' and 'Failed'
# It works as a local check and is no full checkmk plugin
# feel free to open issues if you encounter any problems

# get tast 2 lines of veeam seesion list and remove line containing Total
lastSession=$(veeamconfig session list | tail -n 2 | grep -v Total)

# parse line and extract expected information
lastDate=$(echo $lastSession | awk -F' ' '{ print $8 }')
lastTime=$(echo $lastSession | awk -F' ' '{ print $9 }')

# check if last Backup Failed
lastFailed=$(echo $lastSession | grep Failed)

if [ -z "${lastFailed}" ]; then
    echo "0 \"VeeamBackup\" - Last Backup State: Success, $lastDate $lastTime"
else
    # parse last successful Backup line and add to output
    lastSuccessLine=$(veeamconfig session list | grep Success | tail -n 1)
    lastSuccessDate=$(echo $lastSuccessLine | awk -F' ' '{ print $7 }')
    lastSuccessTime=$(echo $lastSuccessLine | awk -F' ' '{ print $8 }')
    echo "2 \"VeeamBackup\" - Last Backup State: Failed, $lastDate $lastTime, Last Successful Backup: $lastSuccessDate $lastSuccessTime"
fi;



#!/bin/sh

lastSession=$(veeamconfig session list | tail -n 2 | grep -v Total)

lastDate=$(echo $lastSession | awk -F' ' '{ print $7 }')
lastTime=$(echo $lastSession | awk -F' ' '{ print $8 }')
failed=$(echo $lastSession | grep Failed)
if [ -z "${failed}" ]; then
    echo "0 \"VeeamBackup\" - Letztes Backup: $lastDate, $lastTime"
else
    lastSuccessLine=$(veeamconfig session list | grep Success | tail -n 1)
    lastSuccessDate=$(echo $lastSuccessLine | awk -F' ' '{ print $7 }')
    lastSuccessTime=$(echo $lastSuccessLine | awk -F' ' '{ print $8 }')
    echo "2 \"VeeamBackup\" - Letztes Backup fehlgeschlagen: $lastDate, $lastTime, Letztes erfolgreiche Backup: "
fi;



