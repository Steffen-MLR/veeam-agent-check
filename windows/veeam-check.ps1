
# checkmk localcheck for 'Veeam Agent for Microsoft Windows FREE' 
# 
# It works as a local check and is no full checkmk plugin
# feel free to open issues if you encounter any problems
# 

# Set Log Dir of Veeam Endpoint Backup

$logdir = "C:\ProgramData\Veeam\Endpoint"

# Get all Log Files of Jobs

$logfiles = Get-ChildItem -Path $logdir -Include Job.*.Backup.log -Recurse

# Filter out Logs of old Jobs
# Attention: This is only applicable if using the free Version, with only one Job
#            If you want to check multiple Tasks you should adapt this
$logfile = $logfiles | Sort-Object LastAccessTime -Descending | Select-Object -First 1

# Parse the Logfile and Extract the expected information
$line = (Select-String -Path $logfile -Pattern 'Job session .* has been completed' | Select-Object -Last 1).Line
$time = ($line | Select-String -Pattern "\[\d+.\d+.\d+ \d+:\d+:\d+\]").Matches[0].Value.trimstart("[").trimend("]")
$status = ($line | Select-String -Pattern "status: '[a-zA-Z]*'").Matches[0].Value.Split()[1].trim("'")

# Map to checkmk/nagios states
switch ($status) 
{
    Success {"0"}
    Warning {"1"}
    Failed {"2"}
}

# Output in checkmk localcheck Format
Write-Output "$statusNumber `"VeeamBackup`" - Last Backup State: $status, $time"