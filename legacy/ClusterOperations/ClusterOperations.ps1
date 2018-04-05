### [ Variable Definition ] ###
 
# define DNS servers
$nameServer1 = "192.168.1.53"
$nameServer2 = "192.168.2.53"
 
# define NTP servers
$ntpServer1 = "192.168.1.123"
$ntpServer2 = "192.168.2.123"
 
# define SMTP settings
$smtpServer = "192.168.1.25"
$smtpPort = "25"
$smtpFromAddress = "email [at] domain.com"
 
# define Storage parameters
$storagePool = "SP1"
$containerName = "NTNX-container001"
 
# Pulse verbosity type
# Options: BASIC, BASIC-COREDUMP, ALL, NONE
$pulseLevel = "ALL"
 
### [ Main ] ###
 
## set DNS servers ##
if( ($nameServer1.length -gt 0) -and ($nameServer2.length -gt 0) ) {
   # clean up old records
   [void](get-NTNXnameServer | remove-NTNXnameServer)
 
   write-host "Adding DNS servers: "$nameServer1","$nameServer2
   [void](add-NTNXnameServer -input $nameServer1)
   [void](add-NTNXnameServer -input $nameServer2)
 
} else {
   write-host "Adding DNS server: "$nameServer1
   [void](add-NTNXnameServer -input $nameServer1)
}
 
## set NTP servers ##
if( ($ntpServer1.length -gt 0) -and ($ntpServer2.length -gt 0) ) {
   # clean up old records
   [void](get-NTNXntpServer | remove-NTNXntpServer)
 
   write-host "Adding NTP servers: "$ntpServer1","$ntpServer2
   [void](add-NTNXntpServer -input $ntpServer1)
   [void](add-NTNXntpServer -input $ntpServer2)
} else {
write-host "Adding NTP server: "$ntpServer1
   [void](add-NTNXntpServer -input $ntpServer1)
}
 
## set SMTP server ##
if( $smtpServer -gt 0) {
   #clean up old records
   [void](remove-NTNXsmtpServer)
 
   write-host "Adding SMTP server: "$smtpServer
   [void](set-NTNXsmtpServer -address $smtpServer -port $smtpPort -fromEmailAddress $smtpFromAddress)
}
 
## create Storage ##
$array =@()
 
(get-ntnxdisk) |% {
   $hardware = $_
   write-host "Adding disk "$hardware.id" to the array"
   $array += $hardware.id
}
 
write-host "Creating a new storage: $storagePool"
new-NTNXStoragePool -name $storagePool -disks $array
$newStoragePool=get-NTNXStoragePool
 
write-host "Creating container: $containerName"
new-NTNXContainer -storagepoolid $newStoragePool.id -name $containerName
sleep 3
write-host "Adding container $containerName to ESXi hosts"
add-NTNXnfsDatastore -containerName $containerName
 
## set Pulse verbosity level ##
write-host "Setting Pulse verbosity level to: "$pulseLevel
[void](set-NTNXcluster -supportVerbosityType $pulseLevel)
