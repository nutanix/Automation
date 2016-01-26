# kees@nutanix.com
# @kbaggerman on Twitter
# http://blog.myvirtualvision.com
# Created on December 24th, 2015

## VM Creation
# Setting Variables
$Name = "KBTestVM99"
$NumVcpus = "2"
$MemoryMB = "2048"

# Creating the VM
new-ntnxvirtualmachine -Name $Name -NumVcpus $NumVcpus -MemoryMB $MemoryMB

## Network Settings
# Get the VmID of the VM
$vminfo = Get-NTNXVM | where {$_.vmName -eq $Name}
$vmId = ($vminfo.vmid.split(":"))[2]

# Set NIC for VM on default vlan (Get-NTNXNetwork -> NetworkUuid)
$nic = New-NTNXObject -Name VMNicSpecDTO
$nic.networkUuid = "4405198a-8160-49a6-b4ab-ffbde7913f31"

# Adding a Nic
Add-NTNXVMNic -Vmid $vmId -SpecList $nic

## Disk Creation
# Setting the SCSI disk of 50GB on Containner ID 1025 (get-ntnxcontainer -> ContainerId)
$diskCreateSpec = New-NTNXObject -Name VmDiskSpecCreateDTO
$diskcreatespec.containerid = 1025
$diskcreatespec.sizeMb = 51200

# Creating the Disk
$vmDisk =  New-NTNXObject –Name VMDiskDTO
$vmDisk.vmDiskCreate = $diskCreateSpec

# Adding the Disk to the VM
Add-NTNXVMDisk -Vmid $vmId -Disks $vmDisk

