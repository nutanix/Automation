#Nutanix CVM RAM Add Script
#This script leverages The SSH.NET powershell module from http://www.powershelladmin.com/wiki/SSH_from_PowerShell_using_the_SSH.NET_library
#Download it at: http://www.powershelladmin.com/w/images/a/a5/SSH-SessionsPSv3.zip
#Script provided by Josh Sinclair (@vSinclairJ)
#Website http://joshsinclair.com/?p=410

Import-Module SSH-Sessions

#This script records the time to collect metrics on how long it takes to perform the memory upgrade.
$scriptStart = (Get-Date)

#Connect to the vCenter Servers
connect-viserver vc01.test.com

#Find all of the Nutanix CVMs that have less than 24GB RAM
$vms = Get-VM -name NTNX* | Where MemoryGB -lt 24

#Sort the CVMs by IP address (just to watch the CVMs be done in order)
$vms = $vms | Sort-Object guest.IPAddress[0]

#Loop though the CVMs and upgrade them one at a time
foreach ($vm in $vms) {
    
    #Use the IP address of the CVM to connect to it with SSH
    $CVM = $vm.guest.IPAddress[0]
    
    #Using the default user/pass
    New-SshSession -ComputerName $CVM -Username 'nutanix' -Password 'nutanix/4u'
    
    #Check to make sure that the CVMs in the cluster are all up. If a CVM is not UP it will be in DOWN state.
    $result = Invoke-SshCommand -ComputerName $CVM -Command '/home/nutanix/cluster/bin/cluster status | grep Down'
    Remove-SshSession -RemoveAll
    
    #Perform memory upgrade if there are no CVMs DOWN and SSH connection was successful
    If ($result -NotLike '*Down*' -and $result -notlike "*No SSH session found*") {
        write-host "Shutting down $CVM"
        Shutdown-VMGuest $vm -Confirm:$false
        
        #Wait a period of time to make sure the CVM is shutdown before changing settings
        sleep 60
        
        #Set CVM memory
        write-host "Setting $CVM Memory"
        Set-VM $vm -MemoryGB 24 -Confirm:$false
        
        #Power-on CVM
        write-host "Starting $CVM"
        Start-VM $vm -Confirm:$false
        
        #Wait for CVM to start before checking that it is UP
        sleep 60
        write-host "Checking $CVM state"
        
        #Check that the services are started on the CVM before performing the upgrade on the next CVM. From what I could tell by watching the services start, alert_manager is the last service to start.
        
        Do {
            New-SshSession -ComputerName $CVM -Username 'nutanix' -Password 'nutanix/4u'
            $result = Invoke-SshCommand -ComputerName $CVM -Command "/home/nutanix/cluster/bin/genesis status | grep alert_manager"
            Remove-SshSession -RemoveAll
            
            #If the services are not started yet they will have a status of []
            If ($result -contains 'alert_manager: []') {
            write-host "$CVM Down"}
            #Wait before attempting to make another SSH connection
            sleep 5
        }
        #If the service is started there will be port numbers in the brackets. Check to see if the brackets are empty. Make sure to escape the [] characters with `.
        Until ($result -notlike '*`[`]*' -and $result -notlike "*No SSH session found*")
        write-host "$CVM Up"
        $scriptEnd = (Get-Date)
        
        #Calculate the timespans
        $totalTime = New-Timespan -Start $scriptStart -End $scriptEnd
        
        #Write a time summary
        write-host "Total Script Time"
        write-host $totalTime
    }
    Else {
        #If a CVM is down at the beginning of the script, just end the script.
        write-host "Cluster not ready."
        Disconnect-VIServer -Confirm:$false
        Break
    }
}
Disconnect-VIServer -Confirm:$false