############################################################
##
## Script: Manually fingerprint vdisks
## Author: Steven Poitras
## Description: Manually fingerprint vdisks matching a
##	specific search term
## Language: PowerCLI
##
############################################################

# Import SSH module to connect to Nutanix via SSH
# source: http://www.powershelladmin.com/w/images/a/a5/SSH-SessionsPSv3.zip
Import-Module SSH-Sessions

# Data Inputs
$server = '99.99.99.99'
$user = "your prism user"
$password = read-host "Please enter the prism user password:" -AsSecureString
$searchString = "searchstring"
$end_offset_mb = "12288" #12 GB

# SSH inputs
$sshUser = 'nutanix'
$keyFile = 'path to your openssh_key'

# Connect to Nutanix Cluster
Connect-NutanixCluster -Server $server -UserName $user -Password ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))) -AcceptInvalidSSLCerts

# Get vdisks matching a particular VM search string
$vdisks = Get-VDisk | where {
$_.nfsFileName -match $searchString}

# Perform string formatting
$vdiskIDs = $vdisks | select name | %{
$_ -replace ".*:" -replace "}.*"}

# Find containers where vdisks reside
$containerIDs = $vdisks.containerId | select -uniq

# For each container make sure fingerprinting is enabled
$containerIDs | %{
    # If fingerprinting is disabled for the container turn it on
    if ($(Get-Container -Id $_).fingerPrintOnWrite -eq 'off') {
        Set-Container -Id $_ -FingerprintOnWrite 'ON'
    } else {
        # Fingerprinting already enabled
    }
}

# Connect to Nutanix cluster via SSH
New-SshSession -ComputerName $server -Username $sshUser -KeyFile $keyFile

# For each vdisk ID add fingerprints
$vdiskIDs | %{
    Invoke-SshCommand -InvokeOnAll -Command "source /etc/profile > /dev/null 2>&1; `
    vdisk_manipulator -vdisk_id=$_ --operation=add_fingerprints -end_offset_mb=$end_offset_mb"
}