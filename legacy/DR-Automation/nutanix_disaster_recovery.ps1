# THIS SCRIPT REQUIRES THE NUTANIX POWERSHELL MODULES AND POWERSHELL VERSION 4.0

# Interface of Windows VMs needs to be named "Ethernet"

# VMs must be powered on

 

# 1.  Get list of VMs and IPs from a VMware Folder

# 2.  Check that all VMs are in the Protection Domain

# 3.  Change the IPs of the VMs and shut them down

# 4.  Change the static DNS entries

 

 

### DECLARE CONSTANTS ###

 

#Source Domain Controller

$dnsServer = "dc01.test.com"

 

#Establish PSSession to target Domain Controller

$s = new-PSSession -Computer $dnsServer

Import-PSSession -Session $s -Module DNSServer

 

# Need to load PowerCLI and Nutanix modules

Add-PSSnapin NutanixCmdletsPSSnapin

 

#Make sure that any previous Nutanix or vCenter sessions are disconnected

Disconnect-NTNXCluster *

Disconnect-VIServer * -Confirm:$false

 

#Name of target VMware folder

$folder = "DRTest"

 

#Name of the Protection Domain

$protectionDomain = "Test"

 

#Destination Network - 10.XXX.XXX.0

$destinationNet = "10.0.1.0"

$destinationNet = $destinationNet.Split(".")

 

#Destination DNS 01

$destinationDNS01 = "10.0.1.11"

$destinationDNS02 = "10.0.1.12"

 

#Nutanix Cluster IP

$nutanixClusterIP = "10.0.0.51"

 

#Source vCenter

$vCenter = "vc01.test.com"

 

### BEGIN SCRIPT ###

 

#Clear Powershell Console

clear

 

#Connect to vCenter

Connect-VIServer $vcenter

 

#Connect to the Nutanix Cluster

Connect-NutanixCluster -Server $nutanixClusterIP -UserName admin -Password admin -AcceptInvalidSSLCerts | Out-Null

 

#Get the names of the VMs in the target Folder

#Initialize an array to hold the names of the VMs in the folder

$folderVMs=@()

 

#Add the names of the VMs in the folder to the array

Foreach ($vm in (get-vm -Location $folder)) { $folderVMs = $folderVMs + $vm.Name }

 

#Initialize an array to hold the names of the VMs in the protection domain

$protectedVMs=@()

 

#Add the names of the VMs in the protection domain to the array

Foreach ($vm in (Get-NTNXVM | Where {$_.protectionDomainName -eq $protectionDomain} | Select vmName)) { $protectedVMs = $protectedVMs + $vm.vmName }

 

#compare the arrays of VMs to check if there are any missing VMs and add them to $missingVMs

$missingVMs = Compare-Object $folderVMs $protectedVMs

 

#Initialize an array to contain VMs that are in the folder but not in the protection domain

$pdMissing = @()

 

#Initialize an array to contain VMs that are in the protection domain but not in the folder

$folderMissing = @()

 

#Initialize an array to contain the DNS Updates

$dnsupdates = @()

 

#Iterate through $missingVMs and notify the user which VMs are missing

if ($missingVMs.Count -ne 0) {

foreach ($vm in $missingVMs)  {

if ($vm.SideIndicator -eq "<=")  {

$pdMissing = $pdMissing + $vm

}

if ($vm.SideIndicator -eq "=>")  {

$folderMissing = $folderMissing + $vm

}

}

echo "These VMs are in the $folder VMware Folder but not in the $protectionDomain protection domain."

foreach ($pdvm in $pdMissing)  { echo $pdvm.InputObject }

echo `n

echo "These VMs are in the $protectionDomain protection domain but not in the $folder VMware Folder."

foreach ($foldervm in $folderMissing)  { echo $foldervm.InputObject }

echo `n

#If there are missing VMs then end the script

break

}

 

#Pop up a dialog box to get the linux username and password and test that the linux credential actually works with a linux VM to prevent an epic fail

#if the credential fails then prompt for the password again

$crTest = "echo test"

do {$linuxCredential = Get-Credential -Username "root" -Message "Type the ROOT username and password for Linux machines"}

Until (Invoke-VMScript -VM (get-vm -Location $folder | where {$_.Guest.OSFullName.Contains("Linux")} | Sort)[0] -ScriptText $crTest -GuestCredential $linuxCredential)

 

 

#Get the IP Address of the VM, convert it into an array, and replace the source network with the destination network

Foreach ($vm in (get-vm -Location $folder | Sort))  {

$oldip = $vm.Guest.IPAddress[0]

$octets = $vm.Guest.IPAddress[0].Split(".")

#Create the new IP address from the destination network

$octets[0] = $destinationNet[0]

$octets[1] = $destinationNet[1]

$octets[2] = $destinationNet[2]

$newip = [string]::Join(".",$octets)

#Create the DNS Update

$dnsupdates += @{"OldIP" = $oldip; "NewIP" = $newip}

#Change the last octet to .1 for the gateway IP

$octets[3] = "1"

$vmgateway = [string]::Join(".",$octets)

 

#Check if the Guest OS is Windows and update the IP Address

if ($vm.Guest.OSFullName.Contains("Windows")) {

$chNet = "netsh interface ip delete dnsservers Ethernet all; netsh interface ip add dnsservers Ethernet $destinationDNS01; netsh interface ip add dnsservers Ethernet $destinationDNS02 index=2; netsh interface ip set address name=Ethernet static $newip 255.255.255.0 $vmgateway"

Invoke-VMScript -VM $vm -ScriptText $chNet

}

#Check if the Guest OS is Linux and update the IP Address

if ($vm.Guest.OSFullName.Contains("Linux")) {

$chNet = "/root/failover"

Invoke-VMScript -VM $vm -ScriptText $chNet -GuestCredential $linuxCredential

}

}

 

#Shutdown the VMs

Foreach ($vm in (get-vm -Location $folder))  {

Shutdown-VMGuest -VM $vm -Confirm:$false

}

 

#Update the static DNS A record for each VM

foreach ($dnsupdate in $dnsupdates)  {

$oldIP = [string]$dnsupdate.OldIP

$newIP = [string]$dnsupdate.NewIP

echo "Changing DNS Record $oldIP to $newIP"

$oldDNS = Get-DnsServerResourceRecord -zonename test.com -RRType A | where {$_.RecordData.IPv4Address -eq $oldip}

$newDNS = $oldDNS.Clone()

$newDNS.RecordData.IPv4Address = [ipaddress]$newip

Set-DnsServerResourceRecord -ZoneName "test.com" -OldInputObject $oldDNS -NewInputObject $newDNS

}

Remove-PSSession $s

 

Disconnect-NTNXCluster *

Disconnect-VIServer * -Confirm:$false

 

#Wait for the VMs to shut down

Sleep 60

 

 
